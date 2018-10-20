//
//  XGStringManager.swift
//  GoD Tool
//
//  Created by StarsMmd on 20/08/2017.
//
//

import Foundation

var allStringTables = [XGStringTable]()
var stringsLoaded = false

func loadAllStrings() {
	
	if !stringsLoaded {
		
		allStringTables = [XGFiles.common_rel.stringTable]
		allStringTables += [XGStringTable.dol()]
		allStringTables += [XGStringTable.dol2()]
		if game == .XD {
			allStringTables += [XGFiles.tableres2.stringTable]
		}
		
		XGFolders.StringTables.map{ (file: XGFiles) -> Void in
			if file.fileType == .msg {
				let table = file.stringTable
				if table.numberOfEntries > 0 {
					allStringTables += [table]
				}
			}
		}
		
		stringsLoaded = true
	}
	
}

func getStringWithID(id: Int) -> XGString? {
	loadAllStrings()
	
	if id == 0 {
		return nil
	}
	
	for table in allStringTables where table.containsStringWithId(id) {
		if let s = table.stringWithID(id) {
			return s
		}
	}
	return nil
}

func getStringSafelyWithID(id: Int) -> XGString {
	loadAllStrings()
	
	if id == 0 {
		return XGString(string: "-", file: nil, sid: nil)
	}
	
	for table in allStringTables where table.containsStringWithId(id) {
		if let s = table.stringWithID(id) {
			return s
		}
	}
	
	return XGString(string: "-", file: nil, sid: nil)
}

func getStringsContaining(substring: String) -> [XGString] {
	loadAllStrings()
	
	var found = [XGString]()
	for table in allStringTables {
		for str in table.allStrings() where str.containsSubstring(substring) {
			found.append(str)
		}
	}
	
	return found
}



