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

	var randomiseStarters = false
	var randomiseObtainablePokemon = false
	var randomiseUnobtainablePokemon = false
	var randomiseMoves = false
	var randomiseTypes = false
	var randomiseAbilities = false
	var randomiseStats = false
	var randomiseMoveTypes = false
	var randomiseTMs = false
	var randomiseEvolutions = false
	var randomiseTreasure = false
	var randomiseBingo = false
	var randomiseTypeMatchups = false
	var randomiseShops = false
	var randomiseShinyHues = false

	var randomiseByBST = false
	

	var options = [String]()
	options += [
		game == .PBR ? " 1: Randomize Rental Pokemon"
			: " 1: Randomize Starter Pokemon"
	]
	options += [
		game == .PBR ? " 2: -"
			: " 2: Randomize Obtainable Pokemon"
	]
	
	options += [
		" 3: Randomize NPC Trainer Pokemon (unobtainable)",
		" 4: Setting - Randomize Pokemon Using Similar Base Stat Total (BST)",
		" 5: Randomize Moves",
		" 6: Randomize Pokemon Types",
		" 7: Randomize Abilities",
		" 8: Randomize Pokemon Base Stats",
		" 9: Randomize Move Types",
		"10: Randomize Type Matchups"
	]

	if game != .PBR {
		options += [
			"11: Randomize TM and Tutor Moves",
			"12: Randomize Evolutions",
			"13: Randomize Item Boxes",
			"14: Randomize Shop items",
			"15: Randomize Shiny Hues"
		]
	} else {
		options += [
			"11: Randomize TMs"
		]
	}

	if game == .XD {
		options += [
			"16: Randomize Battle Bingo"
		]
	}

	while true {
		var prompt = " 0: exit\n"
		options.forEach { (option) in
			prompt += option + "\n"
		}
		prompt += "\n"
		prompt += "Options selected: "
		if randomiseStarters {
			prompt += "Starter pokemon"
			if randomiseByBST {
				prompt += " (randomised to similar BSTs)"
			}
			prompt += ","
		}
		if randomiseObtainablePokemon {
			prompt += "Obtainable Pokemon"
			if randomiseByBST {
				prompt += " (randomised to similar BSTs)"
			}
			prompt += ","
		}
		if randomiseUnobtainablePokemon {
			prompt += "Unobtainable Pokemon"
			if randomiseByBST {
				prompt += " (randomised to similar BSTs)"
			}
			prompt += ","
		}
		if randomiseMoves {
			prompt += " Moves,"
		}
		if randomiseTypes {
			prompt += " Pokemon Types,"
		}
		if randomiseAbilities {
			prompt += " Abilities,"
		}
		if randomiseStats {
			prompt += " Pokemon Stats,"
		}
		if randomiseEvolutions {
			prompt += " Evolutions,"
		}
		if randomiseMoveTypes {
			prompt += " Move types,"
		}
		if randomiseTreasure {
			prompt += " Item Boxes,"
		}
		if randomiseShops {
			prompt += " Shop items,"
		}
		if randomiseShinyHues {
			prompt += " Pokemon Colours,"
		}
		if randomiseTypeMatchups {
			prompt += " Type Matchups,"
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
		prompt += "\n\nSelect your randomization settings then enter 'start' to start the randomization:"

		let input = readInput(prompt)
		if input.lowercased() == "start" {
			#if !GAME_PBR
			if isInitialRandomisation {
				XGUtility.deleteSuperfluousFiles()
				XGSettings.current.increaseFileSizes = true
				isInitialRandomisation = false
			}
			#endif

			if randomiseStarters || randomiseObtainablePokemon || randomiseUnobtainablePokemon {
				XGRandomiser.randomisePokemon(includeStarters: randomiseStarters, includeObtainableMons: randomiseObtainablePokemon, includeUnobtainableMons: randomiseUnobtainablePokemon, similarBST: randomiseByBST)
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
			if randomiseMoveTypes {
				XGRandomiser.randomiseMoveTypes()
			}
			if randomiseTMs {
				XGRandomiser.randomiseTMs()
			}
			if randomiseTypeMatchups {
				XGRandomiser.randomiseTypeMatchups()
			}
			#if !GAME_PBR
			if randomiseTreasure {
				XGRandomiser.randomiseTreasureBoxes()
			}
			if randomiseShops {
				XGRandomiser.randomiseShops()
			}
			if randomiseEvolutions {
				XGRandomiser.randomiseEvolutions()
			}
			#endif
			#if GAME_XD
			if randomiseShinyHues {
				XGRandomiser.randomiseShinyHues()
			}
			if randomiseBingo {
				XGRandomiser.randomiseBattleBingo()
			}
			#endif

			XGUtility.compileMainFiles()

			displayAlert(title: "Randomisation complete", description: "The ISO is now ready.")

			randomiseStarters = false
			randomiseObtainablePokemon = false
			randomiseUnobtainablePokemon = false
			randomiseMoves = false
			randomiseTypes = false
			randomiseAbilities = false
			randomiseStats = false
			randomiseMoveTypes = false
			randomiseTMs = false
			randomiseEvolutions = false
			randomiseTreasure = false
			randomiseByBST = false
			randomiseTreasure = false
			randomiseShops = false
			randomiseTypeMatchups = false
			randomiseShinyHues = false
			randomiseBingo = false

			continue
		}
		let index = input.integerValue
		if index == nil || index! < 0 || index! > options.count {
			printg("Invalid option:", input)
			continue
		}

		switch index {
		case 0:
			if isInitialRandomisation {
				if randomiseStarters || randomiseObtainablePokemon || randomiseUnobtainablePokemon || randomiseMoves || randomiseTypes || randomiseAbilities || randomiseStats || randomiseMoveTypes || randomiseTypeMatchups || randomiseTMs || randomiseEvolutions || randomiseTreasure || randomiseShinyHues || randomiseBingo {
					if readInput("You haven't run the randomiser yet, are you sure you want to leave? Y/N").lowercased() == "n" {
						printg("Don't forget to enter 'start' after you enter your randomiser options.")
						continue
					}
				}
			}
			return
		case 1: randomiseStarters.toggle()
		case 2: randomiseObtainablePokemon.toggle()
		case 3: randomiseUnobtainablePokemon.toggle()
		case 4: randomiseByBST.toggle()
		case 5: randomiseMoves.toggle()
		case 6: randomiseTypes.toggle()
		case 7: randomiseAbilities.toggle()
		case 8: randomiseStats.toggle()
		case 9: randomiseMoveTypes.toggle()
		case 10: randomiseTypeMatchups.toggle()
		case 11: randomiseTMs.toggle()
		#if !GAME_PBR
		case 12: randomiseEvolutions.toggle()
		case 13: randomiseTreasure.toggle()
		case 14: randomiseShops.toggle()
		#endif
		#if GAME_XD
		case 15: randomiseShinyHues.toggle()
		case 16: randomiseBingo.toggle()
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
		Enter 'document' to create .txt and .csv documentation files for reference
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
			#else
			if table.file == typeMatchupsStructTable.file {
				PBRTypeManager.updateTypeMatchupDolData(allowSizeIncrease: false)
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
				XGISO.current.addFile(file, fsysID: nil)
			} else {
				displayAlert(title: "Failed", description: "File doesn't exist: \(file.path)")
			}
		}
	}
}

func utilities() {

	while true {
		var prompt = """
		Type the number of the function you want and press enter:

		0: Back to main menu

		1: Set up Ironmon rules

		2: Extract all textures
		3: Extract all textures with Dolphin filenames
		"""

		#if !GAME_PBR
		prompt += """

		4: Increase NPC Pokemon levels by 10%
		5: Increase NPC Pokemon levels by 20%
		6: Increase NPC Pokemon levels by 50%
		7: Set all Pokemon to fluctuating exp curve
		"""
		#endif

		#if GAME_COLO
		prompt += """

		8: Decode Ereader Cards
		-      Place your decrypted E Reader cards in \(XGFolders.Decrypted.path)
		-      then use this utility to output the decoded data for those cards in \(XGFolders.Decoded.path)
		9: Encode Ereader Cards
		-      Place your edited E Reader cards in \(XGFolders.Decoded.path)
		-      then use this utility to output the reencoded data for those cards in \(XGFolders.Decrypted.path)
		10: Decrypt Ereader Cards
		-      Place your encrypted E Reader cards in \(XGFolders.Encrypted.path)
		-      then use this utility to output the decrypted data for those cards in \(XGFolders.Decrypted.path)
		11: Encrypt Ereader Cards
		-      Place your decrypted E Reader cards in \(XGFolders.Decrypted.path)
		-      then use this utility to output the reencrypted data for those cards in \(XGFolders.Encrypted.path)
		12: Decrypt and Decode Ereader Cards
		13: Encode and Encrypt Ereader Cards
		"""
		#elseif GAME_PBR
		prompt += """

		4: Increase number of pokemon slots in the game by 1
		5: Increase number of pokemon slots in the game by 10
		6: Increase number of pokemon slots in the game by 100
		"""
		#endif

		let input = readInput(prompt)
		switch input {
		case "": continue
		case "0": return
		case "1": XGUtility.setupIronMonRules()
		case "2": XGUtility.extractAllTextures(forDolphin: false)
		case "3": XGUtility.extractAllTextures(forDolphin: true)
		#if !GAME_PBR
		case "4": XGUtility.increasePokemonLevelsByPercentage(10)
		case "5": XGUtility.increasePokemonLevelsByPercentage(20)
		case "6": XGUtility.increasePokemonLevelsByPercentage(50)
		case "7": XGPokemon.allPokemon().forEach { pokemon in
			let stats = pokemon.stats
			stats.levelUpRate = .slowest
			stats.save()
		}
		#endif
		#if GAME_COLO
		case "8": XGUtility.decodeEReaderCards()
		case "9": XGUtility.encodeEReaderCards()
		case "10": XGUtility.decryptEReaderCards()
		case "11": XGUtility.encryptEReaderCards()
		case "12": XGUtility.decryptEReaderCards(); XGUtility.decodeEReaderCards()
		case "13": XGUtility.encodeEReaderCards(); XGUtility.encryptEReaderCards()
		#elseif GAME_PBR
		case "4": XGPatcher.increasePokemonTotal(by: 1)
		case "5": XGPatcher.increasePokemonTotal(by: 10)
		case "6": XGPatcher.increasePokemonTotal(by: 100)
		#endif
		default: invalidOption(input)
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
		case "1": if readInput("This will overwrite the ISO at \(XGFiles.iso.path)\nAre you sure? Y/N").lowercased() == "y" {
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

	if !ToolProcess.loadISO() {
		let args = CommandLine.arguments

		for arg in args {
			if arg == "--version" || arg == "-v" {
				printg(aboutMessage())
				return
			}
		}

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

