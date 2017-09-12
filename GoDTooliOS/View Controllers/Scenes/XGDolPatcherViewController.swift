//
//  XGDolPatcherViewController.swift
//  XG Tool
//
//  Created by StarsMmd on 11/06/2015.
//  Copyright (c) 2015 StarsMmd. All rights reserved.
//

import UIKit

class XGDolPatcherViewController: XGTableViewController {
	
	var patches = [XGDolPatches]()
	var patch = XGDolPatches.physicalSpecialSplitApply
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.title = "Dol Patcher"
		
		for i in 0 ..< kNumberOfDolPatches {
			patches.append(XGDolPatches(rawValue: i) ?? .physicalSpecialSplitApply)
		}
		
		self.table.reloadData()
		
		let applyButton = XGButton(title: "Apply Selected Patch", colour: UIColor.blue, textColour: UIColor.white, action: {
			self.showActivityView { (Bool) -> Void in
				XGDolPatcher.applyPatch(self.patch)
				self.hideActivityView()
			}
		})
		self.addSubview(applyButton, name: "apply")
		self.addConstraintAlignCenters(view1: self.contentView, view2: applyButton)
		self.addConstraintSize(view: applyButton, height: 150, width: 300)
		
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		var cell = table.dequeueReusableCell(withIdentifier: "cell") as! XGTableViewCell!
		if  cell == nil {
			cell = XGTableViewCell(style: .default, reuseIdentifier: "cell")
		}
		
		cell?.title = patches[indexPath.row].name
		cell?.background = XGResources.png("Tool Cell").image
		
		return cell!
		
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		self.patch = patches[indexPath.row]
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.patches.count
	}
	
	
	
	
}









