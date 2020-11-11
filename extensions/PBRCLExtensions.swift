//
//  PBRCLExtensions.swift
//  Revolution Tool CL
//
//  Created by Stars Momodu on 29/03/2020.
//

import Foundation

func displayAlert(title: String, description: String) {
	printg("\nAlert: \(title)\n\(description)\n")
}

func printg(_ args: Any...) {
	for arg in args {
		print(arg, separator: " ", terminator: " ")
	}
	print("") // automatically adds new line

	for arg in args {
		logString = logString + String(describing: arg) + " "
	}
	logString = logString + "\n"

	XGUtility.saveString(logString, toFile: .log(date))
}
