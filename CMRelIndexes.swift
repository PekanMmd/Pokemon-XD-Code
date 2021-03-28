//
//  CMRelIndexes.swift
//  Colosseum Tool
//
//  Created by The Steez on 04/06/2018.
//

import Foundation

enum MapRelIndexes : Int {
	case FirstCharacter = 0
	case NumberOfCharacters = 1
	case FirstInteractionLocation = 6
	case NumberOfInteractionLocations = 7
}


let kNumberRelPointers = 0x6c
enum CommonIndexes : Int {
	
	case NumberOfItems = -1 // items are in dol in colosseum
	case stringTable1 = -2 // offset 0x59890 but not indexed apparently
	// haven't looked for these in colosseum yet
	case BGM = -3
	case NumberOfBGMIDs = -4
	
	
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
	
	case Trainers = 44
	case NumberOfTrainers = 45
	case TrainerAIData = 46
	case NumberOfTrainerAIData = 47
	case TrainerPokemonData = 48
	case NumberOfTrainerPokemonData = 49
	
	case Battles = 50
	case NumberOfBattles = 51
	
	case MusicSamples = 52 // 8bytes each. 0-3 file identifier, 6-7 unknown identifier
	case NumberOfMusicSamples = 53
	
	case BattleDebugScenarios = 56
	case NumberOfBattleDebugScenarios = 57
	case AIDebugScenarios = 58
	case NumberOfAIDebugScenarios = 59
	
	case StoryDebugOptions = 32
	case NumberOfStoryDebugOptions = 33
	
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

	case Multipliers = 70
	case NumberOfMultipliers = 71
	case CharacterModels = 72
	case NumberOfCharacterModels = 73
	
	case ShadowData = 80
	case NumberOfShadowPokemon = 81
	
	case PokemonMetLocations = 82
	case NumberOfMetLocations = 83
	
	case InteractionPoints = 86 // warps and interactable objects
	case NumberOfInteractionPoints = 87
	
	case StringTableB = 101
	
	case PokemonStats = 68
	case NumberOfPokemon = 69
	
	case Natures = 64
	case NumberOfNatures = 65
	
	
	case Moves = 62
	case NumberOfMoves = 63
	
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
		for i in 0 ..< kNumberRelPointers {
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
