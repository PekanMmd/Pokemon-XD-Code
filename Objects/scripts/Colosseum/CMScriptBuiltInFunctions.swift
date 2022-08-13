//
//  CMScriptBuiltInFunctions.swift
//  GoD Tool
//
//  Created by Stars Momodu on 03/06/2021.
//

import Foundation

enum CMSOperators: CustomStringConvertible {
	case and, andl
	case or, orl
	case not, negate
	case multiply, divide, mod
	case add, subtract
	case lessThan, lessThanEqual
	case greaterThan, greaterThanEqual
	case equal, notEqual

	var description: String {
		switch self {
		case .and: return "&"
		case .andl: return "&&"
		case .or: return "|"
		case .orl: return "||"
		case .not: return "!"
		case .negate: return "-"
		case .multiply: return "*"
		case .divide: return "/"
		case .mod: return "%"
		case .add: return "+"
		case .subtract: return "-"
		case .lessThan: return "<"
		case .lessThanEqual: return "<="
		case .greaterThan: return ">"
		case .greaterThanEqual: return ">="
		case .equal: return "="
		case .notEqual: return "!="
		}
	}

	var forcedReturnType: CMSMacroTypes? {
		switch self {
		case .andl, .orl, .not, .lessThan, .lessThanEqual, .greaterThan, .greaterThanEqual, .equal, .notEqual:
			return .bool
		default:
			return nil
		}
	}
}

var ScriptBuiltInFunctions : [Int : (name: String, parameterTypes: [CMSMacroTypes?]?, returnType: CMSMacroTypes?, hint: String)] = [
	2: (name: "randomNumberMod", parameterTypes: [.integer], returnType: .integer, hint: "generates a random number between 0 and the parameter-1"),
	3: (name: "threadRunScriptInBackground", parameterTypes: [.scriptFunction, .integer, .integer, .integer, .integer], returnType: .integer, hint: "script function, arg1, arg2, arg3, arg4"),

	6: (name: "threadWaitForCompletion", parameterTypes: [.integer], returnType: nil, hint: "thread descriptor"),
	7: (name: "dialogDisplaySilentMessage", parameterTypes: [.msgID, .integer, .integer], returnType: nil, hint: "msg id, unk, unk"),
	8: (name: "dialogWaitForMessage", parameterTypes: [.bool], returnType: nil, hint: ""),

	11: (name: "dialogDisplayYesNoMenu", parameterTypes: nil, returnType: .yesNoIndex, hint: ""),

	23: (name: "dialogDisplayNameEntryMenu", parameterTypes: nil, returnType: nil, hint: ""),
	24: (name: "dialogDisplayPCBoxMenu", parameterTypes: nil, returnType: nil, hint: ""),

	28: (name: "transitionBegin", parameterTypes: [.transitionID, .float], returnType: nil, hint: "transition id, duration"),
	29: (name: "transitionWait", parameterTypes: [.bool], returnType: nil, hint: ""),

	31: (name: "playerProcessEvents", parameterTypes: nil, returnType: nil, hint: ""),
	32: (name: "playerLockMovement", parameterTypes: nil, returnType: nil, hint: ""),
	33: (name: "playerFreeMovement", parameterTypes: nil, returnType: nil, hint: ""),
	34: (name: "playerTriggerScript", parameterTypes: [.scriptFunction, .integer, .integer, .integer, .integer], returnType: nil, hint: "script function, arg 1, arg 2, arg 3, arg 4"),

	40: (name: "cameraSetPosition", parameterTypes: [.float, .float, .float], returnType: nil, hint: "x, y, z"),
	41: (name: "cameraSetRotationAboutAxes", parameterTypes: [.float, .float, .float], returnType: nil, hint: "x, y, z"),
	42: (name: "cameraPresetFromFile", parameterTypes: [.integer, .fileIdentifier, .integer, .integer], returnType: nil, hint: "group id?, file id unk, unk"),

	// 46: cameraWaitForAnimation?

	47: (name: "characterHide", parameterTypes: [.resourceID, .groupID], returnType: nil, hint: "resource id, group id"), // params seem to be ordered opposite to usual

	50: (name: "characterSetVisibility", parameterTypes: [.groupID, .resourceID, .bool], returnType: nil, hint: "group id, resource id, visibility"),
	51: (name: "characterSetAnimation", parameterTypes: [.groupID, .resourceID, .integer, .bool, .bool], returnType: nil, hint: "group id, resource id, animation id, unk, shouldRepeat"),

	53: (name: "characterWaitForAnimation", parameterTypes: [.groupID, .resourceID, .bool], returnType: nil, hint: "group id, resource id, unk"),

	54: (name: "characterTalk", parameterTypes: [.groupID, .resourceID, .msgID], returnType: nil, hint: "group id, resource id, string id"),
	55: (name: "characterEndSpeech", parameterTypes: [.groupID, .resourceID], returnType: nil, hint: "group id, resource id"),

	58: (name: "characterCheckWithinBounds", parameterTypes: [.groupID, .resourceID, .float, .float, .float, .float], returnType: nil, hint: ""),
	59: (name: "characterSetPosition", parameterTypes: [.groupID, .resourceID, .float, .float, .float], returnType: nil, hint: "group id, resource id, x, y, z"),
	60: (name: "characterRotateAroundAxes", parameterTypes: [.groupID, .resourceID, .float, .float, .float], returnType: nil, hint: "group id, resource id, x, y ,z"),
	61: (name: "characterMoveToPosition", parameterTypes: [.groupID, .resourceID, .float, .float, .float], returnType: nil, hint: "group id, resource id, x, y, z"),
	62: (name: "characterWaitForMovement", parameterTypes: [.groupID, .resourceID, .bool], returnType: nil, hint: "group id, resource id, unk"),
	63: (name: "characterClearFlags", parameterTypes: [.groupID, .resourceID, .integer], returnType: nil, hint: "group id, resource id, flag bits"),
	64: (name: "characterSetFlags", parameterTypes: [.groupID, .resourceID, .integer], returnType: nil, hint: "group id, resource id, flag bits"),

	68: (name: "characterTurnToAngle", parameterTypes: [.groupID, .resourceID, .float], returnType: nil, hint: "group id, resource id, angle"),

	70: (name: "characterAttachToCharacter", parameterTypes: [.groupID, .resourceID, .groupID, .resourceID, .integer], returnType: nil, hint: "gid, rid, targer gid, target rid, unk"),

	73: (name: "characterRunToPosition", parameterTypes: [.groupID, .resourceID, .float, .float, .float], returnType: nil, hint: "group id, resource id, x, y, z"),

	78: (name: "flagSetFalse", parameterTypes: [.flag], returnType: nil, hint: ""),
	79: (name: "flagSetTrue", parameterTypes: [.flag], returnType: nil, hint: ""),
	80: (name: "flagSetValue", parameterTypes: [.flag, .integer], returnType: nil, hint: ""),
	81: (name: "flagCheckTrue", parameterTypes: [.flag], returnType: .bool, hint: ""),
	82: (name: "flagGetValue", parameterTypes: [.flag], returnType: .integer, hint: ""),

	92: (name: "getCurrentRoomID", parameterTypes: nil, returnType: .room, hint: ""),
	93: (name: "getCurrentGroupID", parameterTypes: nil, returnType: .groupID, hint: ""),
	94: (name: "mapGetPreviousRoomID", parameterTypes: nil, returnType: .room, hint: ""),
	95: (name: "mapWarpToRoom", parameterTypes: [.room, .integer], returnType: nil, hint: "mapid, entry point id"),

	98: (name: "mapWarpToMenuRoom", parameterTypes: [.room], returnType: nil, hint: "mapid"),

	102: (name: "battleStart", parameterTypes: [.battleID], returnType: nil, hint: ""),
	103: (name: "battleGetResult", parameterTypes: nil, returnType: .battleResult, hint: ""),
	104: (name: "soundSetBackgroundMusic", parameterTypes: [.integer, .integer, .integer], returnType: .battleResult, hint: "id, unk, volume"),

	112: (name: "modelGetResourceID", parameterTypes: [.fileIdentifier], returnType: .resourceID, hint: "model id"),

	119: (name: "playerReceiveItem", parameterTypes: [.item, .integer], returnType: .battleResult, hint: "item id, quantity"),

	128: (name: "mapSetReturnMap", parameterTypes: nil, returnType: nil, hint: "unk, current map id, unk"),

	131: (name: "characterSurpriseAnimation", parameterTypes: [.groupID, .resourceID, .bool], returnType: nil, hint: "group id, resource id, unk"),
	132: (name: "dialogSetMessageVar", parameterTypes: [.integer, .integer], returnType: nil, hint: "msg var, value"),

	144: (name: "mapWarpToNextRoomWithTransitions", parameterTypes: [.scriptFunction, .scriptFunction], returnType: nil, hint: "script before warp, script after"),

	151: (name: "characterFaceDirection", parameterTypes: [.groupID, .resourceID, .integer], returnType: nil, hint: "gid, rid, unk"),
	152: (name: "battleStartBattleWithOptions", parameterTypes: [.battleID, .bool, .bool], returnType: nil, hint: ""),

	157: (name: "sleep", parameterTypes: nil, returnType: nil, hint: "duration"),

	163: (name: "useCologne", parameterTypes: nil, returnType: nil, hint: "duration"),

	165: (name: "characterFaceCharacter", parameterTypes: [.groupID, .resourceID, .groupID, .resourceID, .float], returnType: nil, hint: "target gid, target rid, arg gid, arg rid, unk (speed?)"),

	181: (name: "characterTurnHeadTowardsCharacter", parameterTypes: [.groupID, .resourceID, .groupID, .resourceID], returnType: nil, hint: "arg gid, rag rid, target gid, target rid"),

	189: (name: "pdaUpdateStrategyMemo", parameterTypes: [], returnType: .bool, hint: "-> is already up-to-date?"),

	191: (name: "mapTransformElement", parameterTypes: [.fileIdentifier, .bool, .bool, .bool], returnType: nil, hint: ""),

	194: (name: "mapBeginRelicPurifications", parameterTypes: [.integer, .integer], returnType: nil, hint: ""),

	198: (name: "menuEnterTradingMenu", parameterTypes: nil, returnType: nil, hint: ""),
	199: (name: "menuDisplayCustomMenu", parameterTypes: [.array(.msgID), .integer, .integer, .integer, .integerIndex], returnType: nil, hint: "msg ids array, length, x, y, start index"),

	217: (name: "playerReceiveGiftPokemon", parameterTypes: [.integer], returnType: .integerIndex, hint: "gift pokemon id"),
	218: (name: "soundPlayPokemonCry", parameterTypes: [.pokemon], returnType: nil, hint: ""),

	224: (name: "dialogDisplayMessageWithOptions", parameterTypes: [.msgID, .integer, .integer, .integer], returnType: .integer, hint: "msg id, unk, unk, unk"),

	228: (name: "soundGetCurrentBackgroundMusic", parameterTypes: nil, returnType: .integer, hint: ""),

	235: (name: "menuShowSaveMenu", parameterTypes: [.bool], returnType: .bool, hint: ""),
	236: (name: "playerGetCouponsEarnedOnCurrentRun", parameterTypes: nil, returnType: .integerCoupons, hint: ""),

	239: (name: "playerGetCouponsEarnedInLastArea", parameterTypes: nil, returnType: .integerCoupons, hint: ""),

	241: (name: "mapActivateParticleEffects", parameterTypes: [.fileIdentifier, .fileIdentifier], returnType: nil, hint: ""),
	242: (name: "playerCountPurifiablePartyPokemon", parameterTypes: [], returnType: .integer, hint: ""),


]
