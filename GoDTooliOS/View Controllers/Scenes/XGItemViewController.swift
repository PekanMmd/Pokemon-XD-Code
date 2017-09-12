//
//  XGItemViewController.swift
//  XG Tool
//
//  Created by StarsMmd on 11/06/2015.
//  Copyright (c) 2015 StarsMmd. All rights reserved.
//

import UIKit

class XGItemViewController: XGTableViewController, UISearchResultsUpdating, UISearchBarDelegate {
	
	var item = XGItem(index: 0)
	
	var startField			= XGTextField()
	var indexField			= XGTextField()
	
	var nameField			= XGTextField()
	var descField			= XGTextField()
	
	var canBeHeldButton		= XGButton()
	var bagSlotField		= XGButtonField()
	var inBattleIDField		= XGValueTextField()
	var priceField			= XGValueTextField()
	var couponPriceField	= XGValueTextField()
	var holdItemIDField		= XGValueTextField()
	var parameterField		= XGValueTextField()
	var friendship1Field	= XGValueTextField()
	var friendship2Field	= XGValueTextField()
	var friendship3Field	= XGValueTextField()
	
	var originalCopyButton	= XGPopoverButton()
	var modifiedCopyButton	= XGPopoverButton()
	
	var saveButton = XGButton()
	
	let searchController = UISearchController(searchResultsController: nil)
	var filteredItems = [XGItems]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.title = "Item Editor"
		
		searchController.searchResultsUpdater = self
		searchController.dimsBackgroundDuringPresentation = false
		definesPresentationContext = true
		self.table.tableHeaderView = searchController.searchBar
		searchController.searchBar.delegate = self
		
		self.setUpUI()
		self.updateView()
		
	}
	
	func updateSearchResults(for searchController: UISearchController) {
		let text = searchController.searchBar.text!
		NSObject.cancelPreviousPerformRequests(withTarget: self)
		self.perform(#selector(filterContentForSearchText), with: text, afterDelay: 0.3)
	}
	
	func filterContentForSearchText(searchText: String) {
		if searchText.characters.count > 0 {
			filteredItems = allItemsArray().filter { item in
				let itemName = item.name.string
				return itemName.lowercased().contains(searchText.lowercased())
			}
		}
		
		self.table.reloadData()
	}
	
	func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
		self.table.contentInset = UIEdgeInsetsMake(20, 0, 0, 0)
		self.table.reloadData()
	}
	
	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		self.table.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
		self.table.reloadData()
	}
	
	
	func setUpUI() {
		
		startField = XGTextField(title: "Start Offset", height: 50, width: 150, action: {})
		startField.isUserInteractionEnabled = false
		self.addSubview(startField, name: "start")
		
		indexField = XGTextField(title: "Index", height: 50, width: 150, action: {})
		indexField.isUserInteractionEnabled = false
		self.addSubview(indexField, name: "index")
		
		nameField = XGTextField(title: "Name", height: 50, width: 200, action: { self.item.name.duplicateWithString(self.nameField.text).replace(); self.updateView() })
		self.addSubview(nameField, name: "name")
		
		descField = XGTextField(title: "Description", height: 60, width: 600, action: { self.item.descriptionString.duplicateWithString(self.descField.text).replace(); self.updateView() })
		self.addSubview(descField, name: "desc")
		
		canBeHeldButton = XGButton(title: "Can Be Held", colour: UIColor.red, textColour: UIColor.black, action: { self.item.canBeHeld = !self.item.canBeHeld; self.updateView() })
		self.addSubview(canBeHeldButton, name: "canBeHeld")
		self.addConstraintSize(view: canBeHeldButton, height: 60, width: 150)
		
		bagSlotField = XGButtonField(title: "Bag Slot", text: "", colour: UIColor.yellow, height: 60, width: 150, action: { self.item.bagSlot = self.item.bagSlot.cycle(); self.updateView() })
		self.addSubview(bagSlotField, name: "slot")
		
		inBattleIDField = XGValueTextField(title: "In Battle ID", min: 0, max: 0xFF, height: 60, width: 150, action: { self.item.inBattleUseID = self.inBattleIDField.value; self.updateView() })
		self.addSubview(inBattleIDField, name: "battleID")
		
		priceField = XGValueTextField(title: "Price", min: 0, max: 0xFFFF, height: 60, width: 150, action: { self.item.price = self.priceField.value; self.updateView() })
		self.addSubview(priceField, name: "price")
		
		couponPriceField = XGValueTextField(title: "Coupon Price", min: 0, max: 0xFFFF, height: 60, width: 150, action: { self.item.couponPrice = self.couponPriceField.value; self.updateView() })
		self.addSubview(couponPriceField, name: "coupon")
		
		holdItemIDField = XGValueTextField(title: "Hold Item ID", min: 0, max: 0xFF, height: 60, width: 150, action: { self.item.holdItemID = self.holdItemIDField.value; self.updateView() })
		self.addSubview(holdItemIDField, name: "holdID")
		
		parameterField = XGValueTextField(title: "Parameter", min: 0, max: 0xFF, height: 60, width: 150, action: { self.item.parameter = self.parameterField.value; self.updateView() })
		self.addSubview(parameterField, name: "parameter")
		
		friendship1Field = XGValueTextField(title: "Friendship 1", min: 0, max: 0xFF, height: 60, width: 150, action: { self.item.friendshipEffects[0] = self.friendship1Field.value; self.updateView() })
		self.addSubview(friendship1Field, name: "fr1")
		
		friendship2Field = XGValueTextField(title: "Friendship 2", min: 0, max: 0xFF, height: 60, width: 150, action: { self.item.friendshipEffects[1] = self.friendship2Field.value; self.updateView() })
		self.addSubview(friendship2Field, name: "fr2")
		
		friendship3Field = XGValueTextField(title: "Friendship 3", min: 0, max: 0xFF, height: 60, width: 150, action: { self.item.friendshipEffects[2] = self.friendship3Field.value; self.updateView() })
		self.addSubview(friendship3Field, name: "fr3")
		
		originalCopyButton = XGPopoverButton(title: "Original Items", colour: UIColor.purple, textColour: UIColor.black, popover: XGOriginalItemPopover(), viewController: self)
		self.addSubview(originalCopyButton, name: "OCB")
		self.addConstraintSize(view: originalCopyButton, height: 60, width: 200)
		
		modifiedCopyButton = XGPopoverButton(title: "Modified Items", colour: UIColor.purple, textColour: UIColor.black, popover: XGItemPopover(), viewController: self)
		self.addSubview(modifiedCopyButton, name: "MCB")
		self.addConstraintSize(view: modifiedCopyButton, height: 60, width: 200)
		
		saveButton = XGButton(title: "Save", colour: UIColor.blue, textColour: UIColor.black, action: { self.save() })
		self.addSubview(saveButton, name: "save")
		self.addConstraintSize(view: saveButton, height: 60, width: 200)
		
		self.createDummyViewsEqualWidths(4, baseName: "t")
		self.createDummyViewsEqualWidths(4, baseName: "u")
		self.createDummyViewsEqualWidths(4, baseName: "v")
		self.createDummyViewsEqualWidths(5, baseName: "w")
		self.createDummyViewsEqualWidths(4, baseName: "x")
		self.createDummyViewsEqualHeights(3, baseName: "y")
		
		self.addConstraintAlignTopEdges(view1: self.holdItemIDField, view2: views["w3"]!)
		
		self.addConstraints(visualFormat: "H:|[t1][start][t2][name][t3][index][t4]|", layoutFormat: [.alignAllTop, .alignAllBottom])
		self.addConstraints(visualFormat: "H:|[u1][coupon][u2][price][u3][parameter][u4]|", layoutFormat: [.alignAllTop, .alignAllBottom])
		self.addConstraints(visualFormat: "H:|[v1][fr1][v2][fr2][v3][fr3][v4]|", layoutFormat: [.alignAllTop, .alignAllBottom])
		self.addConstraints(visualFormat: "H:|[w1][battleID][w2][holdID][w3][slot][w4][canBeHeld][w5]|", layoutFormat: .alignAllBottom)
		self.addConstraints(visualFormat: "H:|[x1][OCB][x2][save][x3][MCB][x4]|", layoutFormat: [.alignAllTop, .alignAllBottom])
		self.addConstraintAlignCenterX(view1: self.contentView, view2: nameField)
		self.addConstraints(visualFormat: "V:|[name][desc][price][y1][fr2][y2][w3][y3][save]-(20)-|", layoutFormat: .alignAllCenterX)
		
	}
	
	func updateView() {
		
		self.showActivityView { (Bool) -> Void in
			
			self.startField.text = String(format: "\(self.item.startOffset) : 0x%x", self.item.startOffset)
			self.indexField.text = String(format: "\(self.item.index) : 0x%x", self.item.index)
			self.nameField.text  = self.item.name.string
			self.descField.text  = self.item.descriptionString.string
			
			self.couponPriceField.value = self.item.couponPrice
			self.priceField.value = self.item.price
			self.parameterField.value = self.item.parameter
			
			self.canBeHeldButton.backgroundColor = self.item.canBeHeld ? UIColor.green : UIColor.red
			self.bagSlotField.text = self.item.bagSlot.name
			self.inBattleIDField.value = self.item.inBattleUseID
			self.holdItemIDField.value = self.item.holdItemID
			self.friendship1Field.value = self.item.friendshipEffects[0]
			self.friendship2Field.value = self.item.friendshipEffects[1]
			self.friendship3Field.value = self.item.friendshipEffects[2]
			
			self.hideActivityView()
			
		}
		
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		var cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! XGTableViewCell!
		if cell == nil {
			cell = XGTableViewCell(style: .subtitle, reuseIdentifier: "cell")
		}
		
		if searchController.isActive && searchController.searchBar.text != "" {
			cell?.title = filteredItems[indexPath.row].name.string
		} else {
			cell?.title = XGItems.item(indexPath.row).name.string
		}
		
		cell?.background = UIImage(named: "Item Cell")!
		cell?.subtitle = String(format: "\(item.index) : 0x%x", item.index)
		
		return cell!
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		self.currentIndexPath = indexPath
		if searchController.isActive && searchController.searchBar.text != "" {
			let i = filteredItems[indexPath.row].index
			self.item = XGItem(index: i)
		} else {
			self.item = XGItem(index: indexPath.row)
		}
		
		self.updateView()
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if searchController.isActive && searchController.searchBar.text != "" {
			return filteredItems.count
		}
		return kNumberOfItems
	}
	
	override func popoverDidDismiss() {
		
		popoverPresenter.popover.dismiss(animated: true)
		
		if popoverPresenter == originalCopyButton {
			
			let item = selectedItem as! XGOriginalItems
			let byteCopier = XGByteCopier(copyFile: .original(.common_rel), copyOffset: item.startOffset, length: kSizeOfItemData, targetFile: .common_rel, targetOffset: self.item.startOffset)
			let popover = XGByteCopyPopover(copier: byteCopier)
			let popButton = XGPopoverButton(title: "", colour: UIColor.clear, textColour: UIColor.clear, popover: popover, viewController: self)
			popButton.alpha = 0
			self.addSubview(popButton, name: "OPB")
			self.addConstraintAlignAllEdges(view1: self.originalCopyButton, view2: popButton)
			popButton.action()
			self.item.save()
			
		} else if popoverPresenter == views["OPB"] {
			
			popoverPresenter.removeFromSuperview()
			self.item = XGItem(index: self.item.index)
			
		} else if popoverPresenter == modifiedCopyButton {
			
			let item = selectedItem as! XGItems
			let byteCopier = XGByteCopier(copyFile: .common_rel, copyOffset: item.startOffset, length: kSizeOfItemData, targetFile: .common_rel, targetOffset: self.item.startOffset)
			let popover = XGByteCopyPopover(copier: byteCopier)
			let popButton = XGPopoverButton(title: "", colour: UIColor.clear, textColour: UIColor.clear, popover: popover, viewController: self)
			popButton.alpha = 0
			self.addSubview(popButton, name: "MPB")
			self.addConstraintAlignAllEdges(view1: self.modifiedCopyButton, view2: popButton)
			popButton.action()
			self.item.save()
			
		} else if popoverPresenter == views["MPB"] {
			
			popoverPresenter.removeFromSuperview()
			self.item = XGItem(index: self.item.index)
			
		}
		
		self.updateView()
	}
	
	func save() {
		self.showActivityView { (Bool) -> Void in
			self.item.save()
			
			self.table.reloadRows(at: [self.currentIndexPath], with: .fade)
			self.table.selectRow(at: self.currentIndexPath, animated: false, scrollPosition: .none)
			
			self.hideActivityView()
		}
	}
	
}






















