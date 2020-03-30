//
//  CMExtensions.swift
//  GoD Tool
//
//  Created by StarsMmd on 04/06/2018.
//
//

import Cocoa

let date = Date(timeIntervalSinceNow: 0)
var logString = ""

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







