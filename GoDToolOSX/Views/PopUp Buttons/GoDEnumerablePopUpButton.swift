//
//  GoDEnumerablePopUpButton.swift
//  GoD Tool
//
//  Created by Stars Momodu on 07/10/2019.
//

import Foundation

// Should be class GoDEnumerableButton<T: XGEnumerable>: GoDPopUpButton {
// but doesn't work with interface builder atm because objc doesn't do generics
//class GoDEnumerableButton: GoDPopUpButton {
//    private let allValues = [Any]()
//
//	func selectedValue<T: XGEnumerable>() -> T {
//		return allValues[self.indexOfSelectedItem] as! T
//	}
//
//    func select<T: XGEnumerable>(_ value: T) {
//		self.selectItem(withTitle: value.enumerableName)
//	}
//
//	override func setUpItems() {
//		let values = allValues.map { (item) -> String in
//			return item.enumerableName
//		}
//		self.setTitles(values: values)
//	}
//}

protocol GoDEnumerableButton: GoDPopUpButton {
    associatedtype Element: XGEnumerable
    
    var allValues: [Element] { get }
    var selectedValue: Element { get }
    func select(_ value: Element)
	func setUpEnumerableItems()
}

extension GoDEnumerableButton where Self: GoDPopUpButton {
	private func nameForElement(_ element: Element) -> String {
		let value = element.enumerableValue == nil ? "" : " (\(element.enumerableValue!))"
		return element.enumerableName + value
	}

    var selectedValue: Element {
        return allValues[self.indexOfSelectedItem]
    }

    func select(_ value: Element) {
        self.selectItem(withTitle: nameForElement(value))
    }

    func setUpEnumerableItems() {
        let values = allValues.map(nameForElement)
        self.setTitles(values: values)
    }
}


class GoDAbilityPopUpButton: GoDPopUpButton, GoDEnumerableButton {
    typealias Element = XGAbilities
    lazy var allValues = Element.allValues
	override func setUpItems() {
		setUpEnumerableItems()
	}
}
class GoDBattleStylePopUpButton: GoDPopUpButton, GoDEnumerableButton {
    typealias Element = XGBattleStyles
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
class GoDEffectivenessPopUpButton: GoDPopUpButton, GoDEnumerableButton {
    typealias Element = XGEffectivenessValues
    lazy var allValues = Element.allValues
	override func setUpItems() {
		setUpEnumerableItems()
	}
}
class GoDExpRatePopUpButton: GoDPopUpButton, GoDEnumerableButton {
    typealias Element = XGExpRate
    lazy var allValues = Element.allValues
	override func setUpItems() {
		setUpEnumerableItems()
	}
}
class GoDGenderPopUpButton: GoDPopUpButton, GoDEnumerableButton {
    typealias Element = XGGenders
    lazy var allValues = Element.allValues
	override func setUpItems() {
		setUpEnumerableItems()
	}
}
class GoDGenderRatioPopUpButton: GoDPopUpButton, GoDEnumerableButton {
    typealias Element = XGGenderRatios
    lazy var allValues = Element.allValues
	override func setUpItems() {
		setUpEnumerableItems()
	}
}
class GoDMovePopUpButton: GoDPopUpButton, GoDEnumerableButton {
    typealias Element = XGMoves
    lazy var allValues = Element.allValues
	override func setUpItems() {
		setUpEnumerableItems()
	}
}

class GoDNaturePopUpButton: GoDPopUpButton, GoDEnumerableButton {
    typealias Element = XGNatures
    lazy var allValues = Element.allValues
	override func setUpItems() {
		setUpEnumerableItems()
	}
}
class GoDTypePopUpButton: GoDPopUpButton, GoDEnumerableButton {
    typealias Element = XGMoveTypes
    lazy var allValues = Element.allValues
	override func setUpItems() {
		setUpEnumerableItems()
	}
}

//typealias GoDAbilityPopUpButton = GoDEnumerableButton<XGAbilities>
//typealias GoDBattleStylePopUpButton = GoDEnumerableButton<XGBattleStyles>
//typealias GoDBattleTypePopUpButton = GoDEnumerableButton<XGBattleTypes>
//typealias GoDCategoryPopUpButton = GoDEnumerableButton<XGMoveCategories>
//typealias GoDDirectionPopUpButton = GoDEnumerableButton<XGElevatorDirections>
//typealias GoDEffectivenessPopUpButton = GoDEnumerableButton<XGEffectivenessValues>
//typealias GoDEvolutionMethodPopUpButton = GoDEnumerableButton<XGEvolutionMethods>
//typealias GoDExpRatePopUpButton = GoDEnumerableButton<XGExpRate>
//typealias GoDGenderPopUpButton = GoDEnumerableButton<XGGenders>
//typealias GoDGenderRatioPopUpButton = GoDEnumerableButton<XGGenderRatios>
//typealias GoDItemPopUpButton = GoDEnumerableButton<XGItems>
//typealias GoDMovePopUpButton = GoDEnumerableButton<XGMoves>
//typealias GoDMoveEffectTypesPopUpButton = GoDEnumerableButton<XGMoveEffectTypes>
//typealias GoDNaturePopUpButton = GoDEnumerableButton<XGNatures>
//typealias GoDPocketPopUpButton = GoDEnumerableButton<XGBagSlots>
//typealias GoDPokemonPopUpButton = GoDEnumerableButton<XGPokemon>
//typealias GoDTargetsPopUpButton = GoDEnumerableButton<XGMoveTargets>
//typealias GoDTrainerClassPopUpButton = GoDEnumerableButton<XGTrainerClasses>
//typealias GoDTrainerModelPopUpButton = GoDEnumerableButton<XGTrainerModels>
//typealias GoDTypePopUpButton = GoDEnumerableButton<XGMoveTypes>

