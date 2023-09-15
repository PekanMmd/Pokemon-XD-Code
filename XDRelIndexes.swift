//
//  XDRelIndexes.swift
//  GoD Tool
//
//  Created by The Steez on 04/06/2018.
//

import Foundation

let kNumberMapPointers = 8 // min required in XD
enum MapRelIndexes : Int {
	case FirstCharacter = 0
	case NumberOfCharacters = 1
	
	case FirstWarpEntryLocation = 6 // warp entry points
	case NumberOfWarpEntryLocations = 7

	case groupData = 9
}


let kNumberRelPointers = 0x84
enum CommonIndexes : Int {
	
	// 0xf6c is debug menu options
	// each entry is used to set the story flag to the specified value
	// then calls common.scd's "@flagshop" function (0x5960017) to set other necessary flags
	
	// colosseum only
	case RoomData = -2
	case NumberOfRoomData = -3
	case Trainers = -4
	case NumberOfTrainers = -5
	case TrainerAIData = -6
	case NumberOfTrainerAIData = -7
	case PokemonData = -8
	case NumberOfPokemonData = -9
	case StringTable2 = -10
	case StringTable3 = -11
	
	// xd
	case BattleBingo  = 0
	case NumberOfBingoCards = 1
	case PeopleIDs = 2 // 2 bytes at offset 0 person id 4 bytes at offset 4 string id for character name
	case NumberOfPeopleIDs = 3
	case ContestData = 4
	case NumberOfContestData = 5
	case ContestTypes = 6
	case NumberOfContestTypes = 7
	case PokespotAppData = 8
	case NumberOfPokespotAppData = 9
	case Pokespots = 10
	case NumberOfPokespots = 11
	case PokespotRock = 12
	case PokespotRockEntries = 13
	case PokespotRockUnknown = 14
	case PokespotOasis = 15
	case PokespotOasisEntries = 16
	case PokespotOasisUnknown = 17
	case PokespotCave = 18
	case PokespotCaveEntries = 19
	case PokespotCaveUnknown = 20
	case PokespotAll = 21
	case PokespotAllEntries = 22
	case PokespotAllUnknown = 23
	case BattleCDs = 24
	case NumberBattleCDs = 25
	case Battles = 26
	case NumberOfBattles = 27
	case BattleFields = 28
	case NumberOfBattleFields = 29
	case BattleTypes = 30
	case NumberOfBattleTypes = 31
	case OrreColosseum = 32 // list of battle ids for each challenge round
	case NumberOfOrreColosseumEntries = 33
	case BattleSideData = 34
	case NumberOfBattleSideData = 35
	case AIWeightEffects = 36
	case NumberOfAIWeightEffects = 37
	case TrainerClasses = 38
	case NumberOfTrainerClasses = 39
	case AIPokemonRoles = 40
	case NumberOfAIPokemonRoles = 41
	case BattleLayouts = 42 // eg 2 trainers per side, 1 active pokemon per trainer, 6 pokemon per trainer
	case NumberOfBattleLayouts = 43
	case GeneralFlags = 44
	case NumberOfGeneralFlags = 45
	case StoryProgressFlags = 46
	case NumberOfStoryProgressFlags = 47
	case FlagItemData = 48
	case NumberOfFlagItemData = 49
	case FlagsMetaData = 50
	case NumberOfFlagsMetaData = 51
	case FlagPartyData = 52
	case NumberOfFlagPartyData = 53
	case FlagPokemonData = 54
	case NumberOfFlagPokemonData = 55
	case FlagValues = 56
	case NumberOfFlagValues = 57
	case Rooms = 58
	case NumberOfRooms = 59
	case Doors = 60 // doors that open when player is near
	case NumberOfDoors = 61
	case InteractionPoints = 62 // warps and inanimate objects
	case NumberOfInteractionPoints = 63
	case RoomBGM = 64 // byte 1 = volume, short 2 = room id, short 4 = bgm id
	case NumberOfRoomBGMs = 65
	case TreasureBoxData = 66 // 0x1c bytes each
	case NumberTreasureBoxes = 67
	case ValidItems = 68 // list of items which are actually available in XD
	case TotalNumberOfItems = 69
	case Items = 70
	case NumberOfItems = 71
	case LegendaryPokemon = 72
	case NumberOfLegendaryPokemon = 73
	case MasterBallPokemon = 74
	case NumberOfMasterBallPokemon = 75
	case PokefaceTextures = 76
	case NumberOfPokefaceTextures = 77
	case MenuSFX = 78
	case NumberOfMenuSFX = 79
	case MessageSFX = 80
	case NumberOfMessageSFX = 81
	case MsgPalettes = 82
	case NumberOfMsgPalettes = 83
	case CharacterModels = 84
	case NumberOfCharacterModels = 85
	case DeoxysFormes = 86
	case NumberOfDeoxysFormes = 87
	case PokemonStats = 88
	case NumberOfPokemon = 89
	case ShadowPokemonFilterData = 90
	case NumberOfShadowPokemonFilterData = 91
	case PokemonMenuAnimations = 92
	case NumberOfPokemonMenuAnimations = 93
	case Natures = 94
	case NumberOfNatures = 95
	case NatureMultipliers = 96 //1 byte numerator, 1 byte denominator
	case NumberOfNatureMultipliers = 97
	case PurificationChamberData = 98
	case NumberOfPurificationChamberData = 99
	case Ribbons = 100
	case NumberOfRibbons = 101
	case SoundsMetaData = 102
	case NumberOfSounds = 103
	case SoundFiles = 104
	case NumberOfSoundFiles = 105
	
	case SoundTestBGM = 108
	case NumberOfSoundTestBGM = 109
	case SoundTestEnvironmentSounds = 110
	case NumberOfSoundTestEnvironmentSounds = 111
	case SoundTestCries = 112
	case NumberOfSoundTestCries = 113
	case SoundTestSoundEffects = 114
	case NumberOfSoundTestSoundEffects = 115
	case TableResData = 118 // pointers added at runtime
	case NumberOfTableResData = 119
	case TutorialData = 120
	case NumberOfTutorialData = 121
	case MirorBData = 122
	case NumberOfMirorBDataEntries = 123 // Only 1 entry
	case Moves = 124
	case NumberOfMoves = 125
	case TutorMoves = 126
	case NumberOfTutorMoves = 127
	case WorldMapLocations = 128
	case NumberOfWorldMapLocations = 129
	case Types = 130
	case NumberOfTypes = 131

	case StringTable1 = 136
	case Script = 137

	var index: Int {
		return rawValue
	}

	var startOffset : Int {
		return common.getPointer(index: self.rawValue)
	}

	var length: Int {
		return common.getSymbolLength(index: self.rawValue)
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
	case CouponCounterDialog = 2
	case numberofCouponCounterDialog = 3 // 0x4c bytes each
	case MartItems = 4
	case numberOfMartItems = 5
	case MartGreetings = 6
	case numberOfMartGreetingSections = 7 // 0x4c bytes each
	
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
