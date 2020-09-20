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
		return (self.trainerClass.name.unformattedString + " " + self.name.unformattedString, self.locationString,self.hasShadow,self.trainerModel,self.index,self.deck)
	}
}

extension XGFsys: XGEnumerable {
	var enumerableName: String {
		return path
	}
	
	var enumerableValue: String? {
		return nil
	}
	
	static var enumerableClassName: String {
		return "Fsys"
	}
	
	static var allValues: [XGFsys] {
		let files = XGFolders.AutoFSYS.files + XGFolders.MenuFSYS.files + XGFolders.FSYS.files
		return files.map { $0.fsysData }
	}
}








