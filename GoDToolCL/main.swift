//
//  main.swift
//  XGCommandLineTools
//
//  Created by StarsMmd on 13/11/2015.
//  Copyright © 2015 StarsMmd. All rights reserved.
//
//

import Foundation

ToolProcess.loadISO(exitOnFailure: true)

var countDownDate: Date?
var posterFile: XGFiles?
var musicScriptFile: XGFiles?
var iso: XGFiles?
var argsAreInvalid = false

let args = CommandLine.arguments
for i in 0 ..< args.count {
	guard i < args.count - 1 else { continue }
	let arg = args[i]
	let next = args[i + 1]
	if arg == "--launch-dpp-date" {
		countDownDate = Date.fromString(next)
		if countDownDate == nil {
			let secondsToDecember: Double = 31_104_000
			print("Invalid arg for \(arg) \(next)\nDate must be of format:", Date(timeIntervalSince1970: secondsToDecember).referenceString())
			argsAreInvalid = true
		}
	} else if arg == "--launch-dpp-secs",
			  let seconds = next.integerValue {
		countDownDate = Date(timeIntervalSinceNow: Double(seconds))
	} else if arg == "-i" || arg == "--iso" {
		let file = XGFiles.path(next)
		if file.fileType == .iso {
			iso = file
		}
		if !file.exists {
			print("Invalid arg for \(arg).\nFile doesn't exist:", file.path)
			argsAreInvalid = true
		}
	} else if arg == "-s" || arg == "--silent-logs" {
		silentLogs = true
	}
}
if argsAreInvalid {
	ToolProcess.terminate()
}

if let isoFile = iso {
	XGISO.loadISO(file: isoFile)
}

DiscordPlaysOrre().launch()


