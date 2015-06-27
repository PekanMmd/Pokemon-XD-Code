//
//  XGPokemon.swift
//  XG Tool
//
//  Created by The Steez on 01/06/2015.
//  Copyright (c) 2015 Ovation International. All rights reserved.
//

import UIKit

enum XGPokemon {
	
	case Pokemon(Int)
	
	var index : Int {
		get {
			switch self {
			case .Pokemon(let i): return i
			}
		}
	}
	
	var startOffset : Int {
		get{
			return kFirstPokemonOffset + (index * kSizeOfPokemonStats)
		}
	}
	
	var nameID : Int {
		get {
			return XGFiles.Common_rel.data.get2BytesAtOffset(startOffset + kNameIDOffset)
		}
	}
	
	var name : XGString {
		get {
			var table = XGStringTable.common_rel()
			return table.stringSafelyWithID(nameID)
		}
	}
	
	var face : UIImage {
		get {
			var face = XGFiles.Common_rel.data.get2BytesAtOffset(startOffset + kPokemonFaceIndexOffset)
			return XGFiles.PokeFace(face).image
		}
	}
	
	var body : UIImage {
		get {
			var body = XGFiles.Common_rel.data.get2BytesAtOffset(startOffset + kPokemonModelIndexOffset)
			return XGFiles.PokeBody(body).image
		}
	}
	
	var ability1 : String {
		get {
			var a1 = XGFiles.Common_rel.data.getByteAtOffset(startOffset + kAbility1Offset)
			return XGAbilities.Ability(a1).name.string
		}
	}
	var ability2 : String {
		get {
			var a2 = XGFiles.Common_rel.data.getByteAtOffset(startOffset + kAbility2Offset)
			return XGAbilities.Ability(a2).name.string
		}
	}
	
	var type1 : XGMoveTypes {
		get {
			var type = XGFiles.Common_rel.data.getByteAtOffset(startOffset + kType1Offset)
			return XGMoveTypes(rawValue: type) ?? XGMoveTypes.Normal
		}
	}
	
	var type2 : XGMoveTypes {
		get {
			var type = XGFiles.Common_rel.data.getByteAtOffset(startOffset + kType2Offset)
			return XGMoveTypes(rawValue: type) ?? XGMoveTypes.Normal
		}
	}
	
}


enum XGOriginalPokemon {
	
	case Pokemon(Int)
	
	var index : Int {
		get {
			switch self {
				case .Pokemon(let i): return i
			}
		}
	}
	
	var startOffset : Int {
		get{
			return kFirstPokemonOffset + (index * kSizeOfPokemonStats)
		}
	}
	
	var nameID : Int {
		get {
			return XGResources.FDAT("common_rel").data.get2BytesAtOffset(startOffset + kNameIDOffset)
		}
	}
	
	var name : String {
		get {
			var table = XGStringTable.common_relOriginal()
			return table.stringSafelyWithID(nameID).string
		}
	}
	
	var type1 : XGMoveTypes {
		get {
			var type = XGResources.FDAT("common_rel").data.getByteAtOffset(startOffset + kType1Offset)
			return XGMoveTypes(rawValue: type) ?? XGMoveTypes.Normal
		}
	}
	
	var type2 : XGMoveTypes {
		get {
			var type = XGResources.FDAT("common_rel").data.getByteAtOffset(startOffset + kType2Offset)
			return XGMoveTypes(rawValue: type) ?? XGMoveTypes.Normal
		}
	}
	
}














