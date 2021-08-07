//
//  PDADumper.swift
//  GoD Tool
//
//  Created by Stars Momodu on 26/07/2021.
//

import Foundation

class PDADumper {
	static let folder = XGFolders.nameAndFolder("PDA Dump", .Reference)

	private class func fileWithName(_ filename: String) -> XGFiles {
		var gameName = ""
		switch game {
		case .Colosseum: gameName = "CM"
		case .XD: gameName = "XD"
		case .PBR: gameName = "PBR"
		}
		return XGFiles.nameAndFolder(filename + " \(gameName)" + ".json", folder)
	}

	class func dumpAll() {
		dumpStats()
	}

	class func dump(_ data: [String: AnyObject], to file: XGFiles) {
		XGUtility.saveJSON(data as AnyObject, toFile: file)
	}

	class func dumpStats() {
		var data = [String: AnyObject]()
		pokemonStatsTable.allEntries.forEach { (entry) in
			if let nameID: Int = entry.get("Name ID"), nameID > 0,
			   let name = getStringWithID(id: nameID),
			   let object = entry.jsonObject(useRawValue: false) as? [String: AnyObject] {
				var entryName = name.unformattedString.simplified
				var duplicateNumber = 1
				while data[entryName] != nil {
					duplicateNumber += 1
					entryName = entryName + "-\(duplicateNumber)"
				}
				var updatedObject = object
				updatedObject["name"] = name.unformattedString as AnyObject
				updatedObject["entryName"] = entryName as AnyObject
				data[entryName] = updatedObject as AnyObject
			}
		}
		dump(data, to: fileWithName("stats"))
	}
}
