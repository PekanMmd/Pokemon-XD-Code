//
//  GoDMoveEffectTypePopUpButton.swift
//  GoDToolOSX
//
//  Created by The Steez on 06/05/2018.
//

import Foundation


class GoDMoveEffectTypesPopUpButton: GoDPopUpButton {
	
	var selectedValue : XGMoveEffectTypes {
		return XGMoveEffectTypes(rawValue: self.indexOfSelectedItem) ?? .none
	}
	
	func selectType(type: XGMoveEffectTypes) {
		self.selectItem(withTitle: type.string)
	}
	
	override func setUpItems() {
		var values = [String]()
		
		for i in 0 ... XGMoveEffectTypes.unknown.rawValue {
			values.append(XGMoveEffectTypes(rawValue: i)!.string)
		}
		
		self.setTitles(values: values)
	}
	
}
