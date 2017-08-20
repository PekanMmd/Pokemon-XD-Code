//
//  natureTableViewController.swift
//  Mausoleum Tool
//
//  Created by The Steez on 25/01/2015.
//  Copyright (c) 2015 Steezy. All rights reserved.
//

import UIKit

class XGNaturePopover: XGPopover {
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 25
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = dequeueCell()
		
		let nature = XGNatures(rawValue: indexPath.row) ?? .hardy
		
		cell.title = nature.string
		
		cell.background = UIImage(named: "Item Cell")!
		
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		delegate.selectedItem = XGNatures(rawValue: indexPath.row) ?? XGNatures.hardy as Any
		delegate.popoverDidDismiss()
	}
	
}









