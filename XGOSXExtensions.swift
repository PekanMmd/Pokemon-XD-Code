//
//  XGOSXExtensions.swift
//  GoD Tool
//
//  Created by StarsMmd on 20/08/2017.
//
//

import Cocoa

let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + "/GoD-Tool"
let region = XGRegions(rawValue: XGFiles.iso.data!.getWordAtOffset(0)) ?? .US
let game = XGGame.XD

typealias TrainerInfo = (name:String,location:String,hasShadow: Bool,trainerModel:XGTrainerModels,index:Int,deck:XGDecks)
extension XGTrainer {
	var trainerInfo : TrainerInfo {
		return (self.trainerClass.name.string + " " + self.name.string, self.locationString,self.hasShadow,self.trainerModel,self.index,self.deck)
	}
}










