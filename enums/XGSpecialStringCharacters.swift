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

let kBold 				= "Bold"
let kNewLine			= "New Line"
let kDialogueEnd		= "Dialogue End"
let kClearWindow		= "Clear Window"
let kKanjiStart			= "Kanji"
let kFuriganaStart		= "Furigana"
let kFuriganaEnd		= "Furigana End"
let kChangeColourP		= "Predef Colour"
let kChangeColourS		= "Spec Colour"
let kPause				= "Pause"
let kBattlePlayer		= "Player B"
let kFieldPlayer		= "Player F"
let kSpeaker			= "Speaker"
let kSetSpeaker			= "Set Speaker"
let kFoeTrainerClass	= "Foe Tr Class"
let kFoeTrainerName		= "Foe Tr Name"
let kWaitKeyPress		= "Wait Input"
let kSpeciesCry			= "Pokemon Cry"
let kspecialMSG			= "MsgID"
let kvarPokemon4E		= "Pokemon 0x4E"
let kvarItem2D			= "Item 0x2D"
let kvarItem2E			= "Item 0x2E"
let kvarQuantity		= "Quantity 0x2F"
let kvarMove28			= "Move 0x28"
let kvarItem29			= "Item 0x29"
let kvarPokemon20		= "Pokemon 0x20"
let kvarPokemon21		= "Pokemon 0x21"
let kvarPokemon0F		= "Pokemon 0x0F"
let kvarPokemon10		= "Pokemon 0x10"
let kvarPokemon11		= "Pokemon 0x11"
let kvarPokemon12		= "Pokemon 0x12"
let ksentOutPokemon1	= "Switch Pokemon 0x14"
let ksentOutPokemon2	= "Switch Pokemon 0x15"
let kvarPokemon16		= "Pokemon 0x16"
let kvarPokemon17		= "Pokemon 0x17"
let kvarPokemon18		= "Pokemon 0x18"
let kvarPokemon19		= "Pokemon 0x19"
let kvarAbility1A		= "Ability 0x1A"
let kvarAbility1B		= "Ability 0x1B"
let kvarAbility1C		= "Ability 0x1C"
let kvarAbility1D		= "Ability 0x1D"
let kvarPokemon1E		= "Pokemon 0x1E"


enum XGSpecialCharacters : Int {
	
	case newLine				= 0x00
	case special01				= 0x01
	case dialogueEnd			= 0x02
	case clearWindow			= 0x03
	case kanjiStart				= 0x04
	case furiganaStart			= 0x05
	case furiganaEnd			= 0x06
	case changeFont				= 0x07 // 2bytes // 1=bold
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
	case specialMSG				= 0x4D // loads another .msg string as the variable
	case varPokemon4E			= 0x4E
	case unused4F				= 0x4F
	case pokemonSpeciesCry		= 0x50 // set var to a species to play it's cry as audio
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

	var isNewLine: Bool {
		rawValue == XGSpecialCharacters.newLine.rawValue
	}

	var string : String {
		get {
			if isNewLine {
				return "\n"
			}
			
			var str = "["
			var mid = ""
			switch self {
				case .changeColourPredefined	: mid = kChangeColourP
				case .changeColourSpecified	: mid = kChangeColourS
				case .clearWindow					: mid = kClearWindow
				case .dialogueEnd					: mid = kDialogueEnd
				case .newLine						: mid = kNewLine
				case .pause							: mid = kPause
				case .kanjiStart						: mid = kKanjiStart
				case .furiganaStart					: mid = kFuriganaStart
				case .furiganaEnd					: mid = kFuriganaEnd
				case .player13						: mid = kBattlePlayer
				case .playerInField					: mid = kFieldPlayer
				case .speaker							: mid = kSpeaker
				case .setSpeaker					: mid = kSetSpeaker
				case .foeTrainerClass				: mid = kFoeTrainerClass
				case .foeTrainerName				: mid = kFoeTrainerName
				case .WaitKeyPress					: mid = kWaitKeyPress
				case .pokemonSpeciesCry		: mid = kSpeciesCry
				case .specialMSG					: mid = kspecialMSG
				case .varPokemon4E				: mid = kvarPokemon4E
				case .varItem2D						: mid = kvarItem2D
				case .varItem2E						: mid = kvarItem2E
				case .varQuantity					: mid = kvarQuantity
				case .varMove28					: mid = kvarMove28
				case .varItem29						: mid = kvarItem29
				case .varPokemon20				: mid = kvarPokemon20
				case .varPokemon21				: mid = kvarPokemon21
				case .varPokemon0F				: mid = kvarPokemon0F
				case .varPokemon10				: mid = kvarPokemon10
				case .varPokemon11				: mid = kvarPokemon11
				case .varPokemon12				: mid = kvarPokemon12
				case .sentOutPokemon1			: mid = ksentOutPokemon1
				case .sentOutPokemon2			: mid = ksentOutPokemon2
				case .varPokemon16				: mid = kvarPokemon16
				case .varPokemon17				: mid = kvarPokemon17
				case .varPokemon18				: mid = kvarPokemon18
				case .varPokemon19				: mid = kvarPokemon19
				case .varAbility1A					: mid = kvarAbility1A
				case .varAbility1B					: mid = kvarAbility1B
				case .varAbility1C					: mid = kvarAbility1C
				case .varAbility1D					: mid = kvarAbility1D
				case .varPokemon1E				: mid = kvarPokemon1E
				default									: mid = String(format: "%02x", self.rawValue)
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
			case kSpeciesCry		: return .pokemonSpeciesCry
		    case kspecialMSG		: return .specialMSG
		    case kvarPokemon4E		: return .varPokemon4E
		    case kvarItem2D			: return .varItem2D
		    case kvarItem2E			: return .varItem2E
		    case kvarQuantity		: return .varQuantity
		    case kvarMove28			: return .varMove28
		    case kvarItem29			: return .varItem29
		    case kvarPokemon20		: return .varPokemon20
		    case kvarPokemon21		: return .varPokemon21
		    case kvarPokemon0F		: return .varPokemon0F
		    case kvarPokemon10		: return .varPokemon10
		    case kvarPokemon11		: return .varPokemon11
		    case kvarPokemon12		: return .varPokemon12
		    case ksentOutPokemon1	: return .sentOutPokemon1
		    case ksentOutPokemon2	: return .sentOutPokemon2
		    case kvarPokemon16		: return .varPokemon16
		    case kvarPokemon17		: return .varPokemon17
		    case kvarPokemon18		: return .varPokemon18
		    case kvarPokemon19		: return .varPokemon19
		    case kvarAbility1A		: return .varAbility1A
		    case kvarAbility1B		: return .varAbility1B
		    case kvarAbility1C		: return .varAbility1C
		    case kvarAbility1D		: return .varAbility1D
			case kvarPokemon1E		: return .varPokemon1E
			case kBold						: return .changeFont
			default					: return XGSpecialCharacters(rawValue: str.hexStringToInt() ) ?? .unused0A
		}
	}

	static var generalFormattingChars: [XGSpecialCharacters] {
		[] // for PBR compatibility
	}

}






















