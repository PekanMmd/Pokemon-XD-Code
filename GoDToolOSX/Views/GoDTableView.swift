//
//  GoDTableView.swift
//  GoD Tool
//
//  Created by StarsMmd on 29/06/2016.
//  Copyright © 2016 StarsMmd. All rights reserved.
//

import AppKit

class GoDTableView: NSScrollView {
	
	var tableView : NSTableView!
	var delegate : GoDTableViewDelegate!
	
	var width : NSNumber = 0
	
	var selectedRow = -1
	
	init(width: NSNumber, rows: Int, rowHeight: CGFloat, delegate: GoDTableViewDelegate, dataSource: NSTableViewDataSource) {
		super.init(frame: .zero)
		
		self.setUp(width: width, rows: rows, rowHeight: rowHeight, delegate: delegate, dataSource: dataSource)
		
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	func setUp(width: NSNumber, rows: Int, rowHeight: CGFloat, delegate: GoDTableViewDelegate, dataSource: NSTableViewDataSource) {
		self.delegate = delegate
		
		self.width = width
		
		self.tableView = NSTableView(frame: NSMakeRect(0,0,0,CGFloat(rows) * rowHeight))
		self.tableView.translatesAutoresizingMaskIntoConstraints = false
		self.tableView.addConstraintWidth(view: self.tableView, width: width)
		
		self.tableView.intercellSpacing = NSSize(width: 0, height: 0)
		
		let column = NSTableColumn(identifier: NSUserInterfaceItemIdentifier(rawValue: "col"))
		column.minWidth = CGFloat(truncating: width)
		column.title = "XD:GoD"
		self.tableView.addTableColumn(column)
		
		tableView.backgroundColor = GoDDesign.colourClear()
		self.tableView.delegate = delegate
		self.tableView.dataSource = dataSource
		self.tableView.target = self
		self.tableView.action = #selector(didClickCell)
		self.tableView.headerView = nil
		self.scrollsDynamically = true
		
		self.documentView = self.tableView
		
		self.hasVerticalScroller = true
		self.hasHorizontalScroller = false
		self.autohidesScrollers = true
		self.scrollerStyle = .overlay
		
	}
	
	@objc func didClickCell() {
		if self.tableView.selectedRow >= 0 {
			let previousRow = selectedRow
			selectedRow = tableView.selectedRow
			reload(indexes: [previousRow, selectedRow])
			delegate.tableView(self, didSelectRow: tableView.selectedRow)
		}
	}
	
	func reloadData() {
		self.tableView.reloadData()
		selectedRow = -1
	}
	
	func reload(index: Int) {
		self.tableView.reloadData(forRowIndexes: [index], columnIndexes: [0])
	}

	func reload(indexes: IndexSet) {
		tableView.reloadData(forRowIndexes: indexes, columnIndexes: [0])
	}
	
	func setBGColour(_ colour: NSColor) {
		super.setBackgroundColour(colour)
		self.tableView.backgroundColor = colour
		self.tableView.enclosingScrollView?.drawsBackground = colour.alphaComponent > 0
	}

	func scrollToTop() {
		tableView.scrollRowToVisible(0)
	}
    
}




