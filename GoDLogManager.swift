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

#if GUI
func logToScreen(_ args: Any...) {

	for arg in args {
		print(arg, separator: " ", terminator: " ")
	}
	print("") // automatically adds new line

	var newString = ""
	for arg in args {
		newString = newString + String(describing: arg) + " "
	}
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
}
#endif

func printg(_ args: Any...) {

	logToScreen(args)

	#if GUI
	guard !fileDecodingMode && inputISOFile != nil else {
		return
	}
	#endif
	
	for arg in args {
		print(arg, separator: " ", terminator: " ")
	}
	print("") // automatically adds new line
	
	var newString = ""
	for arg in args {
		newString = newString + String(describing: arg) + " "
	}
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

	if !fileDecodingMode && inputISOFile != nil {
		XGUtility.saveString(logString, toFile: .log(date))
	}
}
