//
//  GoDToolCLExtensions.swift
//  GoD Tool
//
//  Created by The Steez on 16/09/2017.
//
//

import Foundation

var verbose = false
var increaseFileSizes = true
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
	
	XGUtility.saveString(logString, toFile: .log(date))
}
