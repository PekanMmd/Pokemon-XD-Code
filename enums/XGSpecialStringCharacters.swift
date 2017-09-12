//
//  XGSpecialStringCharacters.swift
//  XG Tool
//
//  Created by StarsMmd on 22/05/2015.
//  Copyright (c) 2015 StarsMmd. All rights reserved.
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
let kFoeTrainerClass = "Foe Tr Class"
let kFoeTrainerName	= "Foe Tr Name"
let kWaitKeyPress	= "Wait Input"


enum XGSpecialCharacters : Int {
	
	case newLine				= 0x00
	case special01				= 0x01
	case dialogueEnd			= 0x02
	case clearWindow			= 0x03
	case kanjiStart				= 0x04
	case furiganaStart			= 0x05
	case furiganaEnd			= 0x06
	case changeFont				= 0x07 // 2bytes (according to made_s this changes font. Do experiment
	case changeColourSpecified	= 0x08 // 5bytes (rgba)
	case pause					= 0x09 // 2 bytes (second byte determines duration, likely in tenths of a second)
	case unused0A				= 0x0A
	case special0B				= 0x0B
	case special0C				= 0x0C
	case var0D					= 0x0D
	case var0E					= 0x0E
	case varPokemon0F			= 0x0F
	case varPokemon10			= 0x10
	case varPokemon11			= 0x11
	case varPokemon12			= 0x12
	case player13				= 0x13 // Used in battle
	case sentOutPokemon1		= 0x14
	case sentOutPokemon2		= 0x15
	case varPokemon16			= 0x16
	case varPokemon17			= 0x17
	case varPokemon18			= 0x18
	case varPokemon19			= 0x19
	case varAbility1A			= 0x1A
	case varAbility1B			= 0x1B
	case varAbility1C			= 0x1C
	case varAbility1D			= 0x1D
	case varPokemon1E			= 0x1E
	case special1F				= 0x1F
	case varPokemon20			= 0x20
	case varPokemon21			= 0x21
	case foeTrainerClass		= 0x22
	case foeTrainerName			= 0x23
	case special24				= 0x24
	case varFoe25				= 0x25
	case varFoe26				= 0x26
	case varFoe27				= 0x27
	case varMove28				= 0x28
	case varItem29				= 0x29
	case unused2A				= 0x2A
	case playerInField			= 0x2B
	case rui					= 0x2C // Colosseum only
	case varItem2D				= 0x2D
	case varItem2E				= 0x2E
	case varQuantity			= 0x2F
	case var30					= 0x30
	case var31					= 0x31
	case var32					= 0x32
	case var33					= 0x33
	case var34					= 0x34
	case var35					= 0x35
	case var36					= 0x36
	case var37					= 0x37
	case changeColourPredefined	= 0x38 // 2 bytes (0x0 = white, 0x1 = yellow, 0x2 = green, 0x3 = blue  0x4 = yellow, 0x5 = black)
	case var39					= 0x39
	case unused3A				= 0x3A
	case unused3B				= 0x3B
	case unused3C				= 0x3C
	case special3D				= 0x3D
	case unused3E				= 0x3E
	case unused3F				= 0x3F
	case unused40				= 0x40
	case special41				= 0x41
	case special42				= 0x42
	case special43				= 0x43
	case special44				= 0x44
	case special45				= 0x45
	case special46				= 0x46
	case special47				= 0x47
	case unused48				= 0x48
	case special49				= 0x49
	case unused4A				= 0x4A
	case special4B				= 0x4B
	case special4C				= 0x4C
	case special4D				= 0x4D
	case varPokemon4E			= 0x4E
	case unused4F				= 0x4F
	case special50				= 0x50
	case unused51				= 0x51
	case unused52				= 0x52 // Apparently 2 bytes but not used in any US tables afaik)
	case special53				= 0x53 // 2 bytes.
	case unused54				= 0x54
	case special55				= 0x55
	case special56				= 0x56
	case special57				= 0x57
	case special58				= 0x58
	case speaker				= 0x59
	case unused5A				= 0x5A
	case special5B				= 0x5B // 2 bytes
	case special5C				= 0x5C // 2 bytes
	case special5D				= 0x5D
	case special5E				= 0x5E
	case special5F				= 0x5F
	case unused60				= 0x60
	case special61				= 0x61
	case special62				= 0x62
	case unused63				= 0x63
	case special64				= 0x64
	case special65				= 0x65
	case unused66				= 0x66
	case special67				= 0x67
	case unused68				= 0x68
	case special69				= 0x69
	case setSpeaker				= 0x6A
	case unused6B				= 0x6B
	case unused6C				= 0x6C
	case WaitKeyPress			= 0x6D // Dialog box won't disappear until a key is pressed. Typically used in battle.
	case special6E				= 0x6E
	
	
	var byteStream : [UInt8] {
		get {
			return [UInt8(0xFF), UInt8(0xFF), UInt8(self.rawValue)]
		}
	}
	
	var extraBytes : Int {
		get {
			let val = self.rawValue
			
			for i in 0 ..< k2ByteChars.count {
				if val == k2ByteChars[i] {
					return 0x01
				}
			}
			for j in 0 ..< k5ByteChars.count {
				if val == k5ByteChars[j] {
					return 0x04
				}
			}
			
			return 0x00
			
		}
	}
	
	var unicode : XGUnicodeCharacters {
		get {
			return .special(self, [Int](repeating: 0, count: self.extraBytes))
		}
	}
	
	var string : String {
		get {
			var str = "["
			var mid = ""
			switch self {
				case .changeColourPredefined	: mid = kChangeColourP
				case .changeColourSpecified		: mid = kChangeColourS
				case .clearWindow				: mid = kClearWindow
				case .dialogueEnd				: mid = kDialogueEnd
				case .newLine					: mid = kNewLine
				case .pause						: mid = kPause
				case .kanjiStart				: mid = kKanjiStart
				case .furiganaStart				: mid = kFuriganaStart
				case .furiganaEnd				: mid = kFuriganaEnd
				case .player13					: mid = kBattlePlayer
				case .playerInField				: mid = kFieldPlayer
				case .speaker					: mid = kSpeaker
				case .setSpeaker				: mid = kSetSpeaker
				case .foeTrainerClass			: mid = kFoeTrainerClass
				case .foeTrainerName			: mid = kFoeTrainerName
				case .WaitKeyPress				: mid = kWaitKeyPress
				default							: mid = String(format: "%02x", self.rawValue)
			}
			str = str + mid
			str = str + "]"
			return str
		}
	}
	
	static func fromString(_ str : String) -> XGSpecialCharacters {
		switch str {
			case kChangeColourP		: return .changeColourPredefined
			case kChangeColourS		: return .changeColourSpecified
			case kClearWindow		: return .clearWindow
			case kDialogueEnd		: return .dialogueEnd
			case kNewLine			: return .newLine
			case kPause				: return .pause
			case kKanjiStart		: return .kanjiStart
			case kFuriganaStart		: return .furiganaStart
			case kFuriganaEnd		: return .furiganaEnd
			case kBattlePlayer		: return .player13
			case kFieldPlayer		: return .playerInField
			case kSpeaker			: return .speaker
			case kSetSpeaker		: return .setSpeaker
			case kFoeTrainerClass	: return .foeTrainerClass
			case kFoeTrainerName	: return .foeTrainerName
			case kWaitKeyPress		: return .WaitKeyPress
			default					: return XGSpecialCharacters(rawValue: hexStringToInt(str) ) ?? .unused0A
		}
	}
	
	static func hexStringToInt(_ hex: String) -> Int {
		
		return Int(strtoul(hex, nil, 16)) // converts hex string to uint and then cast as Int
		
	}

}






















