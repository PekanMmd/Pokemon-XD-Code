//
//  XGTrainerClassPickerPopover.swift
//  XG Tool
//
//  Created by The Steez on 14/07/2015.
//  Copyright (c) 2015 Ovation International. All rights reserved.
//

import UIKit

class XGTrainerClassPickerPopover: XGPopover {

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return kNumberOfTrainerClasses
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = dequeueCell()
		
		let tc = XGTrainerClasses(rawValue: indexPath.row) ?? XGTrainerClasses.michael1
		
		cell.title = tc.name.string
		cell.background = XGResources.png("Item Cell").image
		cell.textLabel?.textAlignment = .center
		
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		delegate.selectedItem = XGTrainerClasses(rawValue: indexPath.row) ?? XGTrainerClasses.michael1 as Any
		delegate.popoverDidDismiss()
	}
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 75
	}

}
