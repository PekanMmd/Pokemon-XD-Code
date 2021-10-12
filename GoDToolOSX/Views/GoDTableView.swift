//
//  GoDTableView.swift
//  GoD Tool
//
//  Created by StarsMmd on 29/06/2016.
//  Copyright © 2016 StarsMmd. All rights reserved.
//

import AppKit

class GoDTableView: NSView {

	var backgroundColor: NSColor {
		get {
			scrollView.backgroundColor
		}
		set {
			scrollView.backgroundColor = newValue
		}
	}

	private var scrollView: NSScrollView!
	private var tableView: NSTableView!
	private var searchField: NSSearchField!
	private weak var delegate: GoDTableViewDelegate!
	private weak var dataSource: GoDTableViewDataSource!
	
	var selectedRow = -1
	
	init(width: CGFloat, delegate: GoDTableViewDelegate, dataSource: GoDTableViewDataSource) {
		super.init(frame: .zero)
		
		setUp(width: width, delegate: delegate, dataSource: dataSource)
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	func setUp(width: CGFloat, delegate: GoDTableViewDelegate, dataSource: GoDTableViewDataSource) {
		self.delegate = delegate
		self.dataSource = dataSource

		searchField = NSSearchField()
		scrollView = NSScrollView()
		tableView = NSTableView(frame: .zero)

		translatesAutoresizingMaskIntoConstraints = false
		addSubview(searchField)
		searchField.translatesAutoresizingMaskIntoConstraints = false
		addSubview(scrollView)
		scrollView.translatesAutoresizingMaskIntoConstraints = false
		scrollView.addSubview(tableView)
		tableView.translatesAutoresizingMaskIntoConstraints = false

		let searchFieldHeight: CGFloat = dataSource.searchBarBehaviourForTableView(self) == .none ? 0 : 30
		let padding: CGFloat = dataSource.searchBarBehaviourForTableView(self) == .none ? 0 : 3
		searchField.pinHeight(as: searchFieldHeight)
		searchField.pinTop(to: self, padding: padding)
		searchField.pinLeading(to: self, padding: padding)
		searchField.pinTrailing(to: self, padding: padding)
		scrollView.pinTopToBottom(of: searchField, padding: padding)
		scrollView.pinLeading(to: self)
		scrollView.pinTrailing(to: self)
		scrollView.pinBottom(to: self)
		tableView.pinWidth(as: width)

		searchField.delegate = self
		searchField.sendsWholeSearchString = true
		searchField.sendsSearchStringImmediately = false

		let column = NSTableColumn(identifier: NSUserInterfaceItemIdentifier(rawValue: "col"))
		column.minWidth = width
		column.title = "XD"
		tableView.addTableColumn(column)
		tableView.intercellSpacing = NSSize(width: 0, height: 0)
		
		tableView.backgroundColor = GoDDesign.colourClear().NSColour
		tableView.delegate = delegate
		tableView.dataSource = dataSource
		tableView.target = self
		tableView.action = #selector(didClickCell)
		tableView.headerView = nil

		scrollView.scrollsDynamically = true
		scrollView.documentView = tableView
		scrollView.hasVerticalScroller = true
		scrollView.hasHorizontalScroller = false
		scrollView.autohidesScrollers = true
		scrollView.scrollerStyle = .overlay

		searchField.resignFirstResponder()

		searchField.target = self
		searchField.action = #selector(searchFieldAction)
	}

	func reloadData() {
		tableView.reloadData()
		selectedRow = -1
	}
	
	func reload(index: Int) {
		tableView.reloadData(forRowIndexes: [index], columnIndexes: [0])
	}

	func reload(indexes: IndexSet) {
		tableView.reloadData(forRowIndexes: indexes, columnIndexes: [0])
	}

	func scrollToTop() {
		tableView.scrollRowToVisible(0)
	}

	func setShouldUseIntercellSpacing(to: Bool) {
		tableView.intercellSpacing = .init(width: 0, height: to ? 1 : 0)
	}

	@objc private func didClickCell() {
		if tableView.selectedRow >= 0 {
			let previousRow = selectedRow
			selectedRow = tableView.selectedRow
			reload(indexes: [previousRow, selectedRow])
			delegate.tableView(self, didSelectRow: tableView.selectedRow)
		}
	}
}

extension GoDTableView: NSSearchFieldDelegate {

	func controlTextDidChange(_ obj: Notification) {
		if dataSource.searchBarBehaviourForTableView(self) == .onTextChange {
			search(for: searchField.stringValue)
		}
	}

	@objc private func searchFieldAction(sender: NSSearchField) {
		if dataSource.searchBarBehaviourForTableView(self) == .onEndEditing {
			search(for: searchField.stringValue)
		}
	}

	private func search(for text: String) {
		selectedRow = -1
		dataSource.tableView(self, didSearchForText: text)
	}
}




