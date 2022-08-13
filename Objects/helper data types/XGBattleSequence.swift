////
////  XGBattleSequence.swift
////  GoD Tool
////
////  Created by Stars Momodu on 11/05/2022.
////
//
//import Foundation
//
//enum XGBattleSequenceCommand {
//	
//	case checkIfMoveShouldFail
//	case checkIfMoveHits(failureSequence: Int, option: Int)
//	case usedMoveMessage
//	case usedMoveMessage2
//	case decreasePP
//	case checkCriticalHit
//	case damageCalc
//	case checkTypeMatchup
//	case setDamageLoss
//	case setDamageLossIgnoreForcedSurvival
//	case moveAnimation
//	case awaitMoveAnimation(unknown: Int)
//	case decreaseHP(target: Int)
//	case awaitHPDecrease(target: Int)
//	case criticalHitMessage
//	case moveEffectivenessSFX
//	case moveEffectivenessMessage
//	case displayMessage(id: Int)
//	case displayAlertMessage(id: Int)
//	case awaitMessage(duration: Int)
//	case messageFromTable(offset: Int)
//	case messageFromTable2(offset: Int) // Seems to be duplicate code
//	case checkSecondaryEffect
//	case directSecondaryEffect
//	case indirectSecondaryEffect
//	case endStatus(target: Int)
//	case checkFainted(target: Int, spikesFlag: Bool, unknownSequence: Int)
//	case faintAnimation(target: Int)
//	case awaitFaintAnimation(target: Int)
//	case jumpIfMainStatus(target: Int, status: Int, toSequence: Int)
//	case ifMainStatus(target: Int, status: Int, sequence: XGBattleSequence)
//	case jumpIfSecondaryStatus(target: Int, status: Int, toSequence: Int)
//	case ifSecondaryStatus(target: Int, status: Int, sequence: XGBattleSequence)
//	case jumpIfAbilityStatus(target: Int, ability: Int, toSequence: Int)
//	case ifAbilityStatus(target: Int, ability: Int, sequence: XGBattleSequence)
//	case jumpIfFieldEffect(target: Int, effect: Int, toSequence: Int)
//	case ifFieldEffect(target: Int, effect: Int, sequence: XGBattleSequence)
//	case jumpIfStat(target: Int, status: Int, toSequence: Int)
//	case ifStat(target: Int, status: Int, sequence: XGBattleSequence)
//	case jumpIfStatusEquals(target: Int, status: Int, comparison: Bool, toSequence: Int)
//	case ifStatusEquals(target: Int, status: Int, comparison: Bool, sequence: XGBattleSequence)
//	case jumpIfType(target: Int, type: Int, toSequence: Int)
//	case ifType(target: Int, type: Int, sequence: XGBattleSequence)
//	
//	
//	case endSequence
//	case none
//	case invalidParameters(id: Int)
//	case unknown(id: Int)
//	
//	// Used for custom commands coded into the game.
//	// The game will be coded so if it reads a 0xFF command id then it will use the next byte of the sequence
//	// as the id of the custom function (starting from 0) and look those up in a custom command look up table.
//	// The byte after that must be the number of parameters that custom command uses.
//	// Then for each parameter a 4 byte value follows.
//	// e.g. FF 03 02 00 00 01 00 00 00 00 05
//	// Is a custom command with id 3, which has 2 parameters: 0x100 and 0x5
//	case custom(id: Int, parameters: [Int])
//	
//	var terminatesSequence: Bool {
//		switch self {
//		case .endSequence, .unknown, .none, .invalidParameters:
//			return true
//		default:
//			return false
//		}
//	}
//	
//	var length: Int {
//		switch self {
//		case .checkIfMoveHits: return 7
//		case .decreaseHP, .awaitHPDecrease: return 2
//		case .awaitMoveAnimation: return 2
//		case .displayMessage, .messageFromTable, .messageFromTable2: return 5
//		case .displayAlertMessage, .awaitMessage: return 3
//		case .endStatus: return 2
//		case .checkFainted: return 7
//		case .faintAnimation, .awaitFaintAnimation: return 2
//			
//		case .custom(_, let parameters): return 3 + (parameters.count * 4)
//			
//		case .none, .invalidParameters: return 0
//		default: return 1
//		}
//	}
//	
//	static func read(from input: GoDReadable, atOffset offset: Int) -> XGBattleSequenceCommand {
//		if let commandID = input.readByte(atAddress: offset) {
//			switch commandID {
//			case 0x00: return .checkIfMoveShouldFail
//			case 0x01:
//				guard let failureSequence = input.read4Bytes(atAddress: offset + 1),
//					  let optionID = input.read2Bytes(atAddress: offset + 5) else {
//						  return .invalidParameters(id: 0x01)
//					  }
//				return .checkIfMoveHits(failureSequence: failureSequence, option: optionID)
//			case 0x02: return .usedMoveMessage
//			case 0x03: return .usedMoveMessage2
//			case 0x04: return .decreasePP
//			case 0x05: return .checkCriticalHit
//			case 0x06: return .damageCalc
//			case 0x07: return .checkTypeMatchup
//			case 0x08: return .setDamageLoss
//			case 0x09: return .setDamageLossIgnoreForcedSurvival
//			case 0x0A: return .moveAnimation
//			case 0x0B:
//				guard let unknownID = input.readByte(atAddress: offset + 1) else {
//						  return .invalidParameters(id: 0x0B)
//					  }
//				return .awaitMoveAnimation(unknown: unknownID)
//			case 0x0C:
//				guard let targetID = input.readByte(atAddress: offset + 1) else {
//						  return .invalidParameters(id: 0x0C)
//					  }
//				return .decreaseHP(target: targetID)
//			case 0x0D:
//				guard let targetID = input.readByte(atAddress: offset + 1) else {
//						  return .invalidParameters(id: 0x0D)
//					  }
//				return .awaitHPDecrease(target: targetID)
//			case 0x0E: return .criticalHitMessage
//			case 0x0F: return .moveEffectivenessSFX
//			case 0x10: return .moveEffectivenessMessage
//			case 0x11:
//				guard let messageID = input.read4Bytes(atAddress: offset + 1) else {
//						  return .invalidParameters(id: 0x11)
//					  }
//				return .displayMessage(id: messageID)
//			case 0x12:
//				guard let messageID = input.read2Bytes(atAddress: offset + 1) else {
//						  return .invalidParameters(id: 0x12)
//					  }
//				return .displayAlertMessage(id: messageID)
//			case 0x13:
//				guard let delay = input.read2Bytes(atAddress: offset + 1) else {
//						  return .invalidParameters(id: 0x13)
//					  }
//				return .awaitMessage(duration: delay)
//			case 0x14:
//				guard let offset = input.read4Bytes(atAddress: offset + 1) else {
//						  return .invalidParameters(id: 0x14)
//					  }
//				return .messageFromTable(offset: offset)
//			case 0x15:
//				guard let offset = input.read4Bytes(atAddress: offset + 1) else {
//						  return .invalidParameters(id: 0x15)
//					  }
//				return .messageFromTable2(offset: offset)
//			case 0x16: return .checkSecondaryEffect
//			case 0x17: return .directSecondaryEffect
//			case 0x18: return indirectSecondaryEffect
//			case 0x19:
//				guard let targetID = input.readByte(atAddress: offset + 1) else {
//						  return .invalidParameters(id: 0x19)
//					  }
//				return .endStatus(target: targetID)
//			case 0x1A:
//				guard let targetID = input.readByte(atAddress: offset + 1),
//					  let spikesFlag = input.readBool(atAddress: offset + 2),
//					  let unknownSequence = input.read4Bytes(atAddress: offset + 3) else {
//						  return .invalidParameters(id: 0x1A)
//					  }
//				return .checkFainted(target: targetID, spikesFlag: spikesFlag, unknownSequence: unknownSequence)
//			case 0x1B:
//				guard let targetID = input.readByte(atAddress: offset + 1) else {
//						  return .invalidParameters(id: 0x1B)
//					  }
//				return .faintAnimation(target: targetID)
//			case 0x1C:
//				guard let targetID = input.readByte(atAddress: offset + 1) else {
//						  return .invalidParameters(id: 0x1C)
//					  }
//				return .awaitFaintAnimation(target: targetID)
//				
//				
//			case 0xFF:
//				guard let commandID = input.readByte(atAddress: offset + 1),
//					  let parameterCount = input.readByte(atAddress: offset + 2) else {
//						  return .none
//					  }
//				var parameters = [Int]()
//				for i in 0 ..< parameterCount {
//					guard let parameter = input.read4Bytes(atAddress: offset + 3 + (i * 4)) else {
//						return .invalidParameters(id: 0xFF00 + commandID)
//					}
//					parameters.append(parameter)
//				}
//				return .custom(id: commandID, parameters: parameters)
//			default:
//				return .unknown(id: commandID)
//			}
//		} else {
//			return .none
//		}
//	}
//	
//	func rawData(atOffset offset: Int = 0) -> XGMutableData {
//		let data = XGMutableData(length: self.length)
//		switch self {
//		case .checkIfMoveShouldFail:
//			data.write8(0x00, atAddress: 0)
//		case .checkIfMoveHits(let failureSequence, let option):
//			data.write8(0x01, atAddress: 0)
//			data.write(failureSequence, atAddress: 1)
//			data.write16(option, atAddress: 5)
//		case .usedMoveMessage:
//			data.write8(0x02, atAddress: 0)
//		case .usedMoveMessage2:
//			data.write8(0x03, atAddress: 0)
//		case .decreasePP:
//			data.write8(0x04, atAddress: 0)
//		case .checkCriticalHit:
//			data.write8(0x05, atAddress: 0)
//		case .damageCalc:
//			data.write8(0x06, atAddress: 0)
//		case .checkTypeMatchup:
//			data.write8(0x07, atAddress: 0)
//		case .setDamageLoss:
//			data.write8(0x08, atAddress: 0)
//		case .setDamageLossIgnoreForcedSurvival:
//			data.write8(0x09, atAddress: 0)
//		case .moveAnimation:
//			data.write8(0x0A, atAddress: 0)
//		case .awaitMoveAnimation(let unknownID):
//			data.write8(0x0B, atAddress: 0)
//			data.write8(unknownID, atAddress: 1)
//		case .decreaseHP(let targetID):
//			data.write8(0x0C, atAddress: 0)
//			data.write8(targetID, atAddress: 1)
//		case .awaitHPDecrease(let targetID):
//			data.write8(0x0D, atAddress: 0)
//			data.write8(targetID, atAddress: 1)
//		case .criticalHitMessage:
//			data.write8(0x0E, atAddress: 0)
//		case .moveEffectivenessSFX:
//			data.write8(0x0F, atAddress: 0)
//		case .moveEffectivenessMessage:
//			data.write8(0x10, atAddress: 0)
//		case .displayMessage(let id):
//			data.write8(0x11, atAddress: 0)
//			data.write(id, atAddress: 1)
//		case .displayAlertMessage(let id):
//			data.write8(0x12, atAddress: 0)
//			data.write16(id, atAddress: 1)
//		case .awaitMessage(let duration):
//			data.write8(0x13, atAddress: 0)
//			data.write16(duration, atAddress: 1)
//		case .messageFromTable(let offset):
//			data.write8(0x14, atAddress: 0)
//			data.write(offset, atAddress: 1)
//		case .messageFromTable2(let offset):
//			data.write8(0x15, atAddress: 0)
//			data.write(offset, atAddress: 1)
//		case .checkSecondaryEffect:
//			data.write8(0x16, atAddress: 0)
//		case .directSecondaryEffect:
//			data.write8(0x17, atAddress: 0)
//		case .indirectSecondaryEffect:
//			data.write8(0x18, atAddress: 0)
//		case .endStatus(let targetID):
//			data.write8(0x19, atAddress: 0)
//			data.write8(targetID, atAddress: 1)
//		case .checkFainted(let targetID, let spikesFlag, let unknownSequence):
//			data.write8(0x1A, atAddress: 0)
//			data.write8(targetID, atAddress: 1)
//			data.write8(spikesFlag ? 1 : 0, atAddress: 2)
//			data.write(unknownSequence, atAddress: 3)
//		case .faintAnimation(let targetID):
//			data.write8(0x1B, atAddress: 0)
//			data.write8(targetID, atAddress: 1)
//		case .awaitFaintAnimation(let targetID):
//			data.write8(0x1C, atAddress: 0)
//			data.write8(targetID, atAddress: 1)
//			
//			
//		case .endSequence:
//			data.write8(0x3F, atAddress: 0)
//			
//		case.custom(let id, let parameters):
//			data.write8(0xFF, atAddress: 0)
//			data.write8(id, atAddress: 0)
//			data.write8(parameters.count, atAddress: 0)
//			for i in 0 ..< parameters.count {
//				data.write(parameters[i], atAddress: 3 + (i * 4))
//			}
//			
//		case .unknown(let id):
//			data.write8(id, atAddress: 0)
//		case .none, .invalidParameters:
//			break
//		}
//		return data
//	}
//	
//	func write(to output: GoDWritable, atOffset offset: Int) {
//		let data = rawData(atOffset: offset)
//		output.write(data, atAddress: offset)
//	}
//}
//
//typealias XGBattleSequence = [XGBattleSequenceCommand]
//
//extension XGBattleSequence {
//	static func read(from input: GoDReadable, atOffset offset: Int) -> XGBattleSequence {
//		var sequence = XGBattleSequence()
//		var currentOffset = offset
//		var sequenceTerminated = false
//		while !sequenceTerminated {
//			let command = XGBattleSequenceCommand.read(from: input, atOffset: currentOffset)
//			currentOffset += command.length
//			sequenceTerminated = command.terminatesSequence
//			sequence.append(command)
//		}
//		return sequence
//	}
//	
//	func write(to output: GoDWritable, atOffset offset: Int) {
//		var currentOffset = offset
//		for command in self {
//			command.write(to: output, atOffset: currentOffset)
//			currentOffset += command.length
//		}
//	}
//}
//
//extension XGBattleSequenceCommand {
//	var scriptData: (text: String, macros: [XGBattleSequenceScriptMacro]) {
//		var macros = [XGBattleSequenceScriptMacro]()
//		var text = ""
//		
//		let rawData = self.rawData()
//		let id = rawData.readByte(atAddress: 0) ?? 0
//		let commandMacro = XGBattleSequenceScriptMacro.command(id: id)
//		macros.append(commandMacro)
//		
//		text = commandMacro.scriptText
//		
//		switch self {
//		case .checkIfMoveHits(let failureSequence, let option):
//			let sequenceMacro = XGBattleSequenceScriptMacro.sequence(RAMOffset: failureSequence)
//			let optionMacro = XGBattleSequenceScriptMacro.hitCheckOption(id: option)
//			macros += [sequenceMacro, optionMacro]
//			text += " MissSequence: \(sequenceMacro.scriptText) Option: \(optionMacro.scriptText)"
//		case .awaitMoveAnimation(let unknown):
//			text += " Unknown: \(unknown)"
//		case .decreaseHP(let targetID), .awaitHPDecrease(let targetID), .endStatus(let targetID),
//				.faintAnimation(let targetID), .awaitFaintAnimation(let targetID):
//			let targetMacro = XGBattleSequenceScriptMacro.target(id: targetID)
//			macros += [targetMacro]
//			text += " Target: \(targetMacro.scriptText)"
//		case .displayMessage(let id), .displayAlertMessage(let id):
//			text += " MsgID: \(id.hexString())"
//		case .awaitMessage(let duration):
//			text += " Duration: \(duration)"
//		case .checkFainted(let targetID, let spikesFlag, let unknownSequence):
//			let targetMacro = XGBattleSequenceScriptMacro.target(id: targetID)
//			let spikesMacro = XGBattleSequenceScriptMacro.bool(spikesFlag)
//			macros += [targetMacro, spikesMacro]
//			text += " Target: \(targetMacro.scriptText) SpikesFlag: \(spikesMacro.scriptText) UnknownSequence: \(unknownSequence.hexString())"
//			
//			
//		case .custom(let id, let parameters):
//			text = "CustomCommand(\(id))"
//			for parameter in parameters {
//				text += " \(parameter > 100 ? parameter.hexString() : parameter.string)"
//			}
//			
//		case .none:
//			return (text: "", macros: [])
//		case .invalidParameters(let id):
//			return (text: "!Error - Command \(id.hexString()) with invalid parameters", macros: [])
//		case .unknown(let id):
//			return (text: "!Error - Command id \(id.hexString())", macros: [])
//			
//		default:
//			break
//		}
//		
//		return (text: text, macros: macros)
//	}
//}
//
//enum XGBattleSequenceScriptMacro {
//	case sequence(RAMOffset: Int)
//	case move(index: Int)
//	case pokemon(index: Int)
//	case ability(index: Int)
//	case hitCheckOption(id: Int)
//	case target(id: Int)
//	case bool(Bool)
//	case command(id: Int)
//	
//	static func nameForSequenceLocation(_ location: Int) -> String? {
//		let knownSequencesDict = [String: Int]()
//		for (name, offset) in knownSequencesDict {
//			if offset == location {
//				return name
//			}
//		}
//		return nil
//	}
//	
//	var printOrder: Int {
//		switch self {
//		case .command: return 1
//		case .sequence: return 2
//		case .pokemon: return 3
//		case .move: return 4
//		case .ability: return 5
//		case .hitCheckOption: return 6
//		case .target: return 7
//		case .bool: return 8
//		}
//	}
//	
//	var rawValue: String {
//		switch self {
//		case .sequence(let RAMOffset):
//			return RAMOffset.hexString()
//		case .hitCheckOption(0xFFFE):
//			return 0xFFFE.hexString()
//		case .hitCheckOption(0xFFFF):
//			return 0xFFFF.hexString()
//		case .hitCheckOption(let id):
//			return id.string
//		case .move(let index),  .pokemon(let index), .ability(let index):
//			return index.string
//		case .target(let id):
//			return id.string
//		case .bool(let value):
//			return value ? "1" : "0"
//		case .command(let id):
//			return "Command(\(id))"
//		
//		}
//	}
//	var scriptText: String {
//		func macroWithName(_ name: String) -> String {
//			return "#" + name
//		}
//		switch self {
//		case .sequence(let RAMOffset):
//			// TODO: compile resource of known sequence locations and look up name from list
//			if let name = XGBattleSequenceScriptMacro.nameForSequenceLocation(RAMOffset) {
//				return macroWithName(name)
//			} else {
//				return macroWithName("SEQUENCE_\(RAMOffset.hex().uppercased())")
//			}
//		case .move(let index):
//			let move = XGMoves.index(index)
//			if move.index > 0 && move.index < kNumberOfMoves {
//				return macroWithName("MOVE_\(move.name.unformattedString.capitalized)")
//			} else {
//				return macroWithName("MOVE_\(String(format: "%03d", index))")
//			}
//		case .pokemon(let index):
//			let pokemon = XGPokemon.index(index)
//			if pokemon.index > 0 && pokemon.index < kNumberOfPokemon {
//				return macroWithName("POKEMON_\(pokemon.name.unformattedString.capitalized)")
//			} else {
//				return macroWithName("POKEMON_\(String(format: "%03d", index))")
//			}
//		case .ability(let index):
//			let ability = XGAbilities.index(index)
//			if ability.index > 0 && ability.index < kNumberOfAbilities {
//				return macroWithName("ABILITY_\(ability.name.unformattedString.capitalized)")
//			} else {
//				return macroWithName("ABILITY_\(String(format: "%03d", index))")
//			}
//		case .hitCheckOption(let id):
//			switch id {
//			case 0xFFFF: return macroWithName("HC_OPTION_SUCCEED_IF_TARGET_LOCKED_ON")
//			case 0xFFFE: return macroWithName("HC_OPTION_SUCCEED_IF_TARGET_NOT_HIDDEN")
//			case 0x0000: return macroWithName("HC_OPTION_DEFAULT_FOR_SELECTED_MOVE")
//			default: return XGBattleSequenceScriptMacro.move(index: id).scriptText
//			}
//		case .target(let id):
//			switch id {
//			case 0x11: return macroWithName("AttackingPokemon")
//			case 0x12: return macroWithName("DefendingPokemon")
//			default: return macroWithName("UnknownTarget_\(id)")
//			}
//		case .bool(let value):
//			return value ? "YES" : "NO"
//		case .command(let id):
//			switch id {
//			case 0x00: return "CheckMoveFailure"
//			case 0x01: return "AccuracyCheck"
//			case 0x02: return "MoveAnnouncementMessage"
//			case 0x03: return "MoveAnnouncementMessage2"
//			case 0x04: return "DecreasePP"
//			case 0x05: return "CheckCriticalHit"
//			case 0x06: return "CalculateDamage"
//			case 0x07: return "CheckTypeMatchup"
//			case 0x08: return "SetDamageLoss"
//			case 0x09: return "SetDamageLossIgnoreForcedSurvival"
//			case 0x0A: return "MoveAnimation"
//			case 0x0B: return "AwaitMoveAnimation"
//			case 0x0C: return "DecreaseHP"
//			case 0x0D: return "AwaitHPDecrease"
//			case 0x0E: return "CriticalHitMessage"
//			case 0x0F: return "MoveEffectivenessSFX"
//			case 0x10: return "MoveEffectivenessMessage"
//			case 0x11: return "DisplayMessage"
//			case 0x12: return "DisplayAlertMessage"
//			case 0x13: return "AwaitMessage"
//			case 0x14: return "MessageFromTable"
//			case 0x15: return "MessageFromTable2"
//			case 0x16: return "CheckSecondaryEffect"
//			case 0x17: return "DirectSecondaryEffect"
//			case 0x18: return "IndirectSecondaryEffect"
//			case 0x19: return "EndStatus"
//			case 0x1A: return "CheckFainted"
//			case 0x1B: return "FaintAnimation"
//			case 0x1C: return "AwaitFaintAnimation"
//				
//			default: return "UnknownCommand" + id.string
//			}
//		
//		}
//	}
//	
//	var macroText: String {
//		return "$Macro \(scriptText) = \(rawValue)"
//	}
//}
//
//extension XGBattleSequence {
//	
//	var scriptText: String {
//		let (commandsText, macrosList) = scriptData
//		let macros = macrosList.sorted { m1, m2 in
//			return m1.printOrder == m2.printOrder ? m1.scriptText < m2.scriptText : m1.printOrder < m2.printOrder
//		}
//		var macrosText = ""
//		for macro in macros {
//			macrosText += macro.macroText + "\n"
//		}
//		
//		return macrosText + "\n" + commandsText
//	}
//	
//	var scriptData: (text: String, macros: [XGBattleSequenceScriptMacro]) {
//		var commandMacros = [XGBattleSequenceScriptMacro]()
//		var commandsText = ""
//		
//		for command in self {
//			let (text, macros) = command.scriptData
//			commandMacros += macros
//			commandsText += text + "\n"
//		}
//		
//		return (text: commandsText, macros: commandMacros)
//	}
//}
