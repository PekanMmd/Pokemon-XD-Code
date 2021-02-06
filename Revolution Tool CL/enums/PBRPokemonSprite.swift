//
//  PBRPokemonSprite.swift
//  Revolution Tool CL
//
//  Created by The Steez on 28/12/2018.
//

enum PBRPokemonImage : XGIndexedValue {
	
	case face(Int)
	case body(Int)
	
	var index : Int {
		switch self {
		// 0 is bulbasaur, alternate formes start after arceus.
		case .face(let i): return i
		case .body(let i): return i
		}
	}
	
	var entry : GoDDataTableEntry {
		GoDDataTableEntry.pokemonIcons(index: index)
	}
	
	var maleID : UInt32 {
		switch self {
		case .face: return entry.getWord(0)
		case .body: return entry.getWord(4)
		}
	}
	
	var femaleID: UInt32 {
		switch self {
		case .face: return entry.getWord(8)
		case .body: return entry.getWord(12)
		}
	}
	
	var maleTexture: XGImage {
		var fsys : XGFsys!
		switch self {
		case .face: fsys = XGFiles.fsys("menu_face").fsysData
		case .body: fsys = XGFiles.fsys("menu_pokemon").fsysData
		}
		guard let id = fsys.indexForIdentifier(identifier: maleID.int32) else {
			return XGImage.dummy
		}
		return fsys.extractDataForFileWithIndex(index: id)?.texture.image ?? .dummy
	}
	
	var femaleTexture : XGImage {
		var fsys : XGFsys!
		switch self {
		case .face: fsys = XGFiles.fsys("menu_face").fsysData
		case .body: fsys = XGFiles.fsys("menu_pokemon").fsysData
		}
		guard let id = fsys.indexForIdentifier(identifier: femaleID.int32) else {
			return XGImage.dummy
		}
		return fsys.extractDataForFileWithIndex(index: id)?.texture.image ?? .dummy
	}
	
}

enum PBRPokemonModel : XGIndexedValue {
	
	case regular(Int)
	case shiny(Int)
	
	var index : Int {
		switch self {
		// 1 is bulbasaur, alternate formes are directly after base form
		case .regular(let i): return i
		case .shiny(let i): return i
		}
	}
	
	private var entry : GoDDataTableEntry {
		return GoDDataTableEntry.pokemonModels(index: index)
	}
	
	var fsysFileIndex : Int {
		return entry.getShort(6)
	}
	
	var fileID : UInt32 {
		switch self {
		case .regular: return entry.getWord(8)
		case .shiny  : return entry.getWord(12)
		}
	}
	
	var speciesID : Int {
		return entry.getShort(20)
	}
}










