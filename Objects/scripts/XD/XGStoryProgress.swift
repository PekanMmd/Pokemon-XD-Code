//
//  XGStoryProgress.swift
//  GoD Tool
//
//  Created on 9/19/20.
//

enum XGStoryProgress: Int, CaseIterable, Codable {
	case start = 0
	case completedTutorialBattle = 10
	case lookingForPDA = 20
	case lookingForJovi = 30
	case defeatedChobinForFirstTime = 40
	case admiredUnhealthySandals = 50
	case recruitedJoviFromKaminko = 60
	case returnedJoviFromKaminko = 70
	case lookingForKraneDownstairs = 80
	case receivedSnagMachine = 90
	case snaggedFirstShadowPokemon = 100
	case heardLilysMotivationalSpeech = 110
	case askedToPickUpMachinePart = 120
	case receivedFirstTwoKraneMemos = 130
	case watchedArdosKickedZooksButt = 140
	case metAcriAndEmili = 150
	case acquiredEeveeEvolutionItem = 160
	case metPerr = 170
	case acquiredMachinePart = 180
	case receivedSecondBatchOfKraneMemos = 190
	case gaveMachinePartToLily = 191
	case directedToAgateVillage = 200
	case metEagun = 260
	case defeatedEagunByRelicStone = 270
	case purifiedFirstShadowPokemon = 280
	case directedToMtBattle = 290
	case gavePDANumberToEagun = 300
	case directedToCipherLab = 310
	case metHexagonBrothers = 320
	case watchedKraneRefuseToHelpLovrina = 330
	case recruitedKraneInCipherLab = 340
	case defeatedLovrinaInCipherLab = 350
	case returnedKraneToResearchLab = 360
	case viewedPurificationChamber = 370
	case lookingForDatan = 380
	case directedToPyriteTown = 390
	case arrivedAtPyriteTown = 400
	case watchedTrudlyAndFollyAnnoyOfficerJohnson = 410
	case canEnterNettsOffice = 420
	case directedToRockPokespot = 430
	case assistingDuking = 440
	case placedFoodAtRockPokespot = 450
	case directedToOasisPokespot = 460
	case directedToCavePokespot = 470
	case battledMirorBAtCavePokespot = 480
	case enteredONBSDuringCipherInvasion = 481
	case battledExolAtONBS = 490
	case directedToPhenacCity = 500
	case directedToRealgamTower = 510
	case visitedRealgamTower = 520
	case acquiredMusicDisc = 530
	case insertedMusicDisc = 540
	case foundLetterForJusty = 550
	case watchedJustyImpostorsExitGym = 560
	case defeatedCipherPeonsInGym = 570
	case defeatedSnattleInPhenacCity = 580
	case acquiredGymElevatorKey = 590
	case rescuedGymHostages = 600
	case directedToSSLibra = 610
	case unlockedAgateDayCare = 620
	case exitedGymBasement = 630
	case gotStuckInDesertSand = 640
	case agreedToFindBonsly = 650
	case lookingForMakan = 660
	case praisedByVerich = 670
	case defeatedRoboGroudonChobin = 680
	case permittedToEnterKaminkosBasement = 690
	case askedMakanToUpgradeScooter = 700
	case acquiredUpgradedScooter = 710
	case departedForSSLibraWithUpgradedScooter = 720
	case arrivedAtSSLibra = 721
	case foughtSmartonOnSSLibra = 730
	case lostSnagMachine = 740
	case directedToCipherKeyLair = 750
	case battledZookWithoutSnagMachine = 751
	case directedToOutskirtStand = 760
	case defeatedMirorBAtOutskirtStand = 770
	case watchedNewsAtOutskirtStand = 780
	case spokeWithHordel = 781
	case directedToSnagemHideout = 790
	case reclaimedSnagMachine = 800
	case defeatedZookWithSnagMachine = 810
	case stoppedByCipherKeyLairBodybuilders = 820
	case assistedByTeamSnagemAtCipherKeyLair = 830
	case enteredShadowPokemonFactory = 840
	case blewShadowPokemonFactoryPower = 850
	case defeatedGoriganAtShadowPokemonFactory = 860
	case learnedOfStolenDragonite = 870
	case canUseRoboKyogre = 880
	case steppedFootOnCitadarkIsle = 890
	case defeatedSnattleOnCitadarkIsle = 900
	case walledByGreevil = 910
	case enteredCitadarkIsleDome = 920
	case defeatedEldes = 940
	case snaggedOrDefeatedShadowLugia = 950
	case defeatedGreevil = 960
	case watchedToughFatherSonLove = 970
	case unlockedOrreColosseum = 980
	case defeatedOrreColosseumRound1 = 990
}

extension XGStoryProgress: Comparable {
	static func < (lhs: XGStoryProgress, rhs: XGStoryProgress) -> Bool {
		return lhs.rawValue < rhs.rawValue
	}
}

extension XGStoryProgress {

	var progress: String {
		guard rawValue < XGStoryProgress.defeatedGreevil.rawValue else { return "100%" }
		let progress = Double(rawValue) / Double(XGStoryProgress.defeatedGreevil.rawValue) * 100
		var multiplier = 1.0
		if rawValue < XGStoryProgress.acquiredMachinePart.rawValue {
			multiplier = 0.10
		} else if rawValue < XGStoryProgress.directedToCipherLab.rawValue {
			multiplier = 0.15
		} else if rawValue < XGStoryProgress.defeatedLovrinaInCipherLab.rawValue {
			multiplier = 0.20
		} else if rawValue < XGStoryProgress.directedToRockPokespot.rawValue {
			multiplier = 0.25
		} else if rawValue < XGStoryProgress.battledExolAtONBS.rawValue {
			multiplier = 0.33
		} else if rawValue < XGStoryProgress.defeatedSnattleInPhenacCity.rawValue {
			multiplier = 0.40
		} else if rawValue < XGStoryProgress.departedForSSLibraWithUpgradedScooter.rawValue {
			multiplier = 0.50
		} else if rawValue < XGStoryProgress.lostSnagMachine.rawValue {
			multiplier = 0.60
		} else if rawValue < XGStoryProgress.directedToOutskirtStand.rawValue {
			multiplier = 0.67
		} else if rawValue < XGStoryProgress.reclaimedSnagMachine.rawValue {
			multiplier = 0.75
		} else if rawValue < XGStoryProgress.assistedByTeamSnagemAtCipherKeyLair.rawValue {
			multiplier = 0.85
		} else if rawValue <= XGStoryProgress.steppedFootOnCitadarkIsle.rawValue {
			multiplier = 0.9
		}
		let percentage = String(format: "%.1f", progress * multiplier) + "%"
		return percentage
	}

	var macroName: String {
		return "STORY_" + name
	}

	var name: String {
		switch self {
		case .start:
			return "START"
		case .completedTutorialBattle:
			return "COMPLETED_TUTORIAL_BATTLE"
		case .lookingForPDA:
			return "LOOKING_FOR_PDA"
		case .lookingForJovi:
			return "LOOKING_FOR_JOVI"
		case .defeatedChobinForFirstTime:
			return "DEFEATED_CHOBIN_1"
		case .admiredUnhealthySandals:
			return "SAW_UNHEALTHY_SANDALS"
		case .recruitedJoviFromKaminko:
			return "RECRUITED_JOVI"
		case .returnedJoviFromKaminko:
			return "RETURNED_JOVI"
		case .lookingForKraneDownstairs:
			return "LOOKING_FOR_KRANE_DOWNSTAIRS"
		case .receivedSnagMachine:
			return "RECEIVED_SNAG_MACHINE"
		case .snaggedFirstShadowPokemon:
			return "SNAGGED_FIRST_POKEMON"
		case .heardLilysMotivationalSpeech:
			return "HEARD_LILY_GET_MOTIVATED"
		case .askedToPickUpMachinePart:
			return "ASKED_TO_FIND_MACHINE_PART"
		case .receivedFirstTwoKraneMemos:
			return "RECEIVED_FIRST_KRANE_MEMOS"
		case .watchedArdosKickedZooksButt:
			return "WATCHED_ZOOK_GET_WHOOPED"
		case .metAcriAndEmili:
			return "MET_EMILI"
		case .acquiredEeveeEvolutionItem:
			return "ACQUIRED_EVOLUTION_ITEM"
		case .metPerr:
			return "MET_PERR"
		case .acquiredMachinePart:
			return "ACQUIRED_MACHINE_PART"
		case .receivedSecondBatchOfKraneMemos:
			return "RECEIVED_MORE_KRANE_MEMOS"
		case .gaveMachinePartToLily:
			return "GAVE_MACHINE_PART_TO_LILY"
		case .directedToAgateVillage:
			return "DIRECTED_TO_AGATE"
		case .metEagun:
			return "MET_EAGUN"
		case .defeatedEagunByRelicStone:
			return "DEFEATED_EAGUN_IN_AGATE"
		case .purifiedFirstShadowPokemon:
			return "PURIFIED_FIRST_POKEMON"
		case .directedToMtBattle:
			return "DIRECTED_TO_MT_BATTLE"
		case .gavePDANumberToEagun:
			return "GAVE_PDA_NUMBER_TO_EAGUN"
		case .directedToCipherLab:
			return "DIRECTED_TO_CIPHER_LAB"
		case .metHexagonBrothers:
			return "MET_HEXAGON_BROTHERS"
		case .watchedKraneRefuseToHelpLovrina:
			return "WATCHED_KRANE_SCOLD_LOVRINA"
		case .recruitedKraneInCipherLab:
			return "RECRUITED_KRANE"
		case .defeatedLovrinaInCipherLab:
			return "DEFEATED_LOVRINA_IN_LAB"
		case .returnedKraneToResearchLab:
			return "RETURNED_KRANE"
		case .viewedPurificationChamber:
			return "VIEWED_PURIFICATION_CHAMBER"
		case .lookingForDatan:
			return "LOOKING_FOR_DATAN"
		case .directedToPyriteTown:
			return "DIRECTED_TO_PYRITE"
		case .arrivedAtPyriteTown:
			return "ARRIVED_AT_PYRITE"
		case .watchedTrudlyAndFollyAnnoyOfficerJohnson:
			return "WATCHED_TRUDLY_AND_FOLLY_ANNOY_JOHNSON"
		case .canEnterNettsOffice:
			return "CAN_ENTER_NETTS_OFFICE"
		case .directedToRockPokespot:
			return "DIRECTED_TO_ROCK_POKESPOT"
		case .assistingDuking:
			return "ASSISTING_DUKING"
		case .placedFoodAtRockPokespot:
			return "PLACED_FOOD_AT_POKESPOT"
		case .directedToOasisPokespot:
			return "DIRECTED_TO_OASIS_POKESPOT"
		case .directedToCavePokespot:
			return "DIRECTED_TO_CAVE_POKESPOT"
		case .battledMirorBAtCavePokespot:
			return "BATTLED_MIROR_B_AT_CAVE_POKESPOT"
		case .enteredONBSDuringCipherInvasion:
			return "ENTERED_INVADED_ONBS"
		case .battledExolAtONBS:
			return "BATTLED_EXOL"
		case .directedToPhenacCity:
			return "DIRECTED_TO_PHENAC"
		case .directedToRealgamTower:
			return "DIRECTED_TO_REALGAM"
		case .visitedRealgamTower:
			return "VISITED_REALGAM"
		case .acquiredMusicDisc:
			return "ACQUIRED_MUSIC_DISC"
		case .insertedMusicDisc:
			return "INSERTED_MUSIC_DISC"
		case .foundLetterForJusty:
			return "FOUND_LETTER_FOR_JUSTY"
		case .watchedJustyImpostorsExitGym:
			return "WATCHED_JUSTY_IMPOSTOR_SCENE"
		case .defeatedCipherPeonsInGym:
			return "DEFEATED_GYM_PEONS"
		case .defeatedSnattleInPhenacCity:
			return "DEFEATED_SNATTLE_IN_PHENAC"
		case .acquiredGymElevatorKey:
			return "ACQUIRED_GYM_ELEVATOR_KEY"
		case .rescuedGymHostages:
			return "RESCUED_GYM_HOSTAGES"
		case .directedToSSLibra:
			return "DIRECTED_TO_S_S_LIBRA"
		case .unlockedAgateDayCare:
			return "UNLOCKED_DAY_CARE"
		case .exitedGymBasement:
			return "EXITED_GYM_BASEMENT"
		case .gotStuckInDesertSand:
			return "GOT_SAND_IN_YOUR_SCOOTER"
		case .agreedToFindBonsly:
			return "AGREED_TO_FIND_BONSLY"
		case .lookingForMakan:
			return "LOOKING_FOR_MAKAN"
		case .praisedByVerich:
			return "PRAISED_BY_VERICH"
		case .defeatedRoboGroudonChobin:
			return "DEFEATED_ROBO_GROUDON_CHOBIN"
		case .permittedToEnterKaminkosBasement:
			return "CAN_ENTER_KAMINKO_BASEMENT"
		case .askedMakanToUpgradeScooter:
			return "ASKED_MAKAN_TO_UPGRADE_SCOOTER"
		case .acquiredUpgradedScooter:
			return "ACQUIRED_UPGRADED_SCOOTER"
		case .departedForSSLibraWithUpgradedScooter:
			return "DEPARTED_FOR_SSLIBRA_WITH_NEW_SCOOTER"
		case .arrivedAtSSLibra:
			return "ARRIVED_AT_SSLIBRA"
		case .foughtSmartonOnSSLibra:
			return "FOUGHT_SMARTON_ON_SSLIBRA"
		case .lostSnagMachine:
			return "LOST_SNAG_MACHINE"
		case .directedToCipherKeyLair:
			return "DIRECTED_TO_CIPHER_KEY_LAIR"
		case .battledZookWithoutSnagMachine:
			return "BATTLED_ZOOK_WITHOUT_SNAG_MACHINE"
		case .directedToOutskirtStand:
			return "DIRECTED_TO_OUTSKIRT_STAND"
		case .defeatedMirorBAtOutskirtStand:
			return "DEFEATED_MIROR_B_AT_OUTSKIRT_STAND"
		case .watchedNewsAtOutskirtStand:
			return "WATCHED_OUTSKIRT_STAND_NEWS"
		case .spokeWithHordel:
			return "SPOKE_WITH_HORDEL"
		case .directedToSnagemHideout:
			return "DIRECTED_TO_SNAGEM_HIDEOUT"
		case .reclaimedSnagMachine:
			return "RECLAIMED_SNAG_MACHINE"
		case .defeatedZookWithSnagMachine:
			return "DEFEATED_ZOOK_WITH_SNAG_MACHINE"
		case .stoppedByCipherKeyLairBodybuilders:
			return "STOPPED_BY_BODYBUILDERS"
		case .assistedByTeamSnagemAtCipherKeyLair:
			return "SAVED_BY_TEAM_SNAGEM"
		case .enteredShadowPokemonFactory:
			return "ENTERED_FACTORY"
		case .blewShadowPokemonFactoryPower:
			return "BLEW_FACTORY_POWER"
		case .defeatedGoriganAtShadowPokemonFactory:
			return "DEFEATED_GORIGAN_AT_FACTORY"
		case .learnedOfStolenDragonite:
			return "LEARNED_OF_STOLEN_DRAGONITE"
		case .canUseRoboKyogre:
			return "CAN_USE_ROBO_KYOGRE"
		case .steppedFootOnCitadarkIsle:
			return "STEPPED_FOOT_ON_CITADARK"
		case .defeatedSnattleOnCitadarkIsle:
			return "DEFEATED_SNATTLE_ON_CITADARK"
		case .walledByGreevil:
			return "WALLED_BY_GREEVIL"
		case .enteredCitadarkIsleDome:
			return "ENTERED_CITADARK_DOME"
		case .defeatedEldes:
			return "DEFEATED_ELDES"
		case .snaggedOrDefeatedShadowLugia:
			return "FOUGHT_LUGIA"
		case .defeatedGreevil:
			return "DEFEATED_GREEVIL"
		case .watchedToughFatherSonLove:
			return "WATCHED_FINAL_CUTSCENE"
		case .unlockedOrreColosseum:
			return "UNLOCKED_ORRE_COLOSSEUM"
		case .defeatedOrreColosseumRound1:
			return "DEFEATED_ORRE_COLOSSEUM_ROUND_1"
		}
	}
}
