//
//  GoDCaseIterablePopUpButton.swift
//  GoD Tool
//
//  Created by Stars Momodu on 17/08/2021.
//

import Foundation

protocol GoDCaseIterableButton: GoDPopUpButton {
	associatedtype Element: CaseIterable & CustomStringConvertible

	var allValues: [Element] { get }
	var selectedValue: Element { get }
	func select(_ value: Element)
	func setUpEnumerableItems()
}

extension GoDCaseIterableButton where Self: GoDPopUpButton {
	private func nameForElement(_ element: Element) -> String {
		return element.description
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


class GoDFilterPopUpButton: GoDPopUpButton, GoDCaseIterableButton {
	typealias Element = GoDFiltersManager.Filters

	var allValues: [Element] {
		return GoDFiltersManager.Filters.allCases
	}

	override func setUpItems() {
		setUpEnumerableItems()
	}
}
