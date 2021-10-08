//
//  CommandLineArgs.swift
//  GoD Tool
//
//  Created by Stars Momodu on 18/03/2021.
//

import Foundation

@discardableResult
func loadISO(exitOnFailure: Bool = false) -> Bool {
	let args = CommandLine.arguments

	let files = args.map { (filename) -> XGFiles in
		let fileurl = URL(fileURLWithPath: filename)
		return fileurl.file
	}.filter{
		$0.fileType != .unknown
	}

	guard files.count > 0 else {
		let message = environment == .Windows
			? "To use this tool, close this window and then drag and drop your ISO onto the .exe file."
			: "Please run this tool with the path to your ISO specified as the command line argument."
		print(message)
		if exitOnFailure {
			assertionFailure()
			exit(EXIT_FAILURE)
		}
		return false
	}

	if let isoFile = files.first(where: {$0.fileType == .iso && $0.exists}) {
		return XGISO.loadISO(file: isoFile)
	}

	if exitOnFailure {
		print("Failed to load ISO. Arguments:")
		args.forEach { print($0) }
		assertionFailure()
		exit(EXIT_FAILURE)
	}
	return false
}

func close() {
	exit(EXIT_SUCCESS)
}
