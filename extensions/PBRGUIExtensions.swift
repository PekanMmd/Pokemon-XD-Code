//
//  PBRGUIExtensions.swift
//  Revolution Tool CL
//
//  Created by Stars Momodu on 29/03/2020.
//

import Foundation

func printg(_ args: Any...) {
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
	XGUtility.saveString(logString, toFile: .log(date))

	XGThreadManager.manager.runInForegroundAsync {
		let hvc = appDelegate.homeViewController
		if hvc != nil {
			let log = hvc!.logView!
			log.string = log.string + newString
		}
	}
}
