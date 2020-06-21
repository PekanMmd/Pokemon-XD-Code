//
//  GoDGCEnumerablePopUpButtons.swift
//  GoD Tool
//
//  Created by Stars Momodu on 21/02/2020.
//

import Foundation

class GoDCategoryPopUpButton: GoDPopUpButton, GoDEnumerableButton {
    typealias Element = XGMoveCategories
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
class GoDEvolutionMethodPopUpButton: GoDPopUpButton, GoDEnumerableButton {
    typealias Element = XGEvolutionMethods
    lazy var allValues = Element.allValues
	override func setUpItems() {
		setUpEnumerableItems()
	}
}
class GoDItemPopUpButton: GoDPopUpButton, GoDEnumerableButton {
    typealias Element = XGItems
    lazy var allValues = Element.allValues
	override func setUpItems() {
		setUpEnumerableItems()
	}
}
class GoDMoveEffectTypesPopUpButton: GoDPopUpButton, GoDEnumerableButton {
    typealias Element = XGMoveEffectTypes
    lazy var allValues = Element.allValues
	override func setUpItems() {
		setUpEnumerableItems()
	}
}
class GoDPocketPopUpButton: GoDPopUpButton, GoDEnumerableButton {
    typealias Element = XGBagSlots
    lazy var allValues = Element.allValues
	override func setUpItems() {
		setUpEnumerableItems()
	}
}
class GoDPokemonPopUpButton: GoDPopUpButton, GoDEnumerableButton {
    typealias Element = XGPokemon
    lazy var allValues = Element.allValues
	override func setUpItems() {
		setUpEnumerableItems()
	}
}
class GoDTargetsPopUpButton: GoDPopUpButton, GoDEnumerableButton {
    typealias Element = XGMoveTargets
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
