//
//  Trainer.swift
//  Mausoleum Tool
//
//  Created by StarsMmd on 25/09/2014.
//  Copyright (c) 2014 Steezy. All rights reserved.
//

import Foundation

let kSizeOfTrainerData				= 0x98
let kNumberOfTrainerPokemon			= 0x06

class XGTrainer: NSObject, XGIndexedValue {

	var index				= 0x0
	var file: XGFiles!
	
	var nameID				= 0x0
	var pokemon				= [XGTrainerPokemon]()
	var trainerModel		= XGTrainerModels.none
	
	override var description : String {
		get {
			var s = ""
			
			s += "--------------------------\n"
			s += "\(self.index): \(self.name)\n"
			s += "--------------------------\n"
			for p in self.pokemon {
				s += "\(p.species.name)"
				s += "\n"
			}
			
			s += "--------------------------\n"
			
			return s
		}
	}
	
	var name: XGString {
		return getStringSafelyWithID(id: nameID)
	}
	
	init(index: Int, file: XGFiles) {
		super.init()
		
		self.index = index
		self.file  = file

		let deckTable = GoDDataTable.tableForFile(file)

		guard let entry = deckTable.entryWithIndex(index) else {
			printg("Failed to load deck data:", file.path, "\nindex:", index)
			return
		}

		nameID = entry.getShort(6)

	}
	
	func save() {
		
	}
   
}




























