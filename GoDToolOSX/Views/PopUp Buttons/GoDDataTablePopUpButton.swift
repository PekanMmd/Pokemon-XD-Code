//
//  GoDDataTablePopUpButton.swift
//  GoD Tool
//
//  Created by Stars Momodu on 29/03/2021.
//

import Foundation

class GoDDataTablePopUpButton: GoDPopUpButton {

	var table: GoDStructTableFormattable? {
		didSet {
			self.setUpItems()
		}
	}

	var selectedValue: Int {
		return indexOfSelectedItem
	}

	func selectItem(index: Int) {
		self.selectItem(at: index)
	}

	override func setUpItems() {
		var titles = [String]()
		if let setTable = table {
			(0 ..< setTable.numberOfEntries).forEach { (index) in
				titles.append(setTable.assumedNameForEntry(index: index))
			}
		}
		setTitles(values: titles)
	}

	init(table: GoDStructTableFormattable) {
		self.table = table
		super.init()
	}

	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}

}
