//
//  EncodableTableTypes.swift
//  GoD Tool
//
//  Created by Stars Momodu on 27/03/2021.
//

import Foundation
#if canImport(Cocoa)
import Cocoa
#endif

enum TableTypes {
	enum StructTableTypes {
		case deckTrainer, deckPokemon, deckAI, common, saveData, ereader, other

		#if GUI
		var colour: NSColor {
			switch self {
			case .saveData:
				return GoDDesign.colourPink().NSColour
			case .ereader:
				return GoDDesign.colourPeach().NSColour
			case .deckTrainer:
				return GoDDesign.colourLightBlue().NSColour
			case .deckPokemon:
				return GoDDesign.colourLightGreen().NSColour
			case .deckAI:
				return GoDDesign.colourRed().NSColour
			case .common:
				return GoDDesign.colourYellow().NSColour
			case .other:
				return GoDDesign.colourLightOrange().NSColour
			}
		}
		#endif
	}
	case structTable(table: GoDStructTableFormattable, type: StructTableTypes)
	case codableData(data: GoDCodable.Type)

	var name: String {
		switch self {
		case .structTable(let table, _):
			#if GUI
			let separator = "\n"
			#else
			let separator = " "
			#endif
			return table.properties.name + (table.fileVaries ? separator + table.file.fileName : "")
		case .codableData(let type): return type.className
		}
	}

	var isStructTable: Bool {
		switch self {
		case .structTable: return true
		case .codableData: return false
		}
	}

	#if GUI
	var colour: NSColor {
		switch self {
		case .structTable(_, let type): return type.colour
		case .codableData: return GoDDesign.colourLightGrey().NSColour
		}
	}
	#endif

	static var allTables: [TableTypes] {
		var list = [TableTypes]()

		#if !GAME_PBR
		list += saveFileStructList.map({ (table) -> TableTypes in
			.structTable(table: table, type: .saveData)
		})
		#endif

		#if GAME_COLO
		list += eReaderStructList.map({ (table) -> TableTypes in
			.structTable(table: table, type: .ereader)
		})
		#endif

		list += commonStructTablesList.map { (table) -> TableTypes in
			.structTable(table: table, type: .common)
		}

		list += deckPokemonStructList.map { (table) -> TableTypes in
			.structTable(table: table, type: .deckPokemon)
		}
		list += deckTrainerStructList.map { (table) -> TableTypes in
			.structTable(table: table, type: .deckTrainer)
		}
		list += deckAIStructList.map { (table) -> TableTypes in
			.structTable(table: table, type: .deckAI)
		}

		list += structTablesList.map { (table) -> TableTypes in
			.structTable(table: table, type: .other)
		}

		list += otherTableFormatsList.map({ (type) -> TableTypes in
			 .codableData(data: type)
		})

		return list
	}
}
