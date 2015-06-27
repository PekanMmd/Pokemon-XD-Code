//
//  PokemonEditor.swift
//  Mausoleum Tool
//
//  Created by The Steez on 29/01/2015.
//  Copyright (c) 2015 Steezy. All rights reserved.
//

import UIKit

protocol XGPopoverDelegate {
	
	var selectedItem : Any {get set}
	
	func popoverDidDismiss()
	
}

class XGPopover : UITableViewController {
	
	var delegate : XGPopoverDelegate!
	
	init() {
		super.init(style: .Plain)
		
		self.tableView.backgroundColor = UIColor.orangeColor()
	}

	required init!(coder aDecoder: NSCoder!) {
	   super.init(coder: aDecoder)
	}
	
	override init!(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.tableView.registerClass(XGTableViewCell.self, forCellReuseIdentifier: "cell")
	}
	
	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return 80
	}
	
	func dequeueCell() -> XGTableViewCell {
		return (self.tableView.dequeueReusableCellWithIdentifier("cell") as? XGTableViewCell) ?? XGTableViewCell()
	}
	
}
