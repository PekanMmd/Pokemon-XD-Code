//
//  MoveEffectTableViewController.swift
//  Mausoleum Move Tool
//
//  Created by The Steez on 28/12/2014.
//  Copyright (c) 2014 Ovation International. All rights reserved.
//

import UIKit

class XGMoveEffectPopover: XGPopover {

	var effectList = [String]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		effectList = XGFiles.nameAndFolder("Move Effects.json", .JSON).json as! [String]
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return effectList.count
	}
	
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = dequeueCell()
		
		cell.title = effectList[indexPath.row]
		cell.background = UIImage(named: "Item Cell")!
		
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		delegate.selectedItem = indexPath.row as Any
		delegate.popoverDidDismiss()
	}
	
}
