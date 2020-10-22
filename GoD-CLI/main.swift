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
	ISO.allFileNames.forEach {
		printg($0)
	}
}

func importExportFiles() {
	var currentSearch = ""

	func searchedFiles() -> [String] {
		guard currentSearch.count > 0 else {
			return ISO.allFileNames
		}
		return ISO.allFileNames.filter { (name) -> Bool in
			return name.lowercased().contains(currentSearch.lowercased())
		}
	}

	func exportFiles() {
		for file in searchedFiles() {
			let outputFile = XGFiles.nameAndFolder(file, .ISOExport(file.removeFileExtensions()))
			printg("Exporting file", file, "to:", outputFile.folder.path)
			if XGUtility.exportFileFromISO(outputFile) {
				printg("success")
			} else {
				printg("failed")
			}
		}
	}

	func importFiles() {
		for file in searchedFiles() {
			let inputFile = XGFiles.nameAndFolder(file, .ISOExport(file.removeFileExtensions()))
			printg("Importing file", file, "from:", inputFile.folder.path)
			if XGUtility.importFileToISO(inputFile) {
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
		Enter 'import' to import \(searchText)
		Enter 'list' to list \(searchText)
		Enter 'exit' to go back
		Enter any other text to search for files containing that text
		"""
		let input = readInput(prompt)
		switch input {
		case "export": exportFiles()
		case "import": importFiles()
		case "list": list()
		case "exit": return
		default: currentSearch = input
		}
	}
}

func applyPatches() {
	guard region == .US else {
		printg("Patches can currently only be applied to US versions of the ISO.")
		return
	}

	let patches : [XGDolPatches] = game == .XD ? [
		.physicalSpecialSplitApply,
		.physicalSpecialSplitRemove,
		.defaultMoveCategories,
		.infiniteTMs,
		.allowFemaleStarters,
		.zeroForeignStringTables,
		.betaStartersApply,
		.betaStartersRemove,
		.switchPokemonAtEndOfTurn,
		.fixShinyGlitch,
		.removeShadowShinyLock,
		.shadowsAreNeverShiny,
		.allShadowsAreShiny,
		.tradeEvolutions
	] : [
		.physicalSpecialSplitApply,
		.defaultMoveCategories,
		.allowFemaleStarters,
		.tradeEvolutions
	]

	var prompt = "Select a patch to apply:\n\n0: exit\n"
	for i in 0 ..< patches.count {
		let patch = patches[i]
		prompt += "\(i + 1): \(patch.name)\n"
	}

	while true {
		let input = readInput(prompt)
		guard let index = input.integerValue, index >= 0, index - 1 < patches.count else {
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

func encodeDecode() {
	
}

func documentISO() {

}

func mainMenu() {
	while true {
		var prompt = """
		Type the number of the function you want and press enter:

		0: Exit the program
		1: Rebuild ISO - Use to put files edited by this tool back in the ISO
		2: List files - List all files in the ISO
		3: Import/Export files - Use this to export files for manual editing and to reimport them
		4: Patches - Pick some useful patches to apply to the game
		"""
		if game == .XD {
			prompt += """

			5: Encode data tables - Write all data to json files that can be edited
			6: Decode data tables - Import the edited json files for the data tables
			7: Document data - Dumps all information about the game into text files for reference only
			"""
		}

		let input = readInput(prompt)
		switch input {
		case "": continue
		case "0": return
		case "1": XGUtility.compileMainFiles()
		case "2": listFiles()
		case "3": importExportFiles()
		case "4": applyPatches()
		case "5": if game == .XD { XGUtility.encodeISO() }
		case "6": if game == .XD { XGUtility.decodeISO() }
		case "7": if game == .XD { XGUtility.documentISO() }
		default: invalidOption(input)
		}
	}
}

func readInput(_ prompt: String) -> String {
	print("\n" + prompt, terminator: "\n\n>> ")
	return readLine() ?? ""
}

func main() {
	let noDocumentsFolder = !XGFolders.Documents.exists
	XGFolders.setUpFolderFormat()
	if noDocumentsFolder {
		printg("Created folder structure at:", XGFolders.Documents.path)
	}
	guard XGFiles.iso.exists else {
		printg("Please place your iso in the folder", XGFolders.ISO.path, "and name it \"\(XGFiles.iso.fileName)\"")
		printg("Once you've done this you can run the tool again. :-)")
		return
	}

	mainMenu()
}

main()
printg("Press enter to close the tool...")
_ = readLine() // pause at end of execution

