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
		let exactMatch = XGISO.current.allFileNames.filter { (name) -> Bool in
			return name.lowercased() == currentSearch.lowercased()
		}
		if exactMatch.count > 0 {
			return exactMatch
		}
		return XGISO.current.allFileNames.filter { (name) -> Bool in
			return name.lowercased().contains(currentSearch.lowercased())
		}
	}

	func exportFiles(extract: Bool, decode: Bool) {
		for file in searchedFiles() {
			let outputFile = XGFiles.nameAndFolder(file, .ISOExport(file.removeFileExtensions()))
			printg("Exporting file", file, "to:", outputFile.folder.path)
			if XGUtility.exportFileFromISO(outputFile, extractFsysContents: extract, decode: decode) {
				printg("Successfully exported", outputFile.path)
			} else {
				displayAlert(title: "Failure", description: "Failed to  extract " + outputFile.path)
			}
		}
	}

	func importFiles(shouldImport: Bool, encode: Bool) {
		var importedAFile = false
		for file in searchedFiles() {
			let inputFile = XGFiles.nameAndFolder(file, .ISOExport(file.removeFileExtensions()))
			printg("Importing file", file, "from:", inputFile.folder.path)
			if XGUtility.importFileToISO(inputFile, shouldImport: shouldImport, encode: encode, save: false) {
				importedAFile = true
				printg("Successfully imported", inputFile.path)
			} else {
				displayAlert(title: "Failure", description: "Failed to  import " + inputFile.path)
			}
		}
		if importedAFile {
			XGISO.current.save()
		}
	}

	func deleteFiles() {
		guard searchedFiles().count > 0 else {
			printg("No files selected")
			return
		}
		var prompt = "Deleting files:\n"
		for file in searchedFiles() {
			prompt += file + "\n"
		}
		prompt += "\nAre you sure? y/n"

		let input =  readInput(prompt)
		if input.lowercased() == "y" || input.lowercased() == "yes" {
			for file in searchedFiles() {
				XGISO.current.deleteFile(name: file, save: true)
			}
		}
	}

	func list() {
		searchedFiles().forEach { (file) in
			printg(file)
		}
	}

	while true {
		let searchText = currentSearch.count == 0 ? "all ISO files" : "all ISO files containing `\(currentSearch)`"

		let prompt = """
		Enter 'export' to extract and then decode files from \(searchText)
		Enter 'extract' to only extract files without decoding for \(searchText)
		Enter 'decode' to only decode the files previously extracted from \(searchText)
		(decoding is used to decompile scripts, extract textures, convert textures to PNGs, etc.)

		Enter 'import' to encode and then import \(searchText)
		Enter 'insert' to only import files without reencoding for \(searchText)
		Enter 'encode' to only encode files decoded from \(searchText)

		Enter 'delete' to delete files containing \(searchText)

		Enter 'list' to list \(searchText)
		Enter 'exit' to go back
		Enter any other text to filter the list to only include files containing that text
		"""
		let input = readInput(prompt)
		switch input {
		case "export": exportFiles(extract: true, decode: true)
		case "extract": exportFiles(extract: true, decode: false)
		case "decode": exportFiles(extract: false, decode: true)
		case "import": importFiles(shouldImport: true, encode: true)
		case "insert": importFiles(shouldImport: true, encode: false)
		case "encode": importFiles(shouldImport: false, encode: true)
		case "delete": deleteFiles()
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
		XGPatcher.applyPatch(patch)
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

		displayAlert(title: "Randomisation complete", description: "Don't forget to rebuild the ISO in the main menu once you're done choosing all your options.")
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
		case "decode":
			table.decodeCSVData()
			#if !GAME_PBR
			if table.file.fileType == .raw {
				if let saveData = table.file.data {
					let gciFile = XGFiles.nameAndFolder(saveData.file.fileName.replacingOccurrences(of: ".raw", with: ""), saveData.file.folder)
					if gciFile.exists {
						XGSaveManager(file: gciFile, saveType: .gciSaveData).save()
					}
				}
			}
			#endif
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

