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
	class func decompileISO(printOutput: Bool = true, overwrite: Bool = false) -> String? {
		guard overwrite || !XGFolders.ISODump.exists else {
			return nil
		}
		let not = overwrite ? "" : "NOT "
        printg("decompiling ISO using wit. This will \(not)overwrite any existing files...")
        if !XGFiles.iso.exists {
            printg("ISO doesn't exist:", XGFiles.iso.path)
            return nil
        }
		let verbose = XGSettings.current.verbose ? " -v " : ""
		let overwriteFlag = overwrite ? " -o" : ""
		let args = "extract --raw\(verbose)\(overwriteFlag) \(XGFiles.iso.path.escapedPath) \(XGFolders.ISODump.path.escapedPath)"
        let output = GoDShellManager.run(.wit, args: args, printOutput: printOutput)
		printg("Decompilation finished.")
		return output
    }

	class func prepareForCompilation() {
		disableAntiModChecks()
	}

	@discardableResult
	class func exportFileFromISO(_ file: XGFiles, decode: Bool = true) -> Bool {
		XGFolders.ISOExport("").createDirectory()

		if let data = XGISO.current.dataForFile(filename: file.fileName) {
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
		let verbose = XGSettings.current.verbose ? "-v " : ""
        let overwrite = "-o"
		let args = "copy \(overwrite) \(verbose) \(XGFolders.ISODump.path.escapedPath) \(XGFiles.iso.path.escapedPath)"
        return GoDShellManager.run(.wit, args: args, printOutput: printOutput)
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
}












