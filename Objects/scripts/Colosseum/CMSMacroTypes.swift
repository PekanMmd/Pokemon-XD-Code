//
//  CMSMacroTypes.swift
//  GoD Tool
//
//  Created by Stars Momodu on 03/06/2021.
//

import Foundation

indirect enum CMSMacroTypes {

	case invalid
	case null

	case bool
	case msgID
	case scriptFunction

	case integer
	case float

	case pokemon
	case item
	case model
	case move
	case room
	case ability
	case battleResult
	case shadowStatus
	case battleID
	case shadowID
	case treasureID
	case battlefield
	case integerMoney
	case integerCoupons
	case integerQuantity
	case integerIndex
	case groupID
	case resourceID
	case giftPokemon
	case flag
	case region
	case language
	case transitionID
	case yesNoIndex
	case buttonInput
	case fileIdentifier

	case array(CMSMacroTypes)

	var needsMacro: Bool {
		switch self {
		case .integer, .float, .invalid:
			return false
		case .array(let subType):
			return subType.needsMacro
		default:
			return true
		}
	}

	var needsDefine: Bool {
		switch self {
		case .bool: return false
		case .msgID: return false
		case .scriptFunction: return false
		case .invalid, .integer, .float, .null: return false
		case .array(let subType):
			return subType.needsDefine
		default: return true
		}
	}

	var typeName: String {
		switch self {
		case .invalid:
			return "Invalid"
		case .null:
			return "Void"
		case .bool:
			return "Bool"
		case .msgID:
			return "MsgID"
		case .scriptFunction:
			return "ScriptFunction"
		case .integer:
			return "Int"
		case .float:
			return "Float"
		case .pokemon:
			return "Pokemon"
		case .item:
			return "Item"
		case .model:
			return "Model"
		case .move:
			return "Move"
		case .room:
			return "Room"
		case .ability:
			return "Ability"
		case .battleResult:
			return "BattleResult"
		case .shadowStatus:
			return "ShadowStatus"
		case .battleID:
			return "Battle"
		case .shadowID:
			return "ShadowPokemon"
		case .treasureID:
			return "Treasure"
		case .battlefield:
			return "BattleField"
		case .integerMoney:
			return "Pokedollars"
		case .integerCoupons:
			return "Pokecoupons"
		case .integerQuantity:
			return "IntegerQuantity"
		case .integerIndex:
			return "Index"
		case .groupID:
			return "GroupID"
		case .resourceID:
			return "ResourceID"
		case .giftPokemon:
			return "GiftPokemon"
		case .flag:
			return "Flag"
		case .region:
			return "Region"
		case .language:
			return "Language"
		case .transitionID:
			return "Transition"
		case .yesNoIndex:
			return "YesNoIndex"
		case .buttonInput:
			return "ButtonInput"
		case .fileIdentifier:
			return "FileIdentifier"
		case .array(let subType):
			return "[\(subType.typeName)]"
		}
	}

	static var autocompletableTypes: [CMSMacroTypes] {
		return [
			.pokemon, .item, .model, .move, .room, .flag, .ability, .battleResult, .shadowStatus, .shadowID, .battlefield, .giftPokemon, .region, .language, .transitionID, .scriptFunction, .buttonInput
		]
	}

	var autocompleteValues: [Int] {
		switch self {
		case .pokemon: return allPokemonArray().map{ $0.index }
		case .item: return allItemsArray().map{ $0.index }
		case .model: return XGFsys(file: .fsys("people_archive")).identifiers
		case .move: return allPokemonArray().map{ $0.index }
		case .room: return XGRoom.allValues.map{ $0.roomID }.sorted()
		case .flag: return XDSFlags.allCases.map{ $0.rawValue }
		case .ability: return Array(0 ..< kNumberOfAbilities)
		case .battleResult: return Array(0 ... 3)
		case .shadowStatus: return Array(0 ... 4)
		case .shadowID: return Array(0 ..< CommonIndexes.NumberOfShadowPokemon.value)
		case .battlefield: return Array(0 ..< CommonIndexes.NumberOfBattleFields.value)
		case .giftPokemon: return Array(0 ..< kNumberOfGiftPokemon)
		case .region: return Array(0 ... 2)
		case .language: return XGLanguages.allCases.map{ $0.rawValue }
		case .transitionID: return Array(2 ... 5)
		case .scriptFunction: return (0 ..< XGFiles.common_rel.scriptData.ftbl.count).map { 0x596_0000 + $0 }
		case .buttonInput: return (0 ..< 12).map{ Int(pow(2.0, Double($0))) }.filter{ $0 != 0x80 }
		default: return []
		}
	}

	func macroWithName(_ name: String) -> String {
		return "#" + name
	}

	func textForValue(_ value: CMSConstant, script: XGScript?) -> String {
		switch self {
		case .bool:
			return value.integerValue != 0 ? "YES" : "NO"
		case .msgID:
			return getStringSafelyWithID(id: value.integerValue).unformattedString
		case .scriptFunction:
			switch value.integerValue >> 16 {
			case 0: return "Null"
			case 0x596: return "Common.\(value.integerValue & 0xFFFF)"
			case 0x100: return "This.\(value.integerValue & 0xFFFF)"
			default: return "Error(Invalid macro value)"
			}
		case .integer, .float:
			assertionFailure("Shouldn't have literals as macros")
			return "\(value)"
		case .null:
			return "Null"
		case .flag:
			if let flag = XDSFlags(rawValue: value.integerValue) {
				return macroWithName("FLAG_" + flag.name.underscoreSimplified.uppercased() + "_\(value.integerValue)")
			}
			for shadow in CMShadowData.allValues {
				if shadow.captureFlag == value.integerValue {
					return macroWithName("FLAG_SHADOW_" + shadow.species.name.unformattedString.underscoreSimplified.uppercased() + "_CAUGHT_\(value.integerValue)")
				}
			}
			return macroWithName("FLAG_" + value.integerValue.string)
		case .pokemon:
			if value.integerValue == 0 {
				return macroWithName("pokemon_none".uppercased())
			}
			if value.integerValue < 0 {
				return macroWithName("POKEMON_CANCEL")
			}
			let mon = XGPokemon.index(value.integerValue)
			if fileDecodingMode || mon.nameID == 0 {
				return macroWithName("POKEMON_" + value.integerValue.string)
			}
			return macroWithName("POKEMON_" + mon.name.string.underscoreSimplified.uppercased())
		case .item:
			if value.integerValue == 0 {
				return macroWithName("item_none".uppercased())
			}
			if value.integerValue < 0 {
				return macroWithName("ITEM_CANCEL")
			}
			let item = XGItems.index(value.integerValue)
			if fileDecodingMode || item.nameID == 0 {
				return macroWithName("ITEM_" + value.integerValue.string)
			}
			return macroWithName("ITEM_" + item.name.string.underscoreSimplified.uppercased())
		case .model:
			if value.integerValue == 0 {
				return macroWithName("model_none".uppercased())
			}
			if fileDecodingMode {
				return macroWithName("MODEL_" + "\(value.integerValue)")
			}

			if let scriptFile = script?.file {
				let fsysFile = XGFiles.fsys(scriptFile.folder.name)
				if fsysFile.exists {
					let fsys = XGFsys(file: fsysFile)
					if fsys.identifiers.contains(value.integerValue) {
						return macroWithName("MODEL_" + fsys.fileNameForFileWithIdentifier(value.integerValue)!.removeFileExtensions().underscoreSimplified.uppercased() + "\(value.integerValue)")
					}
				}
			}

			let peopleArchive = XGFiles.fsys("people_archive").fsysData
			if peopleArchive.identifiers.contains(value.integerValue) {
				return macroWithName("MODEL_" + XGCharacterModel.modelWithIdentifier(id: value.integerValue).name.removeFileExtensions().underscoreSimplified.uppercased() + "\(value.integerValue)")
			}

			return macroWithName("MODEL_" + value.integerValue.hex())
		case .move:
			if value.integerValue == 0 {
				return macroWithName("move_none".uppercased())
			}
			if value.integerValue < 0 {
				return macroWithName("MOVE_CANCEL")
			}
			let move = XGMoves.index(value.integerValue)
			if fileDecodingMode || move.nameID == 0 {
				return macroWithName("MOVE_" + value.integerValue.string)
			}
			return macroWithName("MOVE_" + move.name.string.underscoreSimplified.uppercased())
		case .room:
			if value.integerValue == 0 {
				return macroWithName("room_none".uppercased())
			}
			if fileDecodingMode {
				return macroWithName("ROOM_" + value.integerValue.string)
			}
			if let room = XGRoom.roomWithID(value.integerValue) {
				return macroWithName("ROOM_" + room.name.underscoreSimplified.uppercased())
			}
			return macroWithName("ROOM_" + (XGRoom.roomWithID(value.integerValue) ?? XGRoom(index: 0)).name.simplified.uppercased())
		case .battlefield:
			if value.integerValue == 0 {
				return macroWithName("battlefield_none".uppercased())
			}
			if !fileDecodingMode,  let room = XGBattleField(index: value.integerValue).room {
				return macroWithName("BATTLEFIELD_" + room.name.underscoreSimplified.uppercased())
			}
			return macroWithName("BATTLEFIELD_" + value.integerValue.string)
		case .ability:
			if value.integerValue == 0 {
				return macroWithName("ability_none".uppercased())
			}
			let ability = XGAbilities.index(value.integerValue)
			if fileDecodingMode ||  ability.nameID == 0 {
				return macroWithName("ABILITY_" + value.integerValue.string)
			}
			return macroWithName("ABILITY_" + ability.name.string.underscoreSimplified.uppercased())
		case .battleResult:
			switch value.integerValue {
				case 0: return macroWithName("result_none".uppercased())
				case 1: return macroWithName("result_lose".uppercased())
				case 2: return macroWithName("result_win".uppercased())
				case 3: return macroWithName("result_tie".uppercased())
				default: return macroWithName("result_unknown".uppercased() + value.integerValue.string)
			}
		case .shadowStatus:
			switch value.integerValue {
			case 0: return macroWithName("shadow_status_not_seen".uppercased())
			case 1: return macroWithName("shadow_status_seen_as_spectator".uppercased())
			case 2: return macroWithName("shadow_status_seen_in_battle".uppercased())
			case 3: return macroWithName("shadow_status_caught".uppercased())
			case 4: return macroWithName("shadow_status_purified".uppercased())
			default: printg("error unknown shadow pokemon status");return "error unknown shadow pokemon status"
			}
		case .battleID:
			if value.integerValue == 0 {
				return macroWithName("battle_none".uppercased())
			}
			let mid: String
			if let battle = XGBattle(index: value.integerValue) {
				mid = (battle.p3Trainer == nil ? "VS_\(battle.p2Trainer?.trainerClass.name.unformattedString ?? "unknown_class")_\(battle.p2Trainer?.name.unformattedString ?? "unknown_trainer")" : "VS_\(battle.p3Trainer?.name.unformattedString ?? "unknown_class")_AND_\(battle.p4Trainer?.name.unformattedString ?? "unknown_trainer")").underscoreSimplified.uppercased()
			} else {
				mid = "unknown_class_unknown_trainer".uppercased()
			}

			return macroWithName("BATTLE_\(mid)_" + String(format: "%03d", value.integerValue))
		case .shadowID:
			if value.integerValue == 0 {
				return macroWithName("shadow_pokemon_none".uppercased())
			}
			let mid = (fileDecodingMode || value.integerValue < 0 || CMShadowData(index: value.integerValue).species.nameID == 0) ? "POKEMON" : CMShadowData(index: value.integerValue).species.name.string.underscoreSimplified.uppercased()
			return macroWithName("SHADOW_" + mid + String(format: "_%02d", value.integerValue))
		case .treasureID:
			if value.integerValue == 0 {
				return macroWithName("treasure_none".uppercased())
			}
			let mid = fileDecodingMode ? "ITEM" : XGTreasure(index: value.integerValue).item.name.string.underscoreSimplified.uppercased()
			return macroWithName("TREASURE_" + mid + String(format: "_%03d", value.integerValue))
		case .buttonInput:
			switch value.integerValue {
			case 0x1: return macroWithName("BUTTON_INPUT_D_PAD_LEFT")
			case 0x2: return macroWithName("BUTTON_INPUT_D_PAD_RIGHT")
			case 0x4: return macroWithName("BUTTON_INPUT_D_PAD_DOWN")
			case 0x8: return macroWithName("BUTTON_INPUT_D_PAD_UP")
			case 0x10: return macroWithName("BUTTON_INPUT_TRIGGER_Z")
			case 0x20: return macroWithName("BUTTON_INPUT_TRIGGER_R")
			case 0x40: return macroWithName("BUTTON_INPUT_TRIGGER_L")
			case 0x100: return macroWithName("BUTTON_INPUT_A")
			case 0x200: return macroWithName("BUTTON_INPUT_B")
			case 0x400: return macroWithName("BUTTON_INPUT_X")
			case 0x800: return macroWithName("BUTTON_INPUT_Y")
			case 0x1000: return macroWithName("BUTTON_INPUT_START")
			default: return macroWithName("BUTTON_INPUT_UNKNOWN_\(value.integerValue)")
			}

		case .integerMoney:
			return macroWithName("P$\(value.integerValue.string.replacingOccurrences(of: "-", with: "_"))")
		case .integerCoupons:
			return macroWithName("C$\(value.integerValue.string.replacingOccurrences(of: "-", with: "_"))")

		case .integerQuantity:
			return macroWithName("X\(value.integerValue.string.replacingOccurrences(of: "-", with: "_"))")
		case .integerIndex:
			if value.integerValue < 0 {
				return macroWithName("INDEX_CANCEL")
			}
			return macroWithName("INDEX_\(value.integerValue)")
		case .yesNoIndex:
			return macroWithName(value.integerValue == 0 ? "INDEX_YES" : "INDEX_NO")
		case .giftPokemon:
			if !fileDecodingMode && value.integerValue <= kNumberOfGiftPokemon && value.integerValue > 0 {
				let gift = XGGiftPokemonManager.allGiftPokemon()[value.integerValue]
				let type = gift.giftType.underscoreSimplified.uppercased()
				let species = gift.species.name.string.underscoreSimplified.uppercased()
				return macroWithName(type + "_" + species)
			}
			if value.integerValue == 0 {
				return macroWithName("GIFT_POKEMON_NONE")
			}
			return macroWithName("GIFT_POKEMON_" + String(format: "%03d", value.integerValue))

		case .groupID:
			return macroWithName(value.integerValue == 0 ? "GROUP_ID_PROTAGONISTS" : "GROUP_ID_CURRENT_MAP")
		case .resourceID:
			let rid = value.integerValue
			switch rid {
			case 100: return macroWithName("CHARACTER_RID_WES")
			case 101: return macroWithName("CHARACTER_RID_RUI")
			default:
				if let characters = script?.mapRel?.characters, rid < characters.count, characters[rid].name.count > 1 {
					return macroWithName("CHARACTER_RID_\(rid)_\(characters[rid].name)")
				}
				return macroWithName("CHARACTER_RID_\(rid)")
			}
		case .region:
			switch value.integerValue {
				case 0: return macroWithName("REGION_JP")
				case 1: return macroWithName("REGION_US")
				case 2: return macroWithName("REGION_PAL")
				default:
					printg("error invalid region"); return macroWithName("INVALID_REGION")
			}
		case .language:
			switch value.integerValue {
				case 0: return macroWithName("LANGUAGE_JAPANESE")
				case 1: return macroWithName("LANGUAGE_ENGLISH_UK")
				case 2: return macroWithName("LANGUAGE_ENGLISH_US")
				case 3: return macroWithName("LANGUAGE_GERMAN")
				case 4: return macroWithName("LANGUAGE_FRENCH")
				case 5: return macroWithName("LANGUAGE_ITALIAN")
				case 6: return macroWithName("LANGUAGE_SPANISH")
				default:
					printg("error invalid language"); return macroWithName("INVALID_LANGUAGE")
			}

		case .transitionID:
			var name = ""
			switch value.integerValue {
			case 0: name = "NONE"
			case 2: name = "FADE_IN_BLACK"
			case 3: name = "FADE_OUT_BLACK"
			case 4: name = "FADE_IN_WHITE"
			case 5: name = "FADE_OUT_WHITE"
			default: name = value.integerValue.string
			}
			return macroWithName("TRANSITION_" + name.uppercased())

		case .fileIdentifier:
			if value.integerValue == 0 {
				return macroWithName("file_none".uppercased())
			}
			if fileDecodingMode {
				return macroWithName("FILE_" + value.integerValue.hex())
			}

			if let scriptFile = script?.file {
				let fsysFile = XGFiles.fsys(scriptFile.folder.name)
				if fsysFile.exists {
					let fsys = XGFsys(file: fsysFile)
					if fsys.identifiers.contains(value.integerValue) {
						return macroWithName("FILE_" + fsys.fileNameForFileWithIdentifier(value.integerValue)!.removeFileExtensions().underscoreSimplified.uppercased() + "_\(value.integerValue.hex())")
					}
				}
			}

			return macroWithName("FILE_" + value.integerValue.hex())

		case .array(let subType):
			return subType.textForValue(value, script: script)

		case .invalid:
			return "INVALID_\(value.integerValue)"
		}
	}
}
