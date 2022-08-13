//
//  ColosseumExtensions.swift
//  Colosseum Tool
//
//  Created by The Steez on 04/06/2018.
//

import Foundation

extension XGUtility {
	
	class func prepareForCompilation() {
		fixUpTrainerPokemon()
	}

	class func importDatToPKX(dat: XGMutableData, pkx: XGMutableData) -> XGMutableData {
		//let gpt1Length = pkx.get4BytesAtOffset(4)
		let start = 0x40
		let pkxHeader = pkx.getCharStreamFromOffset(0, length: start)

		var datData = dat.charStream
		while datData.count % 16 != 0 {
			datData.append(0)
		}

		let oldDatLength = pkx.get4BytesAtOffset(0)
		var oldDatEnd = oldDatLength + 0x40
		while oldDatEnd % 16 != 0 {
			oldDatEnd += 1
		}

		let pkxFooter = pkx.getCharStreamFromOffset(oldDatEnd, length: pkx.length - oldDatEnd)

		let newPKX = XGMutableData(byteStream: pkxHeader + datData + pkxFooter, file: pkx.file)
		newPKX.replace4BytesAtOffset(0, withBytes: dat.length)
		return newPKX
	}

	class func exportDatFromPKX(pkx: XGMutableData) -> XGMutableData {
		//let gpt1Length = pkx.get4BytesAtOffset(4)
		let length = pkx.get4BytesAtOffset(0)
		let start = 0x40
		let charStream = pkx.getCharStreamFromOffset(start, length: length)
		let filename = pkx.file.fileName.removeFileExtensions() + ".dat"
		return XGMutableData(byteStream: charStream, file: .nameAndFolder(filename, pkx.file.folder))

	}
	
	//MARK: - Release configuration
	
	class func fixUpTrainerPokemon() {
		for deck in TrainerDecksArray {
			for poke in deck.allPokemon {
				let spec = poke.species.stats
				
				if spec.genderRatio == .maleOnly { poke.gender = .male }
				else if spec.genderRatio == .femaleOnly { poke.gender = .female }
				else if spec.genderRatio == .genderless { poke.gender = .genderless }
				else if poke.gender == .genderless { poke.gender = .female }
				
				if (spec.ability2.index == 0) && (poke.ability == 1) { poke.ability = 0 }
				
				poke.save(writeRelOnCompletion: false)
			}
		}
		XGFiles.common_rel.data?.save()
	}

	class func updateValidItems() {
		let itemListStart = kFirstValidItemOffset
		if let dol = XGFiles.dol.data {

			printg("Updating items list...")

			for i in 1 ..< kNumberOfItems {
				let currentOffset = itemListStart + (i * 2)

				if XGItems.index(i).nameID != 0 {
					dol.replace2BytesAtOffset(currentOffset, withBytes: i)
				} else {
					dol.replace2BytesAtOffset(currentOffset, withBytes: 0)
				}
			}

			dol.save()
		}
	}
	
	//MARK: - Documentation
	class func documentXDS() { }

	class func documentMacrosXDS() {

		printg("documenting script macros...")
		printg("This may take a while :-)")

		var text = ""

		func addMacro(value: Int, type: CMSMacroTypes) {
			let constant = CMSConstant.integer(value)
			#if GAME_COLO
			text += "define \(CMSExpr.macroConstant(constant, type).text(script: nil)) \(constant.description)\n"
			#else
			text += "define \(CMSExpr.macroConstant(constant, type)) \(constant.description)\n"
			#endif
		}

		for i in 0 ..< CommonIndexes.NumberOfPokemon.value {
			if i == 0 || XGPokemon.index(i).nameID > 0 {
				addMacro(value: i, type: .pokemon)
			}
		}
		for i in 0 ..< CommonIndexes.NumberOfMoves.value {
			if i == 0 || XGMoves.index(i).nameID > 0 {
				addMacro(value: i, type: .move)
			}
		}

//		for i in 0 ..< CommonIndexes.TotalNumberOfItems.value {
//			if i == 0 || (XGItems.index(i).scriptIndex == i && XGItems.index(i).nameID > 0) {
//				addMacro(value: i, type: .item)
//			}
//		}

		for i in 0 ..< kNumberOfAbilities {
			if i == 0 || XGAbilities.index(i).nameID > 0 {
				addMacro(value: i, type: .ability)
			}
		}

		for i in 0 ..< kNumberOfGiftPokemon {
			addMacro(value: i, type: .giftPokemon)
		}

		let people = XGFiles.fsys("people_archive").fsysData
		for i in 0 ..< people.numberOfEntries {
			let identifier = people.identifiers[i]
			addMacro(value: identifier, type: .model)
		}

		let rooms = XGFiles.json("Room IDs").json as! [String : String]
		var roomList = [(Int, String)]()
		for (id, room) in rooms {
			roomList.append((id.integerValue!, room))
		}
		roomList.sort { (t1, t2) -> Bool in
			return t1.1 < t2.1
		}
		for (id, _) in roomList {
			addMacro(value: id, type: .room)
		}

		let battleFieldsList = roomList.filter { (room) -> Bool in
			return room.1.contains("_bf")
		}
		for (id, _) in battleFieldsList {
			addMacro(value: id, type: .battlefield)
		}

		for i in 0 ... 3 {
			addMacro(value: i, type: .battleResult)
		}
		for i in 0 ... 4 {
			addMacro(value: i, type: .shadowStatus)
		}

		for i in 0 ..< CommonIndexes.NumberOfShadowPokemon.value {
			let mon = CMShadowData(index: i)
			if mon.species.index > 0 {
				addMacro(value: i, type: .shadowID)
			}
		}

//		for i in 0 ..< CommonIndexes.NumberOfSounds.value {
//			let sound = XGMusicMetaData(index: i)
//			if sound.sfxID == 0 {
//				let music = sound.music
//				if music.ishID == 0 && music.isdID == 0 && music.fsysID != 0 {
//					addMacro(value: i, type: .sfxID)
//				}
//			}
//		}

		// get macros.cms
		// file containing common macros to use as reference
		if text.length > 0 {
			let file = XGFiles.nameAndFolder("Common Macros.cms", .nameAndFolder("Sublime", .Reference))
			printg("writing script ", file.fileName, "to:", file.path)
			text.save(toFile: file)
		}

	}

	class func documentXDSClasses() { }

	class func documentXDSAutoCompletions(toFile file: XGFiles) {
		printg("Documenting CMS Autocompletions")
		var json = [String : AnyObject]()
		json["scope"] = "source.cmscript" as AnyObject
		var completions = [ [String: String] ]()

		for (_, data) in ScriptBuiltInFunctions {
			var completion = [String : String]()
			var trigger = "Standard." + data.name + "\t" + data.hint
			if let returnType = data.returnType {
				trigger += " -> \(returnType.typeName)"
			} else {
				trigger += " -> Unknown"
			}

			completion["trigger"] = trigger

			var contents = "Standard.\(data.name)("
			if let params = data.parameterTypes {
				for i in 0 ..< params.count {
					let param = params[i]
					contents += param == nil ? "/*Unknown*/ " : "/*\(param!.typeName)*/ "
				}
			}
			if contents.last! == " " {
				contents.removeLast()
			}
			contents += ")"


			completion["contents"] = contents
			completions.append(completion)
		}

		var macros = [CMSExpr]()

		for type in CMSMacroTypes.autocompletableTypes {
			for value in type.autocompleteValues {
				let constant = CMSConstant.integer(value)
				macros.append(.macroConstant(constant, type))
			}
		}

		for macro in macros {
			switch macro {
			case .macroConstant(let c, let t):
				let macroText = macro.text(script: nil)
				if macroText.length > 1 {
					let val = c.integerValue > 0xFF ? c.integerValue.hexString() + " // \(c.integerValue)" : c.integerValue.string + " // \(c.integerValue.hexString())"
					let contents = "define " + macroText + " \(val)"
					let trigger = contents + "\t" + t.typeName
					var completion = [String : String]()
					completion["trigger"] = trigger
					completion["contents"] = contents
					completions.append(completion)

					completion = [String : String]()
					completion["trigger"] = macroText + "\t" + t.typeName + " " + val
					completion["contents"] = macroText.substring(from: 1, to: macroText.count)
					completions.append(completion)
				}
			default:
				break
			}
		}

		json["completions"] = completions as AnyObject
		XGUtility.saveJSON(json as AnyObject, toFile: file)
	}
	
	class func documentISO() {
		
	}

	class func encodeISO() {
		
	}

	class func decodeISO() {

	}
	
}



























