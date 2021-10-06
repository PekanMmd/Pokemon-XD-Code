//
//  PKXTables.swift
//  GoD Tool
//
//  Created by Stars Momodu on 28/03/2021.
//

import Foundation

#if GAME_XD
let pkxStructProperties: [GoDStructProperties] = [
	.word(name: "Fsys ID", description: "", type: .fsysID),
	.word(name: "File Identifier", description: "", type: .fsysFileIdentifier(fsysName: nil))
]
#else
let pkxStructProperties: [GoDStructProperties] = [
	.word(name: "Fsys ID", description: "", type: .fsysID),
	.word(name: "File Identifier", description: "", type: .fsysFileIdentifier(fsysName: nil)),
	.word(name: "Name ID", description: "", type: .msgID(file: .common_rel))
]
#endif

let pkxTrainerModelStruct = GoDStruct(name: "PKX Trainer Model", format: pkxStructProperties)
let pkxPokemonModelStruct = GoDStruct(name: "PKX Pokemon Model", format: pkxStructProperties)

var pkxPokemonModelsTable: GoDStructTable {
	let startOffset: Int
	#if GAME_COLO
	switch region  {
	case .US: startOffset = 0x36dbd0
	case .EU: startOffset = 0x3bacc8
	case .JP: startOffset = 0x35a338
	case .OtherGame: startOffset = -1
	}
	#else
	switch region  {
	case .US: startOffset = 0x40a0a8
	case .EU: startOffset = 0x444988
	case .JP: startOffset = 0x3e7758
	case .OtherGame: startOffset = -1
	}
	#endif
	return GoDStructTable(file: .dol, properties: pkxPokemonModelStruct) { (_) -> Int in
		return startOffset
	} numberOfEntriesInFile: { (_) -> Int in
		return game == .Colosseum ? 417 : 419
	} nameForEntry: { (index, data) -> String? in
		guard game != .Colosseum, let fsysID: Int = data.get("Fsys ID") else { return nil }
		return GSFsys.shared.entryWithID(fsysID)?.name
	}
}

var pkxTrainerModelsTable: GoDStructTable {
	let startOffset: Int
	#if GAME_COLO
	switch region  {
	case .US: startOffset = 0x36d840
	case .EU: startOffset = 0x3ba938
	case .JP: startOffset = 0x359fa8
	case .OtherGame: startOffset = -1
	}
	#else
	switch region  {
	case .US: startOffset = 0x409e88
	case .EU: startOffset = 0x444768
	case .JP: startOffset = 0x3e7538
	case .OtherGame: startOffset = -1
	}
	#endif
	return GoDStructTable(file: .dol, properties: pkxTrainerModelStruct) { (_) -> Int in
		return startOffset
	} numberOfEntriesInFile: { (_) -> Int in
		return game == .Colosseum ? 76 : 68
	} nameForEntry: { (index, data) -> String? in
		guard let fsysID: Int = data.get("Fsys ID") else { return nil }
		return GSFsys.shared.entryWithID(fsysID)?.name
	}
}

#if GAME_XD
let wzxStructProperties: [GoDStructProperties] = [
	.word(name: "Attack Fsys ID", description: "", type: .fsysID),
	.word(name: "Attack File Identifier", description: "", type: .fsysFileIdentifier(fsysName: nil)),
	.word(name: "Damage Fsys ID", description: "", type: .fsysID),
	.word(name: "Damage File Identifier", description: "", type: .fsysFileIdentifier(fsysName: nil))
]
#else
let wzxStructProperties: [GoDStructProperties] = [
	.word(name: "id", description: "", type: .uint),
	.word(name: "Attack Fsys ID", description: "", type: .fsysID),
	.word(name: "Attack File Identifier", description: "", type: .fsysFileIdentifier(fsysName: nil)),
	.word(name: "Damage Fsys ID", description: "", type: .fsysID),
	.word(name: "Damage File Identifier", description: "", type: .fsysFileIdentifier(fsysName: nil)),
	.word(name: "Special Fsys ID", description: "", type: .fsysID),
	.word(name: "Special File Identifier", description: "", type: .fsysFileIdentifier(fsysName: nil)),
]
#endif

let wzxMoveAnimationStruct = GoDStruct(name: "WZX Move Animation", format: wzxStructProperties)

var wzxMoveModelsTable: GoDStructTable {
	let startOffset: Int
	#if GAME_COLO
	switch region  {
	case .US: startOffset = 0x36b150
	case .EU: startOffset = -1
	case .JP: startOffset = -1
	case .OtherGame: startOffset = -1
	}
	#else
	switch region  {
	case .US: startOffset = 0x40d0f0
	case .EU: startOffset = -1
	case .JP: startOffset = -1
	case .OtherGame: startOffset = -1
	}
	#endif
	return GoDStructTable(file: .dol, properties: wzxMoveAnimationStruct) { (_) -> Int in
		return startOffset
	} numberOfEntriesInFile: { (_) -> Int in
		return game == .Colosseum ? 417 : 419
	} nameForEntry: { (index, data) -> String? in
		if let fsysID: Int = data.get("Attack Fsys ID") {
			return GSFsys.shared.entryWithID(fsysID)?.name
		}
		if let fsysID: Int = data.get("Damage Fsys ID") {
			return GSFsys.shared.entryWithID(fsysID)?.name
		}
		if let fsysID: Int = data.get("Special Fsys ID") {
			return GSFsys.shared.entryWithID(fsysID)?.name
		}
		return nil
	}
}

