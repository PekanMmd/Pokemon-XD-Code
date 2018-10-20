//
//  CMOSXExtensions.swift
//  GoD Tool
//
//  Created by The Steez on 27/08/2018.
//

import Cocoa

let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + "/Colosseum-Tool"
let game = XGGame.Colosseum
let region = XGRegions(rawValue: XGFiles.iso.data.getWordAtOffset(0)) ?? .US

typealias TrainerInfo = (fullname:String,name:String,location:String,hasShadow: Bool,trainerModel:XGTrainerModels,index:Int, deck: XGDecks)
extension XGTrainer {
	var trainerInfo : TrainerInfo {
		return (self.trainerClass.name.string + " " + self.name.string, self.name.string,"",self.hasShadow,self.trainerModel,self.index, .DeckStory)
	}
}

