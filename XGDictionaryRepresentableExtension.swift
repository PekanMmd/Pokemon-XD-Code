//
//  XGDictionaryRepresentableExtension.swift
//  XGCommandLineTools
//
//  Created by StarsMmd on 17/11/2016.
//  Copyright © 2016 StarsMmd. All rights reserved.
//

import Foundation

extension XGDictionaryRepresentable {
	
	func saveDictionaryRepresentation(fileName: String) {
		XGUtility.saveJSON(dictionaryRepresentation as AnyObject, toFile: XGFiles.nameAndFolder(fileName, .Reference))
	}
	
	func saveReadableDictionaryRepresentation(fileName: String) {
		XGUtility.saveJSON(readableDictionaryRepresentation as AnyObject, toFile: XGFiles.nameAndFolder(fileName, .Reference))
	}
	
}
