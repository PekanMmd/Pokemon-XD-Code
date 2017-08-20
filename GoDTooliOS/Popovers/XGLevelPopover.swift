//
//  levelTableViewController.swift
//  Mausoleum Tool
//
//  Created by The Steez on 03/11/2014.
//  Copyright (c) 2014 Steezy. All rights reserved.
//

import UIKit

class XGLevelPopover: XGPopover {

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 101
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = dequeueCell()
		
		cell.title = "Level " + String(indexPath.row)
		cell.background = UIImage(named: "Item Cell")!
		
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		delegate.selectedItem = indexPath.row as Any
		delegate.popoverDidDismiss()
	}

}








