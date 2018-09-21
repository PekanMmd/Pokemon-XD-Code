//
//  GoDToolExtensions.swift
//  GoD Tool
//
//  Created by The Steez on 16/09/2017.
//
//

import Cocoa

var verbose = false
let date = Date(timeIntervalSinceNow: 0)
var logString = ""

func printg(_ args: Any...) {
	for arg in args {
		print(arg, separator: " ", terminator: " ")
	}
	print("") // automatically adds new line
	
	for arg in args {
		logString = logString + String(describing: arg) + " "
	}
	logString = logString + "\n"
	
	let hvc = appDelegate.homeViewController
	if hvc != nil {
		let log = hvc!.logView!
		log.string = logString
	}
	
	XGUtility.saveString(logString, toFile: .log(date))
}
