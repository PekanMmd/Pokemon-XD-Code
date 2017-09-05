//
//  XGFiles + image.swift
//  GoD Tool
//
//  Created by The Steez on 20/08/2017.
//
//

import UIKit

extension XGFiles {
		var image : UIImage {
			get {
				return UIImage(contentsOfFile: self.path)!
			}
		}
}

extension XGTrainerModels {
		var image : UIImage {
	
			return XGFiles.trainerFace(self.rawValue).image
	
		}
}

extension XGPokemon {
		var face : UIImage {
			get {
				return XGFiles.pokeFace(self.index).image
			}
		}
	
		var body : UIImage {
			get {
				return XGFiles.pokeBody(self.index).image
			}
		}
}

extension XGMoveTypes {
		var image : UIImage {
			get {
				return XGFiles.typeImage(self.rawValue).image
			}
		}
}

extension XGResources {
	var image : UIImage {
		get {
			return UIImage(contentsOfFile: self.path) ?? UIImage()
		}
	}
}
