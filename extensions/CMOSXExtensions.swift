//
//  CMOSXExtensions.swift
//  GoD Tool
//
//  Created by The Steez on 27/08/2018.
//

import Foundation

let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + "/Colosseum Tool"
let game = XGGame.Colosseum
let region = XGRegions(rawValue: XGFiles.iso.data!.getWordAtOffset(0)) ?? .US
let isDemo = false

typealias TrainerInfo = (fullname:String,name:String,location:String,hasShadow: Bool,trainerModel:XGTrainerModels,index:Int, deck: XGDecks)
extension XGTrainer {
	var trainerInfo: TrainerInfo {
		return (self.trainerClass.name.string + " " + self.name.unformattedString, self.name.unformattedString,"",self.hasShadow,self.trainerModel,self.index, .DeckStory)
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
		return ISO.allFileNames
			.filter{$0.fileExtensions == XGFileTypes.fsys.fileExtension}
			.map{XGFiles.fsys($0.removeFileExtensions())}
			.filter{$0.exists}
			.map{$0.fsysData}
	}
}
