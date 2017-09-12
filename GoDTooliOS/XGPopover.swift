//
//  PokemonEditor.swift
//  Mausoleum Tool
//
//  Created by StarsMmd on 29/01/2015.
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
		super.init(style: .plain)
		
		self.tableView.backgroundColor = UIColor.orange
	}

	required init!(coder aDecoder: NSCoder) {
	   super.init(coder: aDecoder)
	}
	
	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.tableView.register(XGTableViewCell.self, forCellReuseIdentifier: "cell")
	}
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 80
	}
	
	func dequeueCell() -> XGTableViewCell {
		return (self.tableView.dequeueReusableCell(withIdentifier: "cell") as? XGTableViewCell) ?? XGTableViewCell()
	}
	
}
