//
//  GoDTableView.swift
//  GoD Tool
//
//  Created by The Steez on 29/06/2016.
//  Copyright © 2016 StarsMmd. All rights reserved.
//

import AppKit

class GoDTableView: NSScrollView {
	
	var tableView : NSTableView!
	var delegate : GoDTableViewDelegate!
	
	var selectedRow : Int {
		get {
			return self.tableView.selectedRow
		}
	}
	
	init(width: CGFloat, rows: Int, rowHeight: CGFloat, delegate: GoDTableViewDelegate, dataSource: NSTableViewDataSource) {
		super.init(frame: NSMakeRect(0, 0, 0, 0))
		
		self.delegate = delegate
		
		self.tableView = NSTableView(frame: NSMakeRect(0,0,width,CGFloat(rows) * rowHeight))
		
		let column = NSTableColumn(identifier: "col")
		column.minWidth = width
		column.title = "XD:GoD"
		self.tableView.addTableColumn(column)
		
		tableView.backgroundColor = NSColor.black
		self.tableView.delegate = delegate
		self.tableView.dataSource = dataSource
		self.tableView.target = self
		self.tableView.action = #selector(didClickCell)
		self.tableView.headerView = nil
		self.scrollsDynamically = true
		
		self.documentView = self.tableView
		
		self.hasVerticalScroller = true
		self.hasHorizontalScroller = false
		
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
	
	func didClickCell() {
		self.delegate.tableView(self, didSelectRow: self.tableView.selectedRow)
		
	}
	
	func reloadData() {
		self.tableView.reloadData()
	}
	
	func reloadIndex(_ index: Int) {
		self.tableView.reloadData(forRowIndexes: [index], columnIndexes: [0])
	}
    
}




