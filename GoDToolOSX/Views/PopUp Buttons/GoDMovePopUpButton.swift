//
//  GoDMovePopUpButton.swift
//  GoD Tool
//
//  Created by The Steez on 06/09/2017.
//
//

import Cocoa

let movesOrdered = XGMoves.allMoves().filter({ (m) -> Bool in
	return m.nameID > 0 || m.index == 0
}).sorted {
	if ($0.index == 0) {return true};
	if ($1.index == 0) {return false};
	if $0.isShadowMove {
		return $1.isShadowMove ? $0.name.string < $1.name.string : false
	};
	if $1.isShadowMove {
		return $0.isShadowMove ? $0.name.string < $1.name.string : true
	};
	if ($0.type == $1.type) {
		return $0.name.string < $1.name.string
	};
	return $0.type.rawValue < $1.type.rawValue
}

class GoDMovePopUpButton: GoDPopUpButton {
	
	var selectedValue : XGMoves {
		return movesOrdered[self.indexOfSelectedItem]
	}
	
	override func setUpItems() {
		let values = movesOrdered.map { (m) -> String in
			return m.name.string
		}
		
		self.addItems(withTitles: values)
	}
	
}
