//
//  CMRelIndexes.swift
//  Colosseum Tool
//
//  Created by The Steez on 04/06/2018.
//

import Foundation

let kNumberMapPointers = 1 // for xd compatibility
enum MapRelIndexes : Int {
	// these values are inconsistent
	case FirstWarpEntryLocation = 1
	case NumberOfWarpEntryLocations = 2
	case FirstCharacter = 3
	case NumberOfCharacters = 4
	case groupData = 9
}


let kNumberRelPointers = 0x6c
enum CommonIndexes : Int {

	// These are US indexes and vary in the JP version
	case NumberOfItems = -1 // items are in dol in colosseum
	
	case LegendaryPokemon = 2
	case NumberOfLegendaryPokemon = 3
	
	case PokefaceTextures = 4
	case NumberOfPokefaceTextures = 5
	case PeopleIDs = 6 // 2 bytes at offset 0 person id 4 bytes at offset 4 string id for character name
	case NumberOfPeopleIDs = 7
	
	case TrainerClasses = 24
	case NumberOfTrainerClasses = 25

	case BattleFields = 28
	case NumberOfBattleFields = 29
	case Doors = 30
	case NumberOfDoors = 31
	case BattleTypes = 32
	case NumberOfBattleTypes = 33
	
	case Trainers = 44
	case NumberOfTrainers = 45
	case TrainerAIData = 46
	case NumberOfTrainerAIData = 47
	case TrainerPokemonData = 48
	case NumberOfTrainerPokemonData = 49
	
	case Battles = 50
	case NumberOfBattles = 51
	
	case SoundFiles = 52
	case NumberOfSoundFiles = 53
	
	case AIWeightEffects = 56
	case NumberOfAIWeightEffects = 57
	case AIPokemonRoles = 58
	case NumberOfAIPokemonRoles = 59
	
	case KeyboardCharacters = 36
	case NumberOfKeyboardCharacters = 37
	case Keyboard2Characters = 38
	case NumberOfKeyboard2Characters = 39
	case Keyboard3Characters = 40 // main keyboard
	case NumberOfKeyboard3Characters = 41
	
	case BattleStyles = 42
	case NumberOfBattleStyles = 43
	
	case Rooms = 14
	case NumberOfRooms = 15
	
	case TreasureBoxData = 60
	case NumberTreasureBoxes = 61

	case NatureMultipliers = 70
	case NumberOfNatureMultipliers = 71
	case CharacterModels = 72
	case NumberOfCharacterModels = 73
	
	case ShadowData = 80
	case NumberOfShadowPokemon = 81
	
	case PokemonMetLocations = 82
	case NumberOfMetLocations = 83
	
	case InteractionPoints = 86 // warps and interactable objects
	case NumberOfInteractionPoints = 87
	
	case PokemonStats = 68
	case NumberOfPokemon = 69
	
	case Natures = 64
	case NumberOfNatures = 65
	
	
	case Moves = 62
	case NumberOfMoves = 63

	case StringTable1 = 98
	case StringTable2 = 99
	case StringTable3 = 100
	case Script = 101

	var index: Int {
		switch self {
		case .StringTable1:
			switch region {
			case .EU: return 99
			case .US: return 98
			case .JP: return 95
			default: return self.rawValue
			}
		case .Script:
			switch region {
			case .EU: return 98
			case .US: return 101
			case .JP: return 96
			default: return self.rawValue
			}
		default: return self.rawValue
		}
	}

	var startOffset : Int {
		return common.getPointer(index: self.index)
	}

	var length: Int {
		return common.getSymbolLength(index: self.index)
	}

	func setStartOffset(_ offset: Int) {
		common.replacePointer(index: self.index, newAbsoluteOffset: offset)
	}
	
	var value : Int {
		return common.getValueAtPointer(index: self.index)
	}
	
	func setValue(_ value: Int) {
		common.setValueAtPointer(index: self.index, newValue: value)
	}

	func expand(by bytes: Int, save: Bool = false) {
		common.expandSymbol(self, by: bytes, save: save)
	}
	
	static func indexForStartOffset(offset: Int) -> Int? {
		for i in 0 ..< kNumberRelPointers {
			if common.getPointer(index: i) == offset {
				return i
			}
		}
		return nil
	}
}

enum PocketIndexes : Int {
	case CouponCounterDialog = 0
	case numberofCouponCounterDialog = 1
	case MartItems = 2
	case numberOfMartItems = 3
	case MartStartIndexes = 4
	case numberOfMarts = 5
	case MartGreetings = 6
	case numberOfMartGreetingSections = 7
	
	var index: Int {
		return rawValue
	}
	
	var startOffset : Int {
		return pocket.getPointer(index: self.rawValue)
	}
	
	var value : Int {
		return pocket.getValueAtPointer(index: self.rawValue)
	}
}
