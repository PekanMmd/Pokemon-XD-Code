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

func loadAllStrings(refresh: Bool = false) {
	
	if !stringsLoaded {
		
		previousFound = 0
		previousFrom = 0
		previousFree = []
		
		allStringTables = game == .PBR ? [] : [XGFiles.common_rel.stringTable]
		#if GAME_COLO
		allStringTables += [XGStringTable.dol()]

		if game == .Colosseum {
			allStringTables += [XGStringTable.common_rel2(), XGStringTable.common_rel3()]
		}

		#elseif GAME_XD
		if game == .XD && !isDemo {
			allStringTables += [XGStringTable.dol2()]
		}

		if XGFiles.tableres2.exists {
			allStringTables += [XGFiles.tableres2.stringTable]
		}

		#elseif GAME_PBR
		if game == .PBR {
			for filename in
						[region == .JP ? "common" : "mes_common",
						(region == .JP ? "menu_fight_s" : "mes_fight_e"),
						(region == .JP ? "menu_name2" : "mes_name_e")]
				+ (region == .JP ? [] : ["menu_btutorial"]) {
				XGUtility.exportFileFromISO(.fsys(filename), decode: false, overwrite: false)
			}
		}
		#endif

		XGFiles.allFilesWithType(.msg).forEach { allStringTables.append($0.stringTable) }
		
		stringsLoaded = true
	}
	
}

func getStringWithID(id: Int) -> XGString? {
	
	if id == 0 {
		return nil
	}
	
	loadAllStrings()
	
	for table in allStringTables {
		if table.containsStringWithId(id) {
			if let s = table.stringWithID(id) {
				return s
			}
		}
	}
	return nil
}

func getStringSafelyWithID(id: Int) -> XGString {
	
	if id == 0 {
		return XGString(string: "-", file: nil, sid: nil)
	}
	
	loadAllStrings()
	
	for i in 0 ..< allStringTables.count {
		let table = allStringTables[i]
		if table.containsStringWithId(id) {
			allStringTables.remove(at: i)
			allStringTables.insert(table, at: 0)
			if let s = table.stringWithID(id) {
				return s
			}

		}
	}
	
	return XGString(string: "-", file: nil, sid: id)
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

#if !GAME_PBR
private func numberOfFreeMSGIDsFrom(_ id: Int) -> Int {
	loadAllStrings()
	
	var free = 10
	for table in allStringTables {
		free = min(free, table.numberOfFreeMSGIDsFrom(id))
	}
	
	return free
}

var isSearchingForFreeStringID = false
func freeMSGID() -> Int? {
	// start from 1000 just to be safe
	// might have special rules for lower ids
	// like they could be hard coded or hidden in
	// weird files
	// plenty of ids available so no need to risk it
	// even if unlikely
	// can use freemsgid(from:) if below 1000 is desired
	// Update: upon testing it seems starting at 1000 is smart.
	// id 1 showed no text but id 1000 worked as expected
	// don't know what the minimum is but 1000 is guaranteed
	if isSearchingForFreeStringID {
		return nil
	}
	return freeMSGID(from: 1000)
}

private var previousFrom = 0
private var previousFound = 0
private var previousFree = [Int]()

func freeMSGID(from: Int) -> Int? {
	guard !isSearchingForFreeStringID else {
		return nil
	}
	isSearchingForFreeStringID = true
	
	var min = from < 1 ? 1 : from
	if min <= previousFound && min >= previousFrom {
		min = previousFound + 1
	} else {
		previousFrom = from
	}
	
	for i in min ..< min + 10 {
		if previousFree.contains(i) {
			previousFree.remove(at: previousFree.firstIndex(of: i)!)
			previousFound = i
			isSearchingForFreeStringID = false
			return i
		}
	}
	
	for i in min ... kMaxStringID {
		if settings.verbose {
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
			isSearchingForFreeStringID = false
			return i
		}
	}
	isSearchingForFreeStringID = false
	return nil
}
#endif





