//
//  XGTrainerClasses.swift
//  XG Tool
//
//  Created by StarsMmd on 31/05/2015.
//  Copyright (c) 2015 StarsMmd. All rights reserved.
//

import Foundation

let kFirstTrainerClassStringID = 0x1B59

enum XGTrainerClasses : Int, XGDictionaryRepresentable {
	
	
	case none			= 0x00
	case michael1		= 0x01
	case michael2		= 0x02 // Unconfirmed
	case michael3		= 0x03 // Unconfirmed
	case grandMaster	= 0x04
	case mysteryMan		= 0x05
	case cipherAdmin	= 0x06
	case thug			= 0x07
	case recruit		= 0x08
	case snagemHead		= 0x09
	case roboGroudon	= 0x0A
	case wanderer		= 0x0B
	case mythTrainer	= 0x0C
	case preGymLeader	= 0x0D
	case kaminkoAide	= 0x0E
	case rogue			= 0x0F
	case spy			= 0x10
	case cipherPeon		= 0x11
	case superTrainer	= 0x12
	case areaLeader		= 0x13
	case coolTrainer	= 0x14
	case funOldMan		= 0x15
	case curdmudgeon	= 0x16
	case matron			= 0x17
	case casualGuy		= 0x18
	case teamSnagem		= 0x19
	case chaser			= 0x1A
	case hunter			= 0x1B
	case rider			= 0x1C
	case worker			= 0x1D
	case researcher		= 0x1E
	case navigator		= 0x1F
	case sailor			= 0x20
	case casualDude		= 0x21
	case beauty			= 0x22
	case bodyBuilder	= 0x23
	case trendyGuy		= 0x24
	case mtBattleMaster	= 0x25
	case newsCaster		= 0x26
	case simTrainer		= 0x27
	case cipherCMDR		= 0x28
	case cipherRAndD	= 0x29
	case cipherAdmin2	= 0x2A
	case spy2			= 0x2B
	case cipherPeon2	= 0x2C
	case superTrainer2	= 0x2D
	case areaLeader2	= 0x2E
	case coolTrainer2	= 0x2F
	case chaser2		= 0x30
	case bodyBuilder2	= 0x31
	case simTrainer2	= 0x32
	
	var data : XGTrainerClass {
		get {
			return XGTrainerClass(index: self.rawValue)
		}
	}
	
	var nameID : Int {
		get {
			return data.nameID
		}
	}
	
	var name : XGString {
		get {
			return data.name
		}
	}
	
	var payout : Int {
		get {
			return data.payout
		}
	}
	
	var dictionaryRepresentation: [String : AnyObject] {
		get {
			return ["Value" : self.rawValue as AnyObject]
		}
	}
	
	var readableDictionaryRepresentation: [String : AnyObject] {
		get {
			return ["Value" : self.name.string as AnyObject]
		}
	}
	
}
















