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
				XGISO.current.deleteFileAndPreserve(name: file, save: true)
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
	var isInitialRandomisation = true

	var randomisePokemon = false
	var randomiseMoves = false
	var randomiseTypes = false
	var randomiseAbilities = false
	var randomiseStats = false
	var randomiseMoveTypes = false
	var randomiseTMs = false
	var randomiseEvolutions = false

	var randomiseShadowsOnly = false
	var randomiseByBST = false
	var randomiseBingo = false

	var options = [String]()
	options += [
		game == .PBR ? " 1: Randomize Rental and Colosseum Pokemon"
			: " 1: Randomize All Trainer/Wild Pokemon"
	]
	options += [
		game == .PBR ? " 2: Setting - Randomize Rental Pass Pokemon Only"
			: " 2: Setting - Randomize Shadow Pokemon Only"
	]
	options += [
		" 3: Setting - Randomize Pokemon Using Similar BST",
		" 4: Randomize Moves",
		" 5: Randomize Pokemon Types",
		" 6: Randomize Abilities",
		" 7: Randomize Pokemon Base Stats",
		" 8: Randomize Move Types"
	]

	if game != .PBR {
		options += [
			" 9: Randomize TM and Tutor Moves",
			"10: Randomize Evolutions"
		]
	}

	if game == .XD {
		options += ["11: Randomize Battle Bingo"]
	}

	while true {
		var prompt = "Select your randomization settings then enter 'start' to start the randomization:\n\n 0: exit\n"
		options.forEach { (option) in
			prompt += option + "\n"
		}
		prompt += "\n"
		prompt += "Options selected: "
		if randomisePokemon {
			prompt += "Pokemon"
			if randomiseByBST {
				prompt += " randomised to similar BSTs"
			}
			if randomiseShadowsOnly {
				prompt += game == .PBR ? " (Rentals only)" : " (Shadows only)"
			}
			prompt += ","
		}
		if randomiseMoves {
			prompt += " Moves,"
		}
		if randomiseTypes {
			prompt += " Pokemon types,"
		}
		if randomiseAbilities {
			prompt += " Abilities,"
		}
		if randomiseStats {
			prompt += " Pokemon stats,"
		}
		if randomiseEvolutions {
			prompt += " Evolutions,"
		}
		if randomiseMoveTypes {
			prompt += " Move types,"
		}
		if randomiseTMs {
			prompt += " TMs"
			if game == .XD {
				prompt += " and Tutor moves"
			}
			prompt += ","
		}
		#if GAME_XD
		if randomiseBingo {
			prompt += " Battle bingo cards,"
		}
		#endif
		prompt.removeLast()

		let input = readInput(prompt)
		if input.lowercased() == "start" {
			#if !GAME_PBR
			if isInitialRandomisation {
				XGUtility.deleteSuperfluousFiles()
				settings.increaseFileSizes = true
				isInitialRandomisation = false
			}
			#endif

			if randomisePokemon {
				XGRandomiser.randomisePokemon(limitToMainMons: randomiseShadowsOnly, similarBST: randomiseByBST)
			}
			if randomiseMoves {
				XGRandomiser.randomiseMoves()
			}
			if randomiseTypes {
				XGRandomiser.randomiseTypes()
			}
			if randomiseAbilities {
				XGRandomiser.randomiseAbilities()
			}
			if randomiseStats {
				XGRandomiser.randomisePokemonStats()
			}
			if randomiseEvolutions {
				XGRandomiser.randomiseEvolutions()
			}
			if randomiseMoveTypes {
				XGRandomiser.randomiseMoveTypes()
			}
			if randomiseTMs {
				XGRandomiser.randomiseTMs()
			}
			#if GAME_XD
			if randomiseBingo {
				XGRandomiser.randomiseBattleBingo()
			}
			#endif

			XGUtility.compileMainFiles()

			displayAlert(title: "Randomisation complete", description: "The ISO is now ready.")

			randomisePokemon = false
			randomiseMoves = false
			randomiseTypes = false
			randomiseAbilities = false
			randomiseStats = false
			randomiseMoveTypes = false
			randomiseTMs = false
			randomiseEvolutions = false
			randomiseShadowsOnly = false
			randomiseByBST = false
			randomiseBingo = false

			continue
		}
		let index = input.integerValue
		if index == nil || index! < 0 || index! > options.count {
			printg("Invalid option:", input)
			continue
		}

		switch index {
		case 0: return
		case 1: randomisePokemon.toggle()
		case 2: randomiseShadowsOnly.toggle()
		case 3: randomiseByBST.toggle()
		case 4: randomiseMoves.toggle()
		case 5: randomiseTypes.toggle()
		case 6: randomiseAbilities.toggle()
		case 7: randomiseStats.toggle()
		case 8: randomiseMoveTypes.toggle()
		case 9: randomiseTMs.toggle()
		case 10: randomiseEvolutions.toggle()
		#if GAME_XD
		case 11: randomiseBingo.toggle()
		#endif
		default: printg("Invalid option:", input); continue
		}
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

func addFile() {
	while true {
		printg("\nAdd file to \(XGISO.inputISOFile?.path ?? "ISO")")

		let prompt = """
		Enter the path to the file you would like to add
		or enter 'exit' to go back
		"""

		let input = readInput(prompt)
		if input == "exit" {
			return
		} else {
			let file = XGFiles.path(input)
			if file.exists {
				if let uniqueID = GSFsys.shared.nextFreeFsysID() {
					XGISO.current.addFile(file, fsysID: uniqueID)
					printg("Done. Added file with new Fsys id: \(uniqueID)")
				} else {
					displayAlert(title: "Failed", description: "Couldn't add file to ISO. Couldn't genereate a new Fsys ID")
				}
			} else {
				displayAlert(title: "Failed", description: "File doesn't exist: \(file.path)")
			}
		}
	}
}

func utilities() {
	guard game == .PBR else {
		displayAlert(title: "Coming soon!", description: "There are no utilities for this game yet.")
		return
	}
	#if GAME_PBR
	while true {
		let prompt = """
		Type the number of the function you want and press enter:

		0: Back to main menu

		1: Increase number of pokemon slots in the game by 1
		2: Increase number of pokemon slots in the game by 10
		3: Increase number of pokemon slots in the game by 100
		"""
		let input = readInput(prompt)
		switch input {
		case "": continue
		case "0": return
		case "1": XGPatcher.increasePokemonTotal(by: 1)
		case "2": XGPatcher.increasePokemonTotal(by: 10)
		case "3": XGPatcher.increasePokemonTotal(by: 100)
		default: invalidOption(input)
		}
	}
	#endif
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
		5: Add File - Add a file to the ISO

		6: Patches - Pick some useful patches to apply to the game
		7: Utilities - Useful code functions to make updates to the game

		8: Randomiser - Select options for randomising the game (rebuild ISO after)

		9: Data Tables - Export, Import or Document game data like pokemon stats

		10: About - View version number and contact information
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
		case "5": addFile()
		case "6": applyPatches()
		case "7": utilities()
		case "8": randomiser()
		case "9": dataTablesMenu()
		case "10": showAbout()
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

