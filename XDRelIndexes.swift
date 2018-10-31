//
//  XDRelIndexes.swift
//  GoD Tool
//
//  Created by The Steez on 04/06/2018.
//

import Foundation

let kNumberMapPointers = 8 // min required
enum MapRelIndexes : Int {
	case FirstCharacter = 0
	case NumberOfCharacters = 1
	
	case FirstInteractionLocation = 6
	case NumberOfInteractionLocations = 7
}


let kNumberRelPointers = 0x84
enum CommonIndexes : Int {
	
	// colosseum only
	case PokefaceTextures = -1
	case RoomData = -2
	case NumberOfRoomData = -3
	case Trainers = -4
	case NumberOfTrainers = -5
	case TrainerAIData = -6
	case NumberOfTrainerAIData = -7
	case PokemonData = -8
	case NumberOfPokemonData = -9
	case AIDebugScenarios = -10
	case StoryDebugOptions = -12
	case BattleDebugScenarios = -13
	
	// xd
	case BattleBingo  = 0
	case NumberOfBingoCards = 1
	case PeopleIDs = 2 // 2 bytes at offset 0 person id 4 bytes at offset 4 string id for character name
	case NumberOfPeopleIDs = 3
	case numberOfPokespots = 11
	case PokespotRock = 12
	case PokespotRockEntries = 13
	case PokespotOasis = 15
	case PokespotOasisEntries = 16
	case PokespotCave = 18
	case PokespotCaveEntries = 19
	case PokespotAll = 21
	case PokespotAllEntries = 22
	case BattleCDs = 24
	case NumberBattleCDs = 25
	case Battles = 26
	case NumberOfBattles = 27
	case BattleFields = 28
	case NumberOfBattleFields = 29
	case TrainerClasses = 38
	case NumberOfTrainerClasses = 39
	case BattleLayouts = 42 // eg 2 trainers per side, 1 active pokemon per trainer, 6 pokemon per trainer
	case NumberOfBattleLayouts = 43
	case Flags = 44
	case NumberOfFlags = 45
	case Rooms = 58 // same as maps
	case NumberOfRooms = 59
	case Doors = 60 // doors that open when player is near
	case NumberOfDoors = 61
	case InteractionPoints = 62 // warps and inanimate objects
	case NumberOfInteractionPoints = 63
	case TreasureBoxData = 66 // 0x1c bytes each
	case NumberTreasureBoxes = 67
	case ValidItems = 68 // list of items which are actually available in XD
	case TotalNumberOfItems = 69
	case Items = 70
	case NumberOfItems = 71
	case CharacterModels = 84
	case NumberOfCharacterModels = 85
	case PokemonStats = 88
	case NumberOfPokemon = 89
	case Natures = 94
	case NumberOfNatures = 95
	case SoundsMetaData = 102
	case NumberOfSounds = 103
	case PokemonCrySoundEffects = 104
	case NumberCrySoundEffects = 105
	
	
	case USStringTable = 116
	case Moves = 124
	case NumberOfMoves = 125
	case TutorMoves = 126
	case NumberOfTutorMoves = 127
	case Types = 130
	case NumberOfTypes = 131
	
	var pointerOffset : Int {
		return common.getPointerOffset(index: self.rawValue)
	}
	
	var startOffset : Int {
		return common.getPointer(index: self.rawValue)
	}
	
	func setStartOffset(_ offset: Int) {
		common.replacePointer(index: self.rawValue, newAbsoluteOffset: offset)
	}
	
	var value : Int {
		return common.getValueAtPointer(index: self.rawValue)
	}
	
	func setValue(_ value: Int) {
		common.setValueAtPointer(index: self.rawValue, newValue: value)
	}
	
	static func indexForStartOffset(offset: Int) -> Int? {
		for i in 0 ... CommonIndexes.NumberOfTypes.rawValue{
			if common.getPointer(index: i) == offset {
				return i
			}
		}
		return nil
	}
}


enum PocketIndexes : Int {
	case MartStartIndexes  = 0
	case numberOfMarts = 1
	case MartGreetings = 2
	case numberOfMartGreetingSections = 3 // 0x4c bytes each
	case MartItems = 4
	case numberOfMartItems = 5
	
	var startOffset : Int {
		return pocket.getPointer(index: self.rawValue)
	}
	
	var value : Int {
		return pocket.getValueAtPointer(index: self.rawValue)
	}
}
