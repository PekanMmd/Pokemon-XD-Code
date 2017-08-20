//
//  XGTrainerModelPickerPopover.swift
//  XG Tool
//
//  Created by The Steez on 14/07/2015.
//  Copyright (c) 2015 Ovation International. All rights reserved.
//

import UIKit

class XGTrainerModelPickerPopover: XGPopover {

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return kNumberOfTrainerModels
	}
	
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = dequeueCell()
		
		let tm = XGTrainerModels(rawValue: indexPath.row) ?? XGTrainerModels.michael1WithoutSnagMachine
		
		cell.picture = tm.image
		cell.background = UIImage(named: "Item Cell.png")!
		cell.textLabel?.textAlignment = .center
		
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		delegate.selectedItem = XGTrainerModels(rawValue: indexPath.row) ?? XGTrainerModels.michael1WithoutSnagMachine as Any
		delegate.popoverDidDismiss()
	}
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 100
	}

}









