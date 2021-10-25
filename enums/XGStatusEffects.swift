//
//  XGStatusEffects.swift
//  XGCommandLineTools
//
//  Created by StarsMmd on 22/06/2016.
//  Copyright © 2016 StarsMmd. All rights reserved.
//

import Foundation

var kFirstStatusEffectOffset: Int {
	if game == .XD {
		switch region {
		case .US: return 0x3f93e0
		case .EU: return 0x433d0c
		case .JP: return 0x3d6aec
		case .OtherGame: return -1
		}
	} else {
		switch region {
		case .US: return 0x358ba8
		case .EU: return 0x3a5c50
		case .JP: return 0x3452e8
		case .OtherGame: return -1
		}
	}
} // in Start.dol

let kSizeOfStatusEffect = 0x14
let kNumberOfStatusEffects = 87

let kStatusEffectDurationOffset = 0x4
let kStatusEffectNameIDOffset = 0x10

enum XGNonVolatileStatusEffects: Int, Codable, CaseIterable {
	case none			= 0

	case poison			= 3
	case badPoison		= 4
	case paralysis		= 5
	case burn			= 6
	case freeze			= 7
	case sleep			= 8

	var name: String {
		switch self {
		case .none: return "None"
		case .poison: return "Poisoned"
		case .badPoison: return "Badly Poisoned"
		case .paralysis: return "Paralyzed"
		case .burn: return "Burned"
		case .freeze: return "Frozen"
		case .sleep: return "Asleep"
		}
	}
}

enum XGStatusEffects: Int, Codable, CaseIterable {
	
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
	case truant = 34
	case charge = 36
	case ingrain = 37
	case fainted = 40
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
	
	var string: String {
		switch self {
			
		case .none:
			return "none"
		case .no_status:
			return "no status"
		case .brn_psn_or_par:
			return "burn, poison or paralysis"
		case .poison:
			return "poison"
		case .badPoison:
			return "bad poison"
		case .paralysis:
			return "paralysis"
		case .burn:
			return "burn"
		case .freeze:
			return "freeze"
		case .sleep:
			return "sleep"
		case .confusion:
			return "confusion"
		case .attract:
			return "attract"
		case .bound:
			return "bound"
		case .focus_energy:
			return "focus energy"
		case .flinched:
			return "flinched"
		case .must_recharge:
			return "needs recharge"
		case .rage:
			return "rage"
		case .substitute:
			return "substitute"
		case .destiny_bond:
			return "destiny bond"
		case .trapped:
			return "trapped"
		case .nightmare:
			return "nightmare"
		case .cursed:
			return "cursed"
		case .foresight:
			return "foresight"
		case .tormented:
			return "tormented"
		case .leech_seeded:
			return "leech see"
		case .locked_on_to:
			return "locked on"
		case .perish_song:
			return "perish song"
		case .truant:
			return "truant"
		case .fly:
			return "fly"
		case .dig:
			return "dig"
		case .dive:
			return "dive"
		case .charge:
			return "charge"
		case .ingrain:
			return "ingrain"
		case .fainted:
			return "fainted"
		case .disabled:
			return "disabled"
		case .encored:
			return "encore"
		case .protected:
			return "protected"
		case .endure:
			return "endure"
		case .pressure:
			return "pressure"
		case .bide:
			return "bide"
		case .taunted:
			return "taunted"
		case .helping_hand:
			return "helping hand"
		case .future_sight:
			return "future sight"
		case .choice_locked:
			return "choice locked"
		case .magic_coat:
			return "magic coat"
		case .mudsport:
			return "mud sport"
		case .watersport:
			return "water sport"
		case .flash_fire:
			return "flash fire boost"
		case .intimidated:
			return "intimidated"
		case .traced_ability:
			return "traced ability"
		case .no_held_item:
			return "held item used/lost"
		case .reverse_mode:
			return "reverse mode"
		case .neutral:
			return "neutral move"
		case .missed:
			return "move missed"
		case .super_effective:
			return "super effective move"
		case .ineffective:
			return "not very effective move"
		case .no_effect:
			return "no effect move"
		case .OHKO:
			return "OHKO"
		case .failed:
			return "move failed"
		case .endured:
			return "endured"
		case .hung_on:
			return "hung on with focus band"
		case .reflect:
			return "reflect"
		case .light_screen:
			return "light screen"
		case .spikes:
			return "spikes"
		case .safeguard:
			return "safeguard"
		case .mist:
			return "mist"
		case .follow_me:
			return "follow me"
		case .no_weather:
			return "no weather"
		case .permanent_sun:
			return "permanent sun"
		case .permanent_rain:
			return "permanent rain"
		case .permanent_sand:
			return "permanent sand"
		case .shadow_sky:
			return "shadow sky"
		case .hail:
			return "hail"
		case .sun:
			return "sun"
		case .rain:
			return "rain"
		case .sandstorm:
			return "sandstorm"
		}
	}
	
}

extension XGStatusEffects: XGEnumerable {
	var enumerableName: String {
		return string
	}
	
	var enumerableValue: String? {
		return rawValue.string
	}
	
	static var className: String {
		return "Status Effects"
	}
	
	static var allValues: [XGStatusEffects] {
		return allCases
	}
}





