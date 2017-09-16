//
//  GoDToolCLExtensions.swift
//  GoD Tool
//
//  Created by The Steez on 16/09/2017.
//
//

import Foundation

func printg(_ args: Any...) {
	for arg in args {
		print(arg, separator: " ", terminator: " ")
	}
	print("") // automatically adds new line
}
