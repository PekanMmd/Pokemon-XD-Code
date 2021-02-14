//
//  GoDToolExtensions.swift
//  GoD Tool
//
//  Created by The Steez on 16/09/2017.
//
//

import Foundation

let date = Date(timeIntervalSinceNow: 0)
var logString = ""

func displayAlert(title: String, description: String) {
	#if GUI
	GoDAlertViewController.displayAlert(title: title, text: description)
	#else
	printg("\nAlert: \(title)\n\(description)\n")
	#endif
}

func printg(_ args: Any...) {

	var newString = ""
	for arg in args {
		print(arg, separator: " ", terminator: " ")
		newString = newString + String(describing: arg) + " "
	}
	print("") // automatically adds new line
	newString += "\n"
	logString += newString

	#if GUI
	XGThreadManager.manager.runInForegroundAsync {
		let hvc = appDelegate.homeViewController
		if hvc != nil {
			let log = hvc!.logView!
			log.string = log.string + newString
		}
	}
	#endif

	if !fileDecodingMode && XGISO.inputISOFile != nil {
		XGUtility.saveString(logString, toFile: .log(date))
	}
}
