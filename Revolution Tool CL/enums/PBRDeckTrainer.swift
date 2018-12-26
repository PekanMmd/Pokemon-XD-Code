//
//  XGDPKM.swift
//  XG Tool
//
//  Created by StarsMmd on 01/06/2015.
//  Copyright (c) 2015 StarsMmd. All rights reserved.
//

import Foundation

enum XGDeckTrainer : XGDictionaryRepresentable {
	
	case deck(Int, XGDecks)
	
	var index : Int {
		get {
			switch self {
			case .deck(let i, _) :
				return i
			}
		}
	}
	
	var startOffset : Int {
		switch self {
		case .deck:
			return XGDecks.headerSize + (index * kSizeOfTrainerData)
		}
	}
	
	var deck : XGDecks {
		get {
			switch self {
			case .deck(_, let d) :
				return d
			}
		}
	}
	
	var data : XGTrainer {
		get {
			return XGTrainer(deckData: self)
		}
	}
	
	var dictionaryRepresentation: [String : AnyObject] {
		get {
			return self.data.dictionaryRepresentation
		}
	}
	
	var readableDictionaryRepresentation: [String : AnyObject] {
		get {
			return self.data.readableDictionaryRepresentation
		}
	}
	
}





















