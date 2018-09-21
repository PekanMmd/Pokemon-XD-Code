//
//  CMTrainerClasses.swift
//  Colosseum Tool
//
//  Created by The Steez on 04/06/2018.
//

import Foundation

let kFirstTrainerClassStringID = 0x1B59

enum XGTrainerClasses : Int {
	
	case none			= 0x00
	case none2
	case none3
	case none4
	case cipherAdmin
	case cipher
	case cipherHead
	case mythTrainer
	case mtBtlMaster
	case richBoy
	case lady
	case glassesMan
	case ladyInSuit
	case guy
	case teacher
	case funOldMan
	case funOldLady
	case athlete
	case coolTrainer
	case preGymLeader
	case areaLeader
	case superTrainer
	case worker
	case snagemHead
	case mirorBPeon
	case hunter
	case rider
	case rollerBoy
	case stPerformer
	case bandanaGuy
	case chaser
	case researcher
	case bodyBuilder
	case deepKing
	case newsCaster
	case teamSnagem
	case cipherPeon
	case mysteryTroop
	case vrTrainer
	case shadyGuy
	case rogue
	case none5
	case none6
	
	var nameID : Int {
		get {
			return XGTrainerClass(tClass: self).nameID
		}
	}
	
	var name : XGString {
		get {
			return XGTrainerClass(tClass: self).name
		}
	}
	
	var payout : Int {
		get {
			return XGTrainerClass(tClass: self).payout
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
