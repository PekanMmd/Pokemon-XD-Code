//
//  PBRExtensions.swift
//  GoDToolCL
//
//  Created by The Steez on 24/12/2018.
//

import Foundation

extension XGString {
	var hasFurigana: Bool {
		return chars.contains(where: { (c) -> Bool in
			switch c {
			case .special(.id(1), _): // check for furigana character
				return true
			default:
				return false
			}
		})
	}

	func removeKanji() {
		// Looks for any instances of furigana. Uses the furigana as regular text and removes the kanji after it.
		var updatedChars = [XGUnicodeCharacters]()
		var includeCounter = 0
		var skipCounter = 0
		for char in chars {
			if includeCounter > 0 {
				updatedChars.append(char)
				includeCounter -= 1
			} else if skipCounter > 0 {
				skipCounter -= 1
			} else {
				switch char {
				case .unicode:
					updatedChars.append(char)
				case .special(.id(1), let args): // furigana
					includeCounter = args[0]
					skipCounter = args[1]
				default:
					updatedChars.append(char)
				}
			}
		}
		chars = updatedChars
	}
}

extension XGUtility {
	
	// extraction
	@discardableResult
	class func decompileISO(printOutput: Bool = true) -> String? {
        printg("decompiling ISO using wit. This will overwrite any existing files...")
        if !XGFiles.iso.exists {
            printg("ISO doesn't exist:", XGFiles.iso.path)
            return nil
        }
        let verbose = settings.verbose ? "-v " : ""
        let overwrite = "-o"
        let args = "extract --raw \(verbose) \(overwrite) \(XGFiles.iso.path) \(XGFolders.ISODump.path)"
        return GoDShellManager.run(.wit, args: args, printOutput: printOutput)
    }
    
	class func extractMainFiles() {
		XGFolders.setUpFolderFormat()
		
		printg("extracting required files...")
		let requiredFiles : [XGFiles] = region == .JP ?
			[.fsys("common"), .fsys("deck")] :
			[.fsys("common"), .fsys("mes_common"), .fsys("deck")]
		var fileMissing = false
		for file in requiredFiles {
			if !file.exists {
				printg("Error: required file '\(file.path)' doesn't exist")
				fileMissing = true
			}
		}
		if fileMissing {
            printg("At least one required file was missing, try unpacking the ISO first.")
            return
        }
		
		let fsys = XGFiles.fsys("deck").fsysData
		
		var tid = 0
		var pid = 0
		for i in 0 ..< fsys.numberOfEntries {
			if !XGFiles.dckt(i).exists {
				let data = fsys.decompressedDataForFileWithIndex(index: i)!
				
				if let type = XGDeckTypes(rawValue: data.getWordAtOffset(0)) {
					switch type {
						case .DCKA: data.file = .dcka
						case .DCKP: data.file = .dckp(pid); pid += 1
						case .DCKT: data.file = .dckt(tid); tid += 1
						case .none: data.file = .nameAndFolder("deck_\(i)", .Decks)
					}
					
				} else {
					data.file = .nameAndFolder("deck_\(i)", .Decks)
				}
				data.save()
			}
		}
		
		let common = XGFiles.fsys("common").fsysData
		let numberOfCommonBinaries = region == .JP ? 32 : 33
		for i in 0 ..< numberOfCommonBinaries {
			if !XGFiles.common(i).exists, let data = common.decompressedDataForFileWithIndex(index: i) {
				data.file = .common(i)
				data.save()
			}
		}

		for filename in
			["mes_common", "menu_btutorial",
			(region == .JP ? "menu_fight_s" : "mes_fight_e"),
			(region == .JP ? "menu_name2" : "mes_name_e")] {
				if XGFiles.fsys(filename).exists {
					if let msg = XGFiles.fsys(filename).fsysData.decompressedDataForFileWithIndex(index: 1) {
						msg.file = .msg(filename)
						msg.save()
					}
				}
		}

		if region == .JP {
			let filename = "common"
			if XGFiles.fsys(filename).exists {
				if let msg = XGFiles.fsys(filename).fsysData.decompressedDataForFileWithIndex(index: 35) {
					msg.file = .msg(filename)
					msg.save()
				}
			}
		}

		printg("extraction complete!")
		
	}

	class func prepareForCompilation() {}

	class func exportFileFromISO(_ file: XGFiles, decode: Bool = true) -> Bool {
		XGFolders.ISOExport("").createDirectory()

		if let data = ISO.dataForFile(filename: file.fileName) {
			if data.length > 0 {
				data.file = file
				if file.fileType == .fsys {
					let fsysData = data.fsysData
					fsysData.extractFilesToFolder(folder: file.folder, decode: decode)
				}
				data.save()
				return true
			}
		}
		return false
	}

	class func disableAntiModChecks() {
		// Modifies a function in main.dol to prevent the game from softlocking when the ISO has been modified.
		printg("Disabling anti modification code.")
		guard let dol = XGFiles.dol.data else {
			printg("File doesn't exist: \(XGFiles.dol.path)")
			return
		}
		// offset 0x8022965c in RAM (0x8021de60 JP)
		let offset: Int
		switch region {
		case .EU: offset = 0x2252bc
		case .JP: offset = 0x219Ac0
		case .US: offset = 0x229E44
		case .OtherGame: offset = 0
		}

		dol.replace4BytesAtOffset(offset, withBytes: 0x48000100)
		dol.save()
	}

	@discardableResult
	class func compileISO(printOutput: Bool = true) -> String? {
		disableAntiModChecks()

        printg("compiling ISO...\nThis will overwrite the existing ISO")
        let verbose = settings.verbose ? "-v " : ""
        let overwrite = "-o"
        let args = "copy \(overwrite) \(verbose) \(XGFolders.ISODump.path) \(XGFiles.iso.path)"
        return GoDShellManager.run(.wit, args: args, printOutput: printOutput)
    }
	
	class func getFSYSForIdentifier(id: UInt32) -> XGFsys? {
		for file in XGFolders.FSYS.files where file.fileName.contains(".fsys") {
			let fsys = file.data!
			let entries = fsys.get4BytesAtOffset(kNumberOfEntriesOffset)
			
			for i in 0 ..< entries {
				let details = fsys.get4BytesAtOffset(0x60)
				let identifier = fsys.getWordAtOffset(details + (i * kSizeOfArchiveEntry))
				if identifier == id {
					return file.fsysData
				}
			}
			
		}
		return nil
	}


	// for gc compatibility
	class func exportDatFromPKX(pkx: XGMutableData) -> XGMutableData {
		return XGMutableData()
	}

	class func importDatToPKX(dat: XGMutableData, pkx: XGMutableData) -> XGMutableData {
		return XGMutableData()
	}
	
}


extension XGUtility {
	//MARK: - Documentation
	class func documentXDS() { }
	class func documentMacrosXDS() { }
	class func documentXDSClasses() { }
	class func documentXDSAutoCompletions(toFile file: XGFiles) { }
	
	private static var isDocumentingISO = false
	private static var shouldCancelDocumentation = false
	static func cancelDocumentation() {
		shouldCancelDocumentation = true
	}
	class func documentISO() {

		guard !isDocumentingISO else {
			printg("Already Documenting ISO!")
			return
		}

		isDocumentingISO = true
		shouldCancelDocumentation = false
		printg("Documenting ISO.\nThis may take a while...")
		XGThreadManager.manager.runInBackgroundAsync {
			printg("Documenting Enumerations...")
			// Enumerations
			if !shouldCancelDocumentation {
				printg("Enumerating Abilities...")
				XGAbilities.documentEnumerationData()
			}
			if !shouldCancelDocumentation {
				printg("Enumerating B-G Enumerations...")
				XGContestAppeals.documentEnumerationData()
				XGDecks.documentEnumerationData()
				XGDeoxysFormes.documentEnumerationData()
				XGEffectivenessValues.documentEnumerationData()
				XGEvolutionMethods.documentEnumerationData()
				XGExpRate.documentEnumerationData()
				XGGenderRatios.documentEnumerationData()
				XGGenders.documentEnumerationData()
			}
			if !shouldCancelDocumentation {
				printg("Enumerating Items...")
				XGItems.documentEnumerationData()
				XGItem.documentData()
			}
			if !shouldCancelDocumentation {
				printg("Enumerating Moves...")
				XGMoves.documentEnumerationData()
				XGMove.documentData()
			}
			if !shouldCancelDocumentation {
				printg("Enumerating M-N Enumerations...")
				XGMoveCategories.documentEnumerationData()
				XGMoveEffectTypes.documentEnumerationData()
				XGMoveTargets.documentEnumerationData()
				XGMoveTypes.documentEnumerationData()
				XGNatures.documentEnumerationData()
			}
			if !shouldCancelDocumentation {
				printg("Enumerating Pokemon...")
				XGPokemon.documentEnumerationData()
				XGPokemonStats.documentData()
			}
			if !shouldCancelDocumentation {
				printg("Enumerating TMs...")
				XGTMs.documentEnumerationData()
			}

			if !shouldCancelDocumentation {
				printg("Finished Documenting ISO.")
			} else {
				printg("Cancelled Documenting ISO.")
			}
			isDocumentingISO = false
		}

	}
}












