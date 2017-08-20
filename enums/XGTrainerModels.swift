//
//  XGTrainerModels.swift
//  XG Tool
//
//  Created by The Steez on 31/05/2015.
//  Copyright (c) 2015 Ovation International. All rights reserved.
//

import Foundation

let kNumberOfTrainerModels = 0x44

enum XGTrainerModels : Int, XGDictionaryRepresentable {
	
	case none						= 0x00
	
	case michael1WithoutSnagMachine	= 0x01
	case michael2WithSnagMachine	= 0x02
	case michael2WithoutSnagMachine	= 0x03
	
	case mayEM						= 0x04
	case brendanEM					= 0x05
	case green						= 0x06
	case red						= 0x07
	case mayRS						= 0x08
	case brendanRS					= 0x09
	
	case noTrainer					= 0x0A
	
	case cipherPeonFemale			= 0x0B
	case cipherPeonMale1			= 0x0C
	case cipherPeonMale2			= 0x0D
	case cipherPeonMale3			= 0x0E
	case resix						= 0x0F
	case blusix						= 0x10
	case browsix					= 0x11
	case yellosix					= 0x12
	case purpsix					= 0x13
	case greesix					= 0x14
	case lovrina					= 0x15
	
	case sailor						= 0x16
	case zook						= 0x17
	case ardos						= 0x18
	case matron						= 0x19
	case greevil					= 0x1A
	case newscaster					= 0x1B
	case eldes						= 0x1C
	case gorigan					= 0x1D
	case gonzap						= 0x1E
	
	case superTrainerFemale1		= 0x1F
	case superTrainerFemale2		= 0x20
	case vander						= 0x21
	case superTrainerMale2			= 0x22
	case superTrainerMale3			= 0x23
	
	case hunter						= 0x24
	case beauty						= 0x25
	case casualDude					= 0x26
	case funOldMan					= 0x27
	case curmudgeon					= 0x28
	case eagun						= 0x29
	case roboGroudon				= 0x2A
	case mirorB						= 0x2B
	case bodyBuilderFemale			= 0x2C
	case bodyBuilderMale			= 0x2D
	case battlus					= 0x2E
	
	case casualGuy					= 0x2F
	case researcher					= 0x30
	case rider						= 0x31
	case navigator					= 0x32
	case justy						= 0x33
	case snagemGrunt1				= 0x34
	case snagemGrunt2				= 0x35
	case chobin						= 0x36
	
	case chaserFemale1				= 0x37
	case chaserFemale2				= 0x38
	case chaseMale					= 0x39
	case cail						= 0x3A
	case coolTrainerFemale			= 0x3B
	case coolTrainerMale			= 0x3C
	case snattle					= 0x3D
	case willie						= 0x3E
	case worker						= 0x3F
	case krane						= 0x40
	
	case greevil2					= 0x41
	case michael3WithSnagMachine	= 0x42
	case michael3WithoutSnagMachine	= 0x43
	
	var name : String {
		get {
			switch self {
			case .none:
				return "None"
			case .michael1WithoutSnagMachine:
				return "Michael A without Snag Machine"
			case .michael2WithSnagMachine:
				return "Michael B with Snag Machine"
			case .michael2WithoutSnagMachine:
				return "Michael B without Snag Machine"
			case .mayEM:
				return "May (Emerald)"
			case .brendanEM:
				return "Brendan (Emerald)"
			case .green:
				return "Green"
			case .red:
				return "Red"
			case .mayRS:
				return "May (RS)"
			case .brendanRS:
				return "Brendan (RS)"
			case .noTrainer:
				return "No Trainer"
			case .cipherPeonFemale:
				return "Female Cipher Peon"
			case .cipherPeonMale1:
				return "Male Cipher Peon A"
			case .cipherPeonMale2:
				return "Male Cipher Peon B"
			case .cipherPeonMale3:
				return "Male Cipher Peon C"
			case .resix:
				return "Resix"
			case .blusix:
				return "Blusix"
			case .browsix:
				return "Browsix"
			case .yellosix:
				return "Yellosix"
			case .purpsix:
				return "Purpsix"
			case .greesix:
				return "Greesix"
			case .lovrina:
				return "Lovrina"
			case .sailor:
				return "Sailor"
			case .zook:
				return "Zook"
			case .ardos:
				return "Ardos"
			case .matron:
				return "Matron"
			case .greevil:
				return "Greevil A"
			case .newscaster:
				return "Newscaster"
			case .eldes:
				return "Eldes"
			case .gorigan:
				return "Gorigan"
			case .gonzap:
				return "Gonzap"
			case .superTrainerFemale1:
				return "Female Super Trainer A"
			case .superTrainerFemale2:
				return "Female Super Trainer B"
			case .vander:
				return "Vander"
			case .superTrainerMale2:
				return "Male Super Trainer A"
			case .superTrainerMale3:
				return "Male Super Trainer B"
			case .hunter:
				return "Hunter"
			case .beauty:
				return "Beauty"
			case .casualDude:
				return "Casual Dude"
			case .funOldMan:
				return "Fun Old Man"
			case .curmudgeon:
				return "Curmudgeon"
			case .eagun:
				return "Eagun"
			case .roboGroudon:
				return "Robo Groudon Chobin"
			case .mirorB:
				return "Miror B."
			case .bodyBuilderFemale:
				return "Female Body Builder"
			case .bodyBuilderMale:
				return "Male Body Builder"
			case .battlus:
				return "Battlus"
			case .casualGuy:
				return "Casual Guy"
			case .researcher:
				return "Researcher"
			case .rider:
				return "Rider"
			case .navigator:
				return "Navigator"
			case .justy:
				return "Justy"
			case .snagemGrunt1:
				return "Snagem A"
			case .snagemGrunt2:
				return "Snagem B"
			case .chobin:
				return "Chobin"
			case .chaserFemale1:
				return "Female Chaser A"
			case .chaserFemale2:
				return "Female Chaser B"
			case .chaseMale:
				return "Male Chaser"
			case .cail:
				return "Rogue Cail"
			case .coolTrainerFemale:
				return "Female Cool Trainer"
			case .coolTrainerMale:
				return "Male Cool Trainer"
			case .snattle:
				return "Snattle"
			case .willie:
				return "Willie"
			case .worker:
				return "Worker"
			case .krane:
				return "Prof. Krane taken hostage"
			case .greevil2:
				return "Greevil B"
			case .michael3WithSnagMachine:
				return "Michael C with Snag Machine"
			case .michael3WithoutSnagMachine:
				return "Michael C without Snag Machine"
			}
		}
	}
	
	
	var dictionaryRepresentation: [String : AnyObject] {
		get {
			return ["Value" : self.rawValue as AnyObject]
		}
	}
	
	var readableDictionaryRepresentation: [String : AnyObject] {
		get {
			return ["Value" : self.name as AnyObject]
		}
	}
	
	
}
















