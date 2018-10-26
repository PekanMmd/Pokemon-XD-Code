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
		
		previousFound = 0
		previousFrom = 0
		previousFree = []
		
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

private func doesMSGIDExists(_ id: Int) -> Bool {
	loadAllStrings()
	
	for table in allStringTables {
		if table.containsStringWithId(id) {
			return true
		}
	}
	return false
}

private func numberOfFreeMSGIDsFrom(_ id: Int) -> Int {
	loadAllStrings()
	
	var free = 10
	for table in allStringTables {
		free = min(free, table.numberOfFreeMSGIDsFrom(id))
	}
	
	return free
}

func freeMSGID() -> Int? {
	// start from 1000 just to be safe
	// might have special rules for lower ids
	// like they could be hard coded or hidden in
	// weird files
	// plenty of ids available so no need to risk it
	// even if unlikely
	// can use freemsgid(from:) if below 1000 is desired
	return freeMSGID(from: 1000)
}

private var previousFrom = 0
private var previousFound = 0
private var previousFree = [Int]()

func freeMSGID(from: Int) -> Int? {
	ISO.extractMenuFSYS()
	ISO.extractSpecificStringTables()
	ISO.extractCommon()
	
	var min = from < 1 ? 1 : from
	if min <= previousFound && min >= previousFrom {
		min = previousFound + 1
	} else {
		previousFrom = from
	}
	
	for i in min ..< min + 10 {
		if previousFree.contains(i) {
			previousFree.remove(at: previousFree.index(of: i)!)
			previousFound = i
			return i
		}
	}
	
	for i in min ... kMaxStringID {
		if verbose {
			printg("checking id: \(i)")
		}
		
		let num = numberOfFreeMSGIDsFrom(i)
		if num > 0 {
			previousFound = i
			if num > 2 {
				for j in 1 ..< num {
					previousFree.addUnique(num + j)
				}
			}
			return i
		}
	}
	return nil
}






