//
//  ColosseumExtensions.swift
//  Colosseum Tool
//
//  Created by The Steez on 04/06/2018.
//

import Foundation

extension XGUtility {

	class func extractMainFiles() {
		let mainFiles = [
			"Start.dol",
			"common.fsys",
			"field_common.fsys",
			"fight_common.fsys",
			"pocket_menu.fsys"
		]

		for filename in mainFiles {
			exportFileFromISO(.nameAndFolder(filename, .Documents), decode: false)
		}
	}
	
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
	}
	
	//MARK: - Documentation
	class func documentXDS() { }
	class func documentMacrosXDS() { }
	class func documentXDSClasses() { }
	class func documentXDSAutoCompletions(toFile file: XGFiles) { }
	
	class func documentISO() {
		
	}

	class func encodeISO() {
		
	}

	class func decodeISO() {

	}
	
}



























