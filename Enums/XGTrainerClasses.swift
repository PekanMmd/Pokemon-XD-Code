//
//  XGTrainerClasses.swift
//  XG Tool
//
//  Created by The Steez on 31/05/2015.
//  Copyright (c) 2015 Ovation International. All rights reserved.
//

import Foundation

let kFirstTrainerClassStringID = 0x1B59

enum XGTrainerClasses : Int {
	
	
	case None			= 0x00
	case Michael1		= 0x01
	case Michael2		= 0x02 // Unconfirmed
	case Michael3		= 0x03 // Unconfirmed
	case GrandMaster	= 0x04
	case MysteryMan		= 0x05
	case CipherAdmin	= 0x06
	case Thug			= 0x07
	case Recruit		= 0x08
	case SnagemHead		= 0x09
	case RoboGroudon	= 0x0A
	case Wanderer		= 0x0B
	case MythTrainer	= 0x0C
	case PreGymLeader	= 0x0D
	case KaminkoAide	= 0x0E
	case Rogue			= 0x0F
	case Spy			= 0x10
	case CipherPeon		= 0x11
	case SuperTrainer	= 0x12
	case AreaLeader		= 0x13
	case CoolTrainer	= 0x14
	case FunOldMan		= 0x15
	case Curdmudgeon	= 0x16
	case Matron			= 0x17
	case CasualGuy		= 0x18
	case TeamSnagem		= 0x19
	case Chaser			= 0x1A
	case Hunter			= 0x1B
	case Rider			= 0x1C
	case Worker			= 0x1D
	case Researcher		= 0x1E
	case Navigator		= 0x1F
	case Sailor			= 0x20
	case CasualDude		= 0x21
	case Beauty			= 0x22
	case BodyBuilder	= 0x23
	case TrendyGuy		= 0x24
	case MtBattleMaster	= 0x25
	case NewsCaster		= 0x26
	case SimTrainer		= 0x27
	case CipherCMDR		= 0x28
	case CipherRAndD	= 0x29
	case CipherAdmin2	= 0x2A
	case Spy2			= 0x2B
	case CipherPeon2	= 0x2C
	case SuperTrainer2	= 0x2D
	case AreaLeader2	= 0x2E
	case CoolTrainer2	= 0x2F
	case Chaser2		= 0x30
	case BodyBuilder2	= 0x31
	case SimTrainer2	= 0x32
	
	var nameID : Int {
		get {
			return XGTrainerClass(tClass: self).nameID
		}
	}
	
	var name : String {
		get {
			return XGTrainerClass(tClass: self).name
		}
	}
	
}
















