//
//  main.swift
//  Revolution Tool
//
//  Created by The Steez on 24/12/2018.
//

import Foundation

//for i in 0x1906 ... 0x191d {
//	getStringSafelyWithID(id: i).unformattedString.println()
//}
for i in [4] {
	let deck = XGDecks.dckp(i)
	
	let indices = 0 ..< deck.numberOfEntries
	let mons = indices.map { (index) -> XGTrainerPokemon  in
		return XGDeckPokemon.deck(index, deck).data
	}
	
	for mon in mons.sorted(by: { (p1, p2) -> Bool in
		p1.deckData.index < p2.deckData.index
	}) {
		mon.species.formeName.println()
		mon.ability.name.unformattedString.println()
		for move in mon.moves {
			move.name.unformattedString.println()
		}
		
		"".println()
	}
	
}


//getStringWithID(id: 0x1907)?.println()
//XGPokemon.pokemon(0x15f).name.unformattedString.println()

//XGUtility.extractAllFiles()

//let deck = XGDecks.dckp(10)
//for i in 0 ..< deck.numberOfEntries {
//	PBRDataTableEntry(index: i, deck: deck).data.byteStream.hexStream.println()
//}

//for m in [0xe6,0x113,0xd5, 0xbf] {
//	XGItems.item(m).name.unformattedString.println()
//}
//XGPokemon.pokemon(0x1a1).name.unformattedString.println()
//item("black belt").index.hexString().println()

//let castform = pokemon("castform").stats
//let id = castform.faces[0].femaleID
//let id : UInt32 = 0x27c70c00
//if let fsys = XGUtility.getFSYSForIdentifier(id: id) {
//	fsys.fileName.println()
//	let index = fsys.indexForIdentifier(identifier: id.int32)
//	index.string.println()
//	fsys.fullFileNameForFileWithIndex(index: index).println()
//}


