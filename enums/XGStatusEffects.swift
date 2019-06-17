//
//  XGStatusEffects.swift
//  XGCommandLineTools
//
//  Created by StarsMmd on 22/06/2016.
//  Copyright © 2016 StarsMmd. All rights reserved.
//

import Foundation

let kFirstStatusEffectOffset = 0x3f93e0
let kSizeOfStatusEffect = 0x14
let kNumberOfStatusEffects = 87

let kStatusEffectDurationOffset = 0x4
let kStatusEffectNameIDOffset = 0x10

enum XGStatusEffects: Int, Codable {
	
	case none			= 0
	
	// non volatile status
	case no_status		= 1
	case brn_psn_or_par = 2
	case poison			= 3
	case badPoison		= 4
	case paralysis		= 5
	case burn			= 6
	case freeze			= 7
	case sleep			= 8
	
	// volatile status
	case confusion = 9
	case attract = 10
	case bound = 14
	case focus_energy = 15
	case flinched = 17
	case must_recharge = 18
	case rage = 19
	case substitute = 20
	case destiny_bond = 21
	case trapped = 22
	case nightmare = 23
	case cursed = 24
	case foresight = 25
	case tormented = 27
	case leech_seeded = 28
	case locked_on_to = 29
	case perish_song = 30
	case fly = 31
	case dig = 32
	case dive = 33
	case charge = 36
	case ingrain = 37
	case disabled = 41
	case encored = 42
	case protected = 43
	case endure = 44
	case pressure = 46
	case bide = 47
	case taunted = 48
	case helping_hand = 50
	case future_sight = 52
	case choice_locked = 54
	case magic_coat = 55
	
	// field
	case mudsport = 56
	case watersport = 57
	
	// abilities
	case flash_fire = 58
	case intimidated = 59
	case traced_ability = 60
	
	case no_held_item = 61
	
	// move effectiveness
	case reverse_mode = 62
	case neutral = 63
	case missed = 64
	case super_effective = 65
	case ineffective = 66
	case no_effect = 67
	case OHKO = 68
	case failed = 69
	case endured = 70
	case hung_on = 71 // focus band
	
	// field effects
	case reflect = 72
	case light_screen = 73
	case spikes = 74
	case safeguard = 75
	case mist = 76
	case follow_me = 77
	
	// weather
	case no_weather = 78
	case permanent_sun = 79
	case permanent_rain = 80
	case permanent_sand = 81
	case shadow_sky = 82
	case hail = 83
	case sun = 84
	case rain = 85
	case sandstorm = 86
	
	var startOffset : Int {
		return kFirstStatusEffectOffset + (self.rawValue * kSizeOfStatusEffect)
	}
	
	var nameID : Int {
		return Int(XGFiles.dol.data!.getWordAtOffset(startOffset + kStatusEffectNameIDOffset))
	}
	
	var duration : Int {
		return XGFiles.dol.data!.getByteAtOffset(startOffset + kStatusEffectDurationOffset)
	}
	
	func setDuration(turns: Int) {
		XGFiles.dol.data!.replaceByteAtOffset(startOffset + kStatusEffectDurationOffset, withByte: turns)
	}
}







