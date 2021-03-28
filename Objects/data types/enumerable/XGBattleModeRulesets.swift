//
//  XGBattleModeRulesets.swift
//  GoD Tool
//
//  Created by Stars Momodu on 29/01/2021.
//

import Foundation

let kNumberOfBattleModeRuleSets = game == .XD ? 4 : 3

let kSizeOfBattleModeRuleSetData: Int = {
	if game == .Colosseum { return 84 }
	switch region {
	case .US, .EU: return 144
	case .JP: return 124
	case .OtherGame: return 0
	}
}()

var kFirstBattleModeRuleSetOffset: Int {
	if game == .XD {
		switch region {
		case .US: return 0x2E7C08
		case .EU: return 0x2E9A10
		case .JP: return 0x2E24F0
		case .OtherGame: return 0
		}
	} else {
		switch region {
		case .US: return 0x265940
		case .EU: return 0x26A8A8
		case .JP: return 0x261060
		case .OtherGame: return 0
		}
	}
} // in start.dol

let kBattleModeRuleSetMinLevelOffset = 0x1
let kBattleModeRuleSetMaxLevelOffset = 0x3
let kBattleModeRuleSetTotalLevelOffset = 0x4

// not sure if this is the right location
// could possibly be "number of unqiue species required" so 6 means no dupes
let kBattleModeRuleSetAllowSamePokemonOffset = 0x7

let kBattleModeRuleSetAllowHoldItemsOffset = 0xc
let kBattleModeRuleSetAllowDuplicateItemsOffset = 0xd
let kBattleModeRuleSetSleepClauseOnOffset = 0xe
let kBattleModeRuleSetFreezeClauseOnOffset = 0xf
let kBattleModeRuleSetAllowSkillSwapOffset = 0x10
let kBattleModeRuleSetExplosionUserLosesOffset = 0x11
let kBattleModeRuleSetAllowLastMonPerishOrBondOffset = 0x12
let kBattleModeRuleSetAllowFixedDamageMovesOffset = 0x13

let kBattleModeRuleSetMatchTimeLimitOffset = 0x14 // negate number for unlimited
let kBattleModeRuleSetTurnTimeLimitOffset = 0x16 // negate number for unlimited

class XGBattleModeRuleSets {

	var index: Int

	var startOffser: Int {
		return kFirstBattleModeRuleSetOffset + (index * kSizeOfBattleModeRuleSetData)
	}

	init(index: Int) {
		self.index = index
	}
}
