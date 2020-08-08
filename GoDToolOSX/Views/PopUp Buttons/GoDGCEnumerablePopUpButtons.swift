//
//  GoDGCEnumerablePopUpButtons.swift
//  GoD Tool
//
//  Created by Stars Momodu on 21/02/2020.
//

import Foundation

class GoDPocketPopUpButton: GoDPopUpButton, GoDEnumerableButton {
    typealias Element = XGBagSlots
    lazy var allValues = Element.allValues
	override func setUpItems() {
		setUpEnumerableItems()
	}
}
class GoDDirectionPopUpButton: GoDPopUpButton, GoDEnumerableButton {
    typealias Element = XGElevatorDirections
    lazy var allValues = Element.allValues
	override func setUpItems() {
		setUpEnumerableItems()
	}
}
class GoDTrainerClassPopUpButton: GoDPopUpButton, GoDEnumerableButton {
    typealias Element = XGTrainerClasses
    lazy var allValues = Element.allValues
	override func setUpItems() {
		setUpEnumerableItems()
	}
}
class GoDTrainerModelPopUpButton: GoDPopUpButton, GoDEnumerableButton {
    typealias Element = XGTrainerModels
    lazy var allValues = Element.allValues
	override func setUpItems() {
		setUpEnumerableItems()
	}
}
class GoDBattleTypePopUpButton: GoDPopUpButton, GoDEnumerableButton {
    typealias Element = XGBattleTypes
    lazy var allValues = Element.allValues
	override func setUpItems() {
		setUpEnumerableItems()
	}
}
