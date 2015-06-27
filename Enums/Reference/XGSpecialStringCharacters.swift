//
//  XGSpecialStringCharacters.swift
//  XG Tool
//
//  Created by The Steez on 22/05/2015.
//  Copyright (c) 2015 Ovation International. All rights reserved.
//

import Foundation

let k2ByteChars = [0x07, 0x09, 0x38, 0x52, 0x53, 0x5B, 0x5C]
let k5ByteChars = [0x08]

let kNewLine		= "New Line"
let kDialogueEnd	= "Dialogue End"
let kClearWindow	= "Clear Window"
let kKanjiStart		= "Kanji"
let kFuriganaStart	= "Furigana"
let kFuriganaEnd	= "Furigana End"
let kChangeColourP	= "Predef Colour"
let kChangeColourS	= "Spec Colour"
let kPause			= "Pause"
let kBattlePlayer	= "Player B"
let kFieldPlayer	= "Player F"
let kSpeaker		= "Speaker"
let kSetSpeaker		= "Set Speaker"


enum XGSpecialCharacters : Int {
	
	case NewLine				= 0x00
	case Special01				= 0x01
	case DialogueEnd			= 0x02
	case ClearWindow			= 0x03
	case KanjiStart				= 0x04
	case FuriganaStart			= 0x05
	case FuriganaEnd			= 0x06
	case Special07				= 0x07 // 2bytes
	case ChangeColourSpecified	= 0x08 // 5bytes (rgba)
	case Pause					= 0x09 // 2 bytes (second byte determines duration, likely in tenths of a second)
	case Unused0A				= 0x0A
	case Special0B				= 0x0B
	case Special0C				= 0x0C
	case Var0D					= 0x0D
	case Var0E					= 0x0E
	case VarPokemon0F			= 0x0F
	case VarPokemon10			= 0x10
	case VarPokemon11			= 0x11
	case VarPokemon12			= 0x12
	case Player13				= 0x13 // Used in battle
	case SentOutPokemon1		= 0x14
	case SentOutPokemon2		= 0x15
	case VarPokemon16			= 0x16
	case VarPokemon17			= 0x17
	case VarPokemon18			= 0x18
	case VarPokemon19			= 0x19
	case VarAbility1A			= 0x1A
	case VarAbility1B			= 0x1B
	case VarAbility1C			= 0x1C
	case VarAbility1D			= 0x1D
	case VarPokemon1E			= 0x1E
	case Special1F				= 0x1F
	case VarPokemon20			= 0x20
	case VarPokemon21			= 0x21
	case FoeTrainerClass		= 0x22
	case FoeTrainerName			= 0x23
	case Special24				= 0x24
	case VarFoe25				= 0x25
	case VarFoe26				= 0x26
	case VarFoe27				= 0x27
	case VarMove28				= 0x28
	case VarItem29				= 0x29
	case Unused2A				= 0x2A
	case PlayerInField			= 0x2B
	case Rui					= 0x2C // Colosseum only
	case VarItem2D				= 0x2D
	case VarItem2E				= 0x2E
	case VarQuantity			= 0x2F
	case Var30					= 0x30
	case Var31					= 0x31
	case Var32					= 0x32
	case Var33					= 0x33
	case Var34					= 0x34
	case Var35					= 0x35
	case Var36					= 0x36
	case Var37					= 0x37
	case ChangeColourPredefined	= 0x38 // 2 bytes (0x0 = white, 0x1 = yellow, 0x2 = green, 0x3 = blue  0x4 = yellow, 0x5 = black)
	case Var39					= 0x39
	case Unused3A				= 0x3A
	case Unused3B				= 0x3B
	case Unused3C				= 0x3C
	case Special3D				= 0x3D
	case Unused3E				= 0x3E
	case Unused3F				= 0x3F
	case Unused40				= 0x40
	case Special41				= 0x41
	case Special42				= 0x42
	case Special43				= 0x43
	case Special44				= 0x44
	case Special45				= 0x45
	case Special46				= 0x46
	case Special47				= 0x47
	case Unused48				= 0x48
	case Special49				= 0x49
	case Unused4A				= 0x4A
	case Special4B				= 0x4B
	case Special4C				= 0x4C
	case Special4D				= 0x4D
	case VarPokemon4E			= 0x4E
	case Unused4F				= 0x4F
	case Special50				= 0x50
	case Unused51				= 0x51
	case Unused52				= 0x52 // Apparently 2 bytes but not used in any US tables afaik)
	case Special53				= 0x53 // 2 bytes.
	case Unused54				= 0x54
	case Special55				= 0x55
	case Special56				= 0x56
	case Special57				= 0x57
	case Special58				= 0x58
	case Speaker				= 0x59
	case Unused5A				= 0x5A
	case Special5B				= 0x5B // 2 bytes
	case Special5C				= 0x5C // 2 bytes
	case Special5D				= 0x5D
	case Special5E				= 0x5E
	case Special5F				= 0x5F
	case Unused60				= 0x60
	case Special61				= 0x61
	case Special62				= 0x62
	case Unused63				= 0x63
	case Special64				= 0x64
	case Special65				= 0x65
	case Unused66				= 0x66
	case Special67				= 0x67
	case Unused68				= 0x68
	case Special69				= 0x69
	case SetSpeaker				= 0x6A
	case Unused6B				= 0x6B
	case Unused6C				= 0x6C
	case Special6D				= 0x6D
	case Special6E				= 0x6E
	
	
	var byteStream : [UInt8] {
		get {
			return [UInt8(0xFF), UInt8(0xFF), UInt8(self.rawValue)]
		}
	}
	
	var extraBytes : Int {
		get {
			let val = self.rawValue
			
			for var i = 0; i < k2ByteChars.count; i++ {
				if val == k2ByteChars[i] {
					return 0x01
				}
			}
			for var j = 0; j < k5ByteChars.count; j++ {
				if val == k5ByteChars[j] {
					return 0x04
				}
			}
			
			return 0x00
			
		}
	}
	
	var string : String {
		get {
			var str = "["
			var mid = ""
			switch self {
				case .ChangeColourPredefined	: mid = kChangeColourP
				case .ChangeColourSpecified		: mid = kChangeColourS
				case .ClearWindow				: mid = kClearWindow
				case .DialogueEnd				: mid = kDialogueEnd
				case .NewLine					: mid = kNewLine
				case .Pause						: mid = kPause
				case .KanjiStart				: mid = kKanjiStart
				case .FuriganaStart				: mid = kFuriganaStart
				case .FuriganaEnd				: mid = kFuriganaEnd
				case .Player13					: mid = kBattlePlayer
				case .PlayerInField				: mid = kFieldPlayer
				case .Speaker					: mid = kSpeaker
				case .SetSpeaker				: mid = kSetSpeaker
				default							: mid = String(format: "%02x", self.rawValue)
			}
			str = str.stringByAppendingString(mid)
			str = str.stringByAppendingString("]")
			return str
		}
	}
	
	static func fromString(str : String) -> XGSpecialCharacters {
		switch str {
			case kChangeColourP		: return .ChangeColourPredefined
			case kChangeColourS		: return .ChangeColourSpecified
			case kClearWindow		: return .ClearWindow
			case kDialogueEnd		: return .DialogueEnd
			case kNewLine			: return .NewLine
			case kPause				: return .Pause
			case kKanjiStart		: return .KanjiStart
			case kFuriganaStart		: return .FuriganaStart
			case kFuriganaEnd		: return .FuriganaEnd
			case kBattlePlayer		: return .Player13
			case kFieldPlayer		: return .PlayerInField
			case kSpeaker			: return .Speaker
			case kSetSpeaker		: return .SetSpeaker
			default					: return XGSpecialCharacters(rawValue: hexStringToInt(str) ) ?? .Unused0A
		}
	}
	
	static func hexStringToInt(hex: String) -> Int {
		
		return Int(strtoul(hex, nil, 16)) // converts hex string to uint and then cast as Int
		
	}

}






















