//
//  main.swift
//  GoD CLI
//
//  Created by Stars Momodu on 17/10/2020.
//

import Foundation

func invalidOption(_ option: String) {
	printg("Invalid function number:", option)
}

func listFiles() {
	XGISO.current.allFileNames.forEach {
		printg($0)
	}
}

func importExportFiles() {
	var currentSearch = ""

	func searchedFiles() -> [String] {
		guard currentSearch.count > 0 else {
			return XGISO.current.allFileNames
		}
		return XGISO.current.allFileNames.filter { (name) -> Bool in
			return name.lowercased().contains(currentSearch.lowercased())
		}
	}

	func exportFiles(decode: Bool) {
		for file in searchedFiles() {
			let outputFile = XGFiles.nameAndFolder(file, .ISOExport(file.removeFileExtensions()))
			printg("Exporting file", file, "to:", outputFile.folder.path)
			if XGUtility.exportFileFromISO(outputFile, decode: decode) {
				printg("success")
			} else {
				printg("failed")
			}
		}
	}

	func importFiles(encode: Bool) {
		for file in searchedFiles() {
			let inputFile = XGFiles.nameAndFolder(file, .ISOExport(file.removeFileExtensions()))
			printg("Importing file", file, "from:", inputFile.folder.path)
			if XGUtility.importFileToISO(inputFile, encode: encode) {
				printg("success")
			} else {
				printg("failed")
			}
		}
	}

	func list() {
		searchedFiles().forEach { (file) in
			printg(file)
		}
	}

	while true {
		let searchText = currentSearch.count == 0 ? "all files" : "all files containing `\(currentSearch)`"

		let prompt = """
		Enter 'export' to extract \(searchText)
		Enter 'decode' to extract \(searchText)
					   and then decode the data in the exported file such as extracting textures from models and decompiling scripts

		Enter 'import' to import \(searchText)
		Enter 'encode' to import \(searchText)
						   after reencoding the files such as recompiling scripts and putting textures back into models

		Enter 'list' to list \(searchText)
		Enter 'exit' to go back
		Enter any other text to search for files containing that text
		"""
		let input = readInput(prompt)
		switch input {
		case "export": exportFiles(decode: false)
		case "decode": exportFiles(decode: true)
		case "import": importFiles(encode: false)
		case "encode": importFiles(encode: true)
		case "list": list()
		case "exit": return
		default: currentSearch = input
		}
	}
}

func applyPatches() {
	var prompt = "Select a patch to apply:\n\n0: exit\n"
	for i in 0 ..< patches.count {
		let patch = patches[i]
		prompt += "\(i + 1): \(patch.name)\n"
	}

	while true {
		let input = readInput(prompt)
		guard let index = input.integerValue, index >= 0, index <= patches.count else {
			printg("Invalid option:", input)
			continue
		}
		if index == 0 {
			return
		}
		let patch = patches[index - 1]
		XGDolPatcher.applyPatch(patch)
	}
}

func randomiser() {
	var options = [String]()
	if game != .PBR {
		options += [
			" 1: Randomise All Trainer/Wild Pokemon",
			" 2: Randomise Moves",
			" 3: Randomise Pokemon Types",
			" 4: Randomise Abilities",
			" 5: Randomise Pokemon Base Stats",
			" 6: Randomise Evolutions",
			" 7: Randomise Move Types",
			" 8: Randomise TM Moves",
			" 9: Randomise Shadow Pokemon Only",
			"10: Randomise Pokemon Using Similar BST"
		]
	}
	if game == .XD {
		options += ["11: Randomise Battle Bingo"]
	}

	var prompt = "Select a randomisation option:\n\n0: exit\n"
	options.forEach { (option) in
		prompt += option + "\n"
	}

	var isInitialRandomisation = true

	while true {
		let input = readInput(prompt)
		guard let index = input.integerValue, index >= 0, index <= options.count else {
			printg("Invalid option:", input)
			continue
		}

		switch index {
		case 0: return
		#if !GAME_PBR
		case 1: XGRandomiser.randomisePokemon()
		case 2: XGRandomiser.randomiseMoves()
		case 3: XGRandomiser.randomiseTypes()
		case 4: XGRandomiser.randomiseAbilities()
		case 5: XGRandomiser.randomisePokemonStats()
		case 6: XGRandomiser.randomiseEvolutions()
		case 7: XGRandomiser.randomiseMoveTypes()
		case 8: XGRandomiser.randomiseTMs()
		case 9: XGRandomiser.randomisePokemon(shadowsOnly: true)
		case 10: XGRandomiser.randomisePokemon(similarBST: true)
		#endif
		#if GAME_XD
		case 11: if game == .XD { XGRandomiser.randomiseBattleBingo() } else { printg("Invalid option:", input); continue }
		#endif
		default: printg("Invalid option:", input); continue
		}

		#if !GAME_PBR
		if isInitialRandomisation {
			XGUtility.deleteSuperfluousFiles()
			settings.increaseFileSizes = true
			isInitialRandomisation = false
		}

		printg("Don't forget to rebuild the ISO in the main menu once you're done")
		#endif
	}
}

func singleDataTableMenu(forTable table: GoDStructTableFormattable) {
	while true {
		printg("\nCurrent Table: \(table.properties.name)")
		printg("File: \(table.file.path)")
		printg("Start Offset: \(table.firstEntryStartOffset.hexString()) (\(table.firstEntryStartOffset))")
		printg("Number of Entries: \(table.numberOfEntries.hexString()) (\(table.numberOfEntries))")
		printg("Entry Length: \(table.entryLength.hexString()) (\(table.entryLength))")

		let prompt = """
		Enter 'encode' to encode the table as an editable .csv text file
		Enter 'decode' to decode the table back into the game from the .csv files after editing
		Enter 'document' to create .yaml and .csv documentation files for reference
		Enter 'exit' to go back
		"""

		let input = readInput(prompt)
		switch input {
		case "decode": table.decodeCSVData()
		case "encode": table.encodeCSVData()
		case "document": table.documentCStruct(); table.documentEnumerationData(); table.documentData()
		case "exit": return
		default: continue
		}
	}
}

func singleMiscDocumentationMenu(tableClass: GoDCodable.Type) {
	while true {
		printg("Other Data Table format \(tableClass.className)")

		let prompt = """
		Enter 'encode' to encode the table as an editable .json text file
		Enter 'decode' to decode the table back into the game from the .json files after editing
		Enter 'document' to document as .txt files
		Enter 'exit' to go back
		"""

		let input = readInput(prompt)
		switch input {
		case "decode": tableClass.decodeData()
		case "encode": tableClass.encodeData()
		case "document": tableClass.documentData(); tableClass.documentEnumerationData()
		case "exit": return
		default: continue
		}
	}
}

func dataTablesMenu() {
	var prompt = "Select a data table\n\n0: exit\n"
	let allTables = TableTypes.allTables
	for i in 0 ..< allTables.count {
		let table = allTables[i]
		prompt += "\(i + 1): \(table.name)\n"
	}

	while true {
		let input = readInput(prompt)
		guard let index = input.integerValue, index >= 0, index <= allTables.count else {
			printg("Invalid option:", input)
			continue
		}
		if index == 0 {
			return
		} else {
			let table = allTables[index - 1]
			switch table {
			case .structTable(let table, _):
				singleDataTableMenu(forTable: table)
			case .codableData(let data):
				singleMiscDocumentationMenu(tableClass: data)
			}
		}
	}
}

func showAbout() {
	printg(aboutMessage())
	_ = readInput("Press enter to continue...")
}

func mainMenu() {
	while true {
		let option2 = game == .PBR ? "2: - (unavailable for PBR)" : "2: Delete unused files in the ISO. Use this if there is not enough space to rebuild the ISO."
		let prompt = """
		Type the number of the function you want and press enter:

		0: Exit the program

		1: Rebuild ISO - Use to put files edited by this tool back in the ISO
		\(option2)

		3: List files - List all files in the ISO
		4: Import/Export files - Use this to export files for manual editing and to reimport them

		5: Patches - Pick some useful patches to apply to the game

		6: Randomiser - Select options for randomising the game (rebuild ISO after)

		7: Data Tables - Export, Import or Document game data like pokemon stats

		8: About - View version number and contact information
		"""


		let input = readInput(prompt)
		switch input {
		case "": continue
		case "0": return
		case "1": if readInput("This will overwritee the ISO at \(XGFiles.iso.path)\nAre you sure? Y/N").lowercased() == "y" {
				XGUtility.compileMainFiles()
			}
		case "2": XGUtility.deleteSuperfluousFiles()
		case "3": listFiles()
		case "4": importExportFiles()
		case "5": applyPatches()
		case "6": randomiser()
		case "7": dataTablesMenu()
		case "8": showAbout()
		default: invalidOption(input)
		}
	}
}

func readInput(_ prompt: String) -> String {
	print("\n" + prompt, terminator: "\n\n>> ")
	return readLine() ?? ""
}

func decodeInputFiles(_ files: [XGFiles]) {
	fileDecodingMode = true
	for file in files {
		guard file.exists else {
			printg("File doesn't exist:", file.path)
			continue
		}

		printg("Decoding file:", file.path)
		switch file.fileType {
		case .msg:
			let table = file.stringTable
			let jsonFile = XGFiles.nameAndFolder(file.fileName + XGFileTypes.json.fileExtension, file.folder)
			if !jsonFile.exists {
				table.writeJSON(to: jsonFile)
				printg("Decoded:", jsonFile.path)
			} else {
				printg("File already exists:", jsonFile.path)
				if readInput("Overwrite? Y/N").lowercased() == "y" {
					table.writeJSON(to: jsonFile)
					printg("Decoded:", jsonFile.path)
				}
			}
		case .gtx, .atx:
			let gtxFile = XGFiles.nameAndFolder(file.fileName + XGFileTypes.png.fileExtension, file.folder)
			if !gtxFile.exists {
				file.texture.writePNGData()
				printg("Decoded:", gtxFile.path)
			} else {
				printg("File already exists:", gtxFile.path)
				if readInput("Overwrite? Y/N").lowercased() == "y" {
					file.texture.writePNGData()
					printg("Decoded:", gtxFile.path)
				}
			}
		case .fsys:
			let outputFolder = XGFolders.nameAndFolder(file.fileName.removeFileExtensions(), file.folder)
			if !outputFolder.exists {
				outputFolder.createDirectory()
				file.fsysData.extractFilesToFolder(folder: outputFolder, decode: true, overwrite: false)
			} else {
				file.fsysData.extractFilesToFolder(folder: outputFolder, decode: true, overwrite: readInput("Overwrite? Y/N").lowercased() == "y")
			}
		default: printg("Can't decode file:", file.path)
		}
	}
}

func main() {

	if !loadISO() {
		let args = CommandLine.arguments

		let files = args.map { (filename) -> XGFiles in
			let fileurl = URL(fileURLWithPath: filename)
			return fileurl.file
		}.filter{$0.fileType != .unknown}

		guard files.count > 0 else {
			return
		}

		decodeInputFiles(files)
	}

	let noDocumentsFolder = !XGFolders.Documents.exists
	XGFolders.setUpFolderFormat()
	if noDocumentsFolder {
		printg("Created folder structure at:", XGFolders.Documents.path)
	}

	mainMenu()
}

main()
printg("Press enter to close the tool...")
_ = readLine() // pause at end of execution

