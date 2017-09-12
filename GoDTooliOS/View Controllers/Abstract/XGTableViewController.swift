//
//  XGTableViewController.swift
//  XG Tool
//
//  Created by StarsMmd on 12/06/2015.
//  Copyright (c) 2015 StarsMmd. All rights reserved.
//

import UIKit

class XGTableViewController: XGViewController, UITableViewDataSource, UITableViewDelegate {
	
	var tableContentView = UIView()
	var table = UITableView()
	var currentIndexPath = IndexPath(item: 0, section: 0)
	
	override var contentView : UIView! {
		get {
			return tableContentView
		}
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.contentView.translatesAutoresizingMaskIntoConstraints = false
		self.view.addSubview(contentView)
		self.views["content"] = contentView
		
		self.table.dataSource = self
		self.table.delegate = self
		self.table.translatesAutoresizingMaskIntoConstraints = false
		self.view.addSubview(table)
		self.views["table"] = table
		
		self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[table(300)][content]|", options: [.alignAllTop, .alignAllBottom], metrics: nil, views: views))
		self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[table]|", options: [], metrics: nil, views: views))
		
		self.addShadowToView(view: table, radius: 5, xOffset: 5, yOffset: 0)
		
		table.backgroundColor = UIColor.black
		table.separatorStyle = .none
    }
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		return UITableViewCell()
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		return
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 75
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 0
	}

}

















