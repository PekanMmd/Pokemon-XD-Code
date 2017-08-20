////
////  XGEvolutionPopover.swift
////  XG Tool
////
////  Created by The Steez on 25/08/2015.
////  Copyright (c) 2015 Ovation International. All rights reserved.
////
//
//import UIKit
//
//class XGEvolutionPopover: XGTableViewController {
//
//	var stats = XGPokemonStats(index: 0)
//	var popover = UIPopoverController(contentViewController: UIViewController())
//	
//	var param  = XGValueTextField()
//	var poke   = XGPopoverButton()
//	var method = XGPopoverButton()
//	var saveButton = XGButton()
//	var dismissButton = XGButton()
//	
//	override func viewDidLoad() {
//		super.viewDidLoad()
//		
//		self.setUpUI()
//	}
//	
//	func setUpUI() {
//		self.showActivityView { (Bool) -> Void in
//			self.level = XGValueTextField(title: "Level", value: 1, min: 1, max: 100, height: 100, width: 200, action: { self.stats.levelUpMoves[self.currentIndexPath.row].level = self.level.value; self.update() })
//			self.addSubview(self.level, name: "level")
//			
//			self.move = XGPopoverButton(title: "", colour: UIColor.clearColor(), textColour: UIColor.blackColor(), popover: XGMovePopover(), viewController: self)
//			self.addSubview(self.move, name: "move")
//			self.addConstraintSize(view: self.move, height: 100, width: 200)
//			
//			self.saveButton = XGButton(title: "Save", colour: UIColor.blueColor(), textColour: UIColor.whiteColor(), action: {self.save()})
//			self.addSubview(self.saveButton, name: "save")
//			self.addConstraintSize(view: self.saveButton, height: 70, width: 100)
//			
//			self.dismissButton = XGButton(title: "Close", colour: UIColor.redColor(), textColour: UIColor.whiteColor(), action: {self.dismiss()})
//			self.addSubview(self.dismissButton, name: "dismiss")
//			self.addConstraintSize(view: self.dismissButton, height: 70, width: 100)
//			
//			self.createDummyViewsEqualWidths(3, baseName: "h")
//			self.createDummyViewsEqualHeights(4, baseName: "v")
//			
//			self.addConstraints(visualFormat: "H:|[h1][save][h2][dismiss][h3]|", layoutFormat: .AlignAllTop | .AlignAllBottom)
//			self.addConstraints(visualFormat: "V:|[v1][level][v2][move][v3][h2][v4]|", layoutFormat: .AlignAllCenterX)
//			
//			self.hideActivityView()
//			self.table.reloadData()
//			self.update()
//		}
//	}
//	
//	func update() {
//		self.showActivityView { (Bool) -> Void in
//			var lumove = self.stats.levelUpMoves[self.currentIndexPath.row]
//			
//			self.level.value = lumove.level
//			self.move.textLabel.text = lumove.move.name.string
//			self.move.setBackgroundImage(lumove.move.type.image, forState: .Normal)
//			
//			self.hideActivityView()
//		}
//	}
//	
//	override func popoverDidDismiss() {
//		self.showActivityView { (Bool) -> Void in
//			self.stats.levelUpMoves[self.currentIndexPath.row].move = self.selectedItem as! XGMoves
//			self.move.popover.dismissPopoverAnimated(true)
//			self.update()
//		}
//	}
//	
//	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//		var cell = tableView.dequeueReusableCellWithIdentifier("cell") as! XGTableViewCell!
//		if cell == nil {
//			cell = XGTableViewCell(style: .Subtitle, reuseIdentifier: "cell")
//		}
//		
//		let lumove = self.stats.levelUpMoves[indexPath.row]
//		
//		cell.title = "Level \(lumove.level) : " + lumove.move.name.string
//		cell.background = lumove.move.type.image
//		
//		return cell!
//	}
//	
//	override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//		return 50
//	}
//	
//	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//		return stats.levelUpMoves.count
//	}
//	
//	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//		self.currentIndexPath = indexPath
//		self.update()
//	}
//	
//	
//	func dismiss() {
//		popover.dismissPopoverAnimated(true)
//	}
//	
//	func save() {
//		self.showActivityView { (Bool) -> Void in
//			self.stats.save()
//			self.table.reloadRowsAtIndexPaths([self.currentIndexPath], withRowAnimation: .Fade)
//			self.table.selectRowAtIndexPath(self.currentIndexPath, animated: true, scrollPosition: .None)
//			
//			self.hideActivityView()
//		}
//	}
//
//}
