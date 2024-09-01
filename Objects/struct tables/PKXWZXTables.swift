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

let shinyPKXStructProperties: [GoDStructProperties] = [
	.short(name: "Species ID", description: "", type: .pokemonID),
	.word(name: "Fsys ID", description: "", type: .fsysID),
	.word(name: "File Identifier", description: "", type: .fsysFileIdentifier(fsysName: nil))
]

let unownPKXStructProperties: [GoDStructProperties] = [
	.word(name: "Fsys ID", description: "", type: .fsysID),
	.word(name: "File Identifier", description: "", type: .fsysFileIdentifier(fsysName: nil))
]

let pkxTrainerModelStruct = GoDStruct(name: "PKX Trainer Model", format: pkxStructProperties)
let pkxPokemonModelStruct = GoDStruct(name: "PKX Pokemon Model", format: pkxStructProperties)
let shinyPKXPokemonModelStruct = GoDStruct(name: "Shiny PKX Pokemon Model", format: shinyPKXStructProperties)
let deoxysPkxPokemonModelStruct = GoDStruct(name: "Deoxys PKX Pokemon Model", format: pkxStructProperties)
let deoxysShinykxPokemonModelStruct = GoDStruct(name: "Deoxys Shiny PKX Pokemon Model", format: pkxStructProperties)
let unownPKXPokemonModelStruct = GoDStruct(name: "Unown PKX Pokemon Model", format: unownPKXStructProperties)

var pkxPokemonModelsTable: GoDStructTable {
	return GoDStructTable(file: .dol, properties: pkxPokemonModelStruct) { (_) -> Int in
		let startOffset: Int
		if game == .Colosseum {
			switch region  {
			case .US: startOffset = 0x36dbd0
			case .EU: startOffset = 0x3bacc8
			case .JP: startOffset = 0x35a338
			case .OtherGame: startOffset = -1
			}
		} else {
			switch region  {
			case .US: startOffset = 0x40a0a8
			case .EU: startOffset = 0x444988
			case .JP: startOffset = 0x3e7758
			case .OtherGame: startOffset = -1
			}
		}
		return startOffset
	} numberOfEntriesInFile: { (_) -> Int in
		let offset: Int
		if game == .Colosseum {
			switch region  {
			case .US: offset = 0x397b90
			case .EU: offset = 0x3e5028
			case .JP: offset = 0x384300
			case .OtherGame: offset = -1
			}
		} else {
			switch region  {
			case .US: offset = 0x41dc78
			case .EU: offset = 0x45867c
			case .JP: offset = 0x3fb310
			case .OtherGame: offset = -1
			}
		}
		return XGFiles.dol.data?.get4BytesAtOffset(offset) ?? 0
	} nameForEntry: { (index, data) -> String? in
		guard game != .Colosseum, let fsysID: Int = data.get("Fsys ID") else { return nil }
		return GSFsys.shared.entryWithID(fsysID)?.name
	}
}

var shinyPKXPokemonModelsTable: GoDStructTable {
	return GoDStructTable(file: .dol, properties: shinyPKXPokemonModelStruct) { (_) -> Int in
		let startOffset: Int
		if game == .Colosseum {
			switch region  {
			case .US: startOffset = 0x371f20
			case .EU: startOffset = 0x3bf3a8
			case .JP: startOffset = 0x35e690
			case .OtherGame: startOffset = -1
			}
		} else {
			switch region  {
			case .US: startOffset = 0x40cde8
			case .EU: startOffset = 0x447700
			case .JP: startOffset = 0x3ea498
			case .OtherGame: startOffset = -1
			}
		}
		return startOffset
	} numberOfEntriesInFile: { (_) -> Int in
		let offset: Int
		if game == .Colosseum {
			switch region  {
			case .US: offset = 0x397bb8
			case .EU: offset = 0x3e5050
			case .JP: offset = 0x384328
			case .OtherGame: offset = -1
			}
		} else {
			switch region  {
			case .US: offset = 0x41dc98
			case .EU: offset = 0x45869c
			case .JP: offset = 0x3fb330
			case .OtherGame: offset = -1
			}
		}
		return XGFiles.dol.data?.get4BytesAtOffset(offset) ?? 0
	} nameForEntry: { (index, data) -> String? in
		if let speciesID: Int = data.get("Species ID") {
			return XGPokemon.index(speciesID).name.string
		}
		if let fsysID: Int = data.get("Fsys ID") {
			return GSFsys.shared.entryWithID(fsysID)?.name
		}
		return nil
	}
}

var pkxTrainerModelsTable: GoDStructTable {
	return GoDStructTable(file: .dol, properties: pkxTrainerModelStruct) { (_) -> Int in
		let startOffset: Int
		if game == .Colosseum {
			switch region  {
			case .US: startOffset = 0x36d840
			case .EU: startOffset = 0x3ba938
			case .JP: startOffset = 0x359fa8
			case .OtherGame: startOffset = -1
			}
		} else {
			switch region  {
			case .US: startOffset = 0x409e88
			case .EU: startOffset = 0x444768
			case .JP: startOffset = 0x3e7538
			case .OtherGame: startOffset = -1
			}
		}
		return startOffset
	} numberOfEntriesInFile: { (_) -> Int in
		let offset: Int
		if game == .Colosseum {
			switch region  {
			case .US: offset = 0x397b88
			case .EU: offset = 0x3e5020
			case .JP: offset = 0x3842f8
			case .OtherGame: offset = -1
			}
		} else {
			switch region  {
			case .US: offset = 0x41dc70
			case .EU: offset = 0x458674
			case .JP: offset = 0x3fb308
			case .OtherGame: offset = -1
			}
		}
		return XGFiles.dol.data?.get4BytesAtOffset(offset) ?? 0
	} nameForEntry: { (index, data) -> String? in
		guard let fsysID: Int = data.get("Fsys ID") else { return nil }
		return GSFsys.shared.entryWithID(fsysID)?.name
	}
}

#if GAME_XD
var deoxysPKXModelsTable: GoDStructTable {
	return GoDStructTable(file: .dol, properties: deoxysPkxPokemonModelStruct) { (_) -> Int in
		let startOffset = {
			switch region  {
			case .US: return 0x40ff60
			case .EU: return 0x44a95c
			case .JP: return 0x3ed610
			case .OtherGame: return -1
			}
		}()
		return startOffset
	} numberOfEntriesInFile: { (_) -> Int in
		let offset = {
			switch region  {
			case .US: return 0x41dca0
			case .EU: return 0x4586a4
			case .JP: return 0x3fb338
			case .OtherGame: return -1
			}
		}()
		return XGFiles.dol.data?.get4BytesAtOffset(offset) ?? 4
	} nameForEntry: { (index, data) -> String? in
		guard let fsysID: Int = data.get("Fsys ID") else { return nil }
		return GSFsys.shared.entryWithID(fsysID)?.name
	}
}

var deoxysShinyPKXModelsTable: GoDStructTable {
	return GoDStructTable(file: .dol, properties: deoxysShinykxPokemonModelStruct) { (_) -> Int in
		let startOffset = {
			switch region  {
			case .US: return 0x40ff80
			case .EU: return 0x44a97c
			case .JP: return 0x3ed630
			case .OtherGame: return -1
			}
		}()
		return startOffset
	} numberOfEntriesInFile: { (_) -> Int in
		let offset = {
			switch region  {
			case .US: return 0x41dca8
			case .EU: return 0x4586ac
			case .JP: return 0x3fb340
			case .OtherGame: return -1
			}
		}()
		return XGFiles.dol.data?.get4BytesAtOffset(offset) ?? 4
	} nameForEntry: { (index, data) -> String? in
		guard let fsysID: Int = data.get("Fsys ID") else { return nil }
		return GSFsys.shared.entryWithID(fsysID)?.name
	}
}
#endif

var unownPKXModelsTable: GoDStructTable {
	return GoDStructTable(file: .dol, properties: unownPKXPokemonModelStruct) { (_) -> Int in
		let startOffset: Int
		if game == .Colosseum {
			switch region  {
			case .US: startOffset = 0x371e40
			case .EU: startOffset = 0x3bf2c0
			case .JP: startOffset = 0x35e5a8
			case .OtherGame: startOffset = -1
			}
		} else {
			switch region  {
			case .US: startOffset = 0x40cd08
			case .EU: startOffset = 0x447624
			case .JP: startOffset = 0x3ea3b8
			case .OtherGame: startOffset = -1
			}
		}
		return startOffset
	} numberOfEntriesInFile: { (_) -> Int in
		let offset: Int
		if game == .Colosseum {
			switch region  {
			case .US: offset = 0x397bb0
			case .EU: offset = 0x3e5048
			case .JP: offset = 0x384320
			case .OtherGame: offset = -1
			}
		} else {
			switch region  {
			case .US: offset = 0x41dc90
			case .EU: offset = 0x458694
			case .JP: offset = 0x3fb328
			case .OtherGame: offset = -1
			}
		}
		return XGFiles.dol.data?.get4BytesAtOffset(offset) ?? 28
	} nameForEntry: { (index, data) -> String? in
		guard let fsysID: Int = data.get("Fsys ID") else { return nil }
		return GSFsys.shared.entryWithID(fsysID)?.name
	}
}

#if GAME_XD
let wzxStruct = GoDStruct(name: "WZX Animation", format: [
	.word(name: "Fsys ID", description: "", type: .fsysID),
	.word(name: "WZX File ID", description: "", type: .fsysFileIdentifier(fsysName: nil))
])

var wzxTable: GoDStructTable {
	GoDStructTable(file: .dol, properties: wzxStruct) { (_) -> Int in
		switch region {
		case .US: return 0x40d0f0
		case .EU: return 0x447a0c
		case .JP: return 0x3ea7a0
		case .OtherGame: return -1
		}
	} numberOfEntriesInFile: { (_) -> Int in
		0x577
	} nameForEntry: { (index, data) -> String? in
		if let fsysID: Int = data.get("Fsys ID"), let fsysName = XGISO.current.getFSYSNameWithGroupID(fsysID) {
			return fsysName
		}
		return nil
	}
}

let wzxMoveStruct = GoDStruct(name: "WZX Move Animation", format: [
	.short(name: "Attack Animation", description: "", type: .indexOfEntryInTable(table: wzxTable, nameProperty: nil)),
	.short(name: "Damage Animation", description: "", type: .indexOfEntryInTable(table: wzxTable, nameProperty: nil)),
	.short(name: "Special Animation", description: "", type: .indexOfEntryInTable(table: wzxTable, nameProperty: nil))
])

var wzxMoveTable: GoDStructTable {
	GoDStructTable(file: .dol, properties: wzxMoveStruct) { (_) -> Int in
		switch region  {
		case .US: return 0x4095c8
		case .EU: return 0x443ea8
		case .JP: return 0x3e6c78
		case .OtherGame: return -1
		}
	} numberOfEntriesInFile: { (_) -> Int in
		let offset: Int
		switch region  {
		case .US: offset = 0x41dc68
		case .EU: offset = 0x45866c
		case .JP: offset = 0x3fb300
		case .OtherGame: offset = -1
		}
		return XGFiles.dol.data?.get4BytesAtOffset(offset) ?? 0
	} nameForEntry: { (index, data) -> String? in
		if let fsysID: Int = data.get("Fsys ID"), let fsysName = XGISO.current.getFSYSNameWithGroupID(fsysID) {
			return fsysName
		}
		return nil
	}
}

#else
let wzxStructProperties: [GoDStructProperties] = [
	.word(name: "Name ID", description: "", type: .msgID(file: .common_rel)),
	.word(name: "Attack Fsys ID", description: "", type: .fsysID),
	.word(name: "Attack File Identifier", description: "", type: .fsysFileIdentifier(fsysName: nil)),
	.word(name: "Damage Fsys ID", description: "", type: .fsysID),
	.word(name: "Damage File Identifier", description: "", type: .fsysFileIdentifier(fsysName: nil)),
	.word(name: "Special Fsys ID", description: "", type: .fsysID),
	.word(name: "Special File Identifier", description: "", type: .fsysFileIdentifier(fsysName: nil)),
]

let wzxMoveStruct = GoDStruct(name: "WZX Move Animation", format: wzxStructProperties)

var wzxMoveTable: GoDStructTable {
	return GoDStructTable(file: .dol, properties: wzxMoveStruct) { (_) -> Int in
		let startOffset: Int
		switch region  {
		case .US: startOffset = 0x36b150
		case .EU: startOffset = 0x3b8248
		case .JP: startOffset = 0x3578b8
		case .OtherGame: startOffset = -1
		}
		return startOffset
	} numberOfEntriesInFile: { (_) -> Int in
		let offset: Int
		switch region  {
		case .US: offset = 0x397b80
		case .EU: offset = 0x3e5018
		case .JP: offset = 0x3842f0
		case .OtherGame: offset = -1
		}
		return XGFiles.dol.data?.get4BytesAtOffset(offset) ?? 0
	} nameForEntry: { (index, data) -> String? in
		if let nameID: Int = data.get("Name ID") {
			return getStringSafelyWithID(id: nameID).string
		}
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
#endif
