//
//  XGMoveViewController.swift
//  XG Tool
//
//  Created by StarsMmd on 20/06/2015.
//  Copyright (c) 2015 StarsMmd. All rights reserved.
//

import UIKit

class XGMoveViewController: XGTableViewController, UISearchResultsUpdating, UISearchBarDelegate {
	
	var animations = [Int]()
	
	var moveNames = [String]()
	var moveTypes = [XGMoveTypes]()
	
	var move = XGMove(index: 0)
	
	var startField		= XGTextField()
	var indexField		= XGTextField()
	
	var nameField		= XGTextField()
	var descField		= XGTextField()
	
	var priorityField	= XGValueTextField()
	var ppTextField		= XGValueTextField()
	var accuracyField	= XGValueTextField()
	var powerField		= XGValueTextField()
	var effectAccuracyField	= XGValueTextField()
	
	var animationButton	= XGPopoverButton()
	var typeButton		= XGPopoverButton()
	var effectButton	= XGPopoverButton()
	var targetsButton	= XGButtonField()
	var categoryButton	= XGButtonField()
	
	var contactButton	= XGButton()
	var protectButton	= XGButton()
	var magicButton		= XGButton()
	var snatchButton	= XGButton()
	var mirrorButton	= XGButton()
	var kingsButton		= XGButton()
	var soundButton		= XGButton()
	var hmButton		= XGButton()
	
	var originalCopyButton	= XGPopoverButton()
	var modifiedCopyButton	= XGPopoverButton()
	
	var saveButton		= XGButton()
	
	let searchController = UISearchController(searchResultsController: nil)
	var filteredMoves = [XGMoves]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.title = "Move Editor"
		
		searchController.searchResultsUpdater = self
		searchController.dimsBackgroundDuringPresentation = false
		definesPresentationContext = true
		self.table.tableHeaderView = searchController.searchBar
		searchController.searchBar.scopeButtonTitles = ["Name", "Type"]
		searchController.searchBar.delegate = self
		
		self.showActivityView{ (Bool) -> Void in
			
			for i in 0 ..< kNumberOfMoves {
				self.animations.append(i)
			}
			
			self.loadTableData()
			self.table.reloadData()
			self.setUpUI()
			self.updateView()
			
			self.hideActivityView()
		}
		
	}
	
	func updateSearchResults(for searchController: UISearchController) {
		let searchBar = searchController.searchBar
		let text = searchBar.text!
		let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
		NSObject.cancelPreviousPerformRequests(withTarget: self)
		self.perform(#selector(filterContentForSearchText), with: [text, scope], afterDelay: 1.0)
	}
	
	func filterContentForSearchText(textAndScope: [String]) {
		let searchText = textAndScope[0]
		let scope = textAndScope[1]
		if searchText.characters.count > 0 {
			filteredMoves = allMovesArray().filter { move in
				let wantedInfo: String
				if scope == "Name" {
					wantedInfo = move.name.string
				} else {
					wantedInfo = move.type.name
				}
				return wantedInfo.lowercased().contains(searchText.lowercased())
			}
		}
		
		self.table.reloadData()
	}
	
	func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
		filterContentForSearchText(textAndScope: [searchBar.text!, searchBar.scopeButtonTitles![selectedScope]])
	}
	
	func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
		let searchBarHeight = searchController.searchBar.frame.height
		self.table.contentInset = UIEdgeInsetsMake(searchBarHeight + 20, 0, 0, 0)
		self.table.reloadData()
	}
	
	//    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
	//        if !searchController.isActive {
	//            self.table.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
	//            self.table.reloadData()
	//        }
	//    }
	
	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		self.table.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
		self.table.reloadData()
	}
	
	func loadTableData() {
		
		moveNames = []
		moveTypes = []
		
		for i in 0 ..< kNumberOfMoves {
			let move = XGMoves.move(i)
			
			moveNames.append(move.name.string)
			moveTypes.append(move.type)
		}
		
	}
	
	func setUpUI() {
		
		startField = XGTextField(title: "Start Offset", height: 50, width: 150, action: {})
		startField.isUserInteractionEnabled = false
		self.addSubview(startField, name: "start")
		
		indexField = XGTextField(title: "Index", height: 50, width: 150, action: {})
		indexField.isUserInteractionEnabled = false
		self.addSubview(indexField, name: "index")
		
		nameField = XGTextField(title: "Name", height: 50, width: 200, action: { self.move.name.duplicateWithString(self.nameField.text).replace(); self.updateView() })
		self.addSubview(nameField, name: "name")
		
		descField = XGTextField(title: "Description", height: 50, width: 600, action: { self.move.mdescription.duplicateWithString(self.descField.text).replace(); self.updateView() })
		self.addSubview(descField, name: "desc")
		
		priorityField = XGValueTextField(title: "Priority", min: -126, max: 126, height: 50, width: 100, action: {self.move.priority = self.priorityField.value >= 0 ? self.priorityField.value : (256 - self.priorityField.value)})
		self.addSubview(priorityField, name: "priority")
		
		ppTextField = XGValueTextField(title: "PP", min: 0, max: 255, height: 50, width: 100, action: {self.move.pp = self.ppTextField.value; self.updateView()})
		self.addSubview(ppTextField, name: "pp")
		
		accuracyField = XGValueTextField(title: "accuracy", min: 0, max: 255, height: 50, width: 100, action: {self.move.accuracy = self.accuracyField.value; self.updateView()})
		self.addSubview(accuracyField, name: "accuracy")
		
		powerField = XGValueTextField(title: "Power", min: 0, max: 255, height: 50, width: 100, action: {self.move.basePower = self.powerField.value; self.updateView()})
		self.addSubview(powerField, name: "power")
		
		effectAccuracyField = XGValueTextField(title: "Effect Accuracy", min: 0, max: 255, height: 50, width: 100, action: {self.move.effectAccuracy = self.effectAccuracyField.value; self.updateView()})
		self.addSubview(effectAccuracyField, name: "effectAccuracy")
		
		effectButton = XGPopoverButton(title: "Effect", colour: UIColor.black, textColour: UIColor.orange, popover: XGMoveEffectPopover(), viewController: self)
		self.addSubview(effectButton, name: "effect")
		self.addConstraintSize(view: effectButton, height: 50, width: 600)
		
		typeButton = XGPopoverButton(title: "Type", colour: UIColor.white, textColour: UIColor.black, popover: XGTypePopover(), viewController: self)
		self.addSubview(typeButton, name: "type")
		self.addConstraintWidth(view: typeButton, width: 200)
		
		categoryButton = XGButtonField(title: "Category", text: "", colour: UIColor.yellow, height: 40, width: 175, action: {self.move.category = self.move.category.cycle(); self.updateView()})
		self.addSubview(categoryButton, name: "category")
		
		targetsButton = XGButtonField(title: "Targets", text: "", colour: UIColor.yellow, height: 40, width: 175, action: {self.move.target = self.move.target.cycle(); self.updateView()})
		self.addSubview(targetsButton, name: "targets")
		
		contactButton = XGButton(title: "Contact", colour: UIColor.red, textColour: UIColor.black, action: {self.move.contactFlag = !self.move.contactFlag; self.updateView()})
		self.addSubview(contactButton, name: "contact")
		self.addConstraintSize(view: contactButton, height: 40, width: 100)
		protectButton = XGButton(title: "Protect", colour: UIColor.red, textColour: UIColor.black, action: {self.move.protectFlag = !self.move.protectFlag; self.updateView()})
		self.addSubview(protectButton, name: "protect")
		self.addConstraintSize(view: protectButton, height: 40, width: 100)
		magicButton = XGButton(title: "Magic Coat", colour: UIColor.red, textColour: UIColor.black, action: {self.move.magicCoatFlag = !self.move.magicCoatFlag; self.updateView()})
		self.addSubview(magicButton, name: "magic")
		self.addConstraintSize(view: magicButton, height: 40, width: 100)
		snatchButton = XGButton(title: "Snatch", colour: UIColor.red, textColour: UIColor.black, action: {self.move.snatchFlag = !self.move.snatchFlag; self.updateView()})
		self.addSubview(snatchButton, name: "snatch")
		self.addConstraintSize(view: snatchButton, height: 40, width: 100)
		mirrorButton = XGButton(title: "Mirror Move", colour: UIColor.red, textColour: UIColor.black, action: {self.move.mirrorMoveFlag = !self.move.mirrorMoveFlag; self.updateView()})
		self.addSubview(mirrorButton, name: "mirror")
		self.addConstraintSize(view: mirrorButton, height: 40, width: 100)
		kingsButton = XGButton(title: "King's Rock", colour: UIColor.red, textColour: UIColor.black, action: {self.move.kingsRockFlag = !self.move.kingsRockFlag; self.updateView()})
		self.addSubview(kingsButton, name: "kings")
		self.addConstraintSize(view: kingsButton, height: 40, width: 100)
		soundButton = XGButton(title: "Sound Based", colour: UIColor.red, textColour: UIColor.black, action: {self.move.soundBasedFlag = !self.move.soundBasedFlag; self.updateView()})
		self.addSubview(soundButton, name: "sound")
		self.addConstraintSize(view: soundButton, height: 40, width: 100)
		hmButton = XGButton(title: "HM", colour: UIColor.red, textColour: UIColor.black, action: {self.move.HMFlag = !self.move.HMFlag; self.updateView()})
		self.addSubview(hmButton, name: "hm")
		self.addConstraintSize(view: hmButton, height: 40, width: 100)
		
		animationButton = XGPopoverButton(title: "", colour: UIColor.orange, textColour: UIColor.black, popover: XGOriginalMovePopover(), viewController: self)
		self.addSubview(animationButton, name: "anim")
		self.addConstraintSize(view: animationButton, height: 40, width: 200)
		
		originalCopyButton = XGPopoverButton(title: "Original Moves", colour: UIColor.purple, textColour: UIColor.black, popover: XGOriginalMovePopover(), viewController: self)
		self.addSubview(originalCopyButton, name: "OCB")
		self.addConstraintSize(view: originalCopyButton, height: 50, width: 200)
		modifiedCopyButton = XGPopoverButton(title: "Modified Moves", colour: UIColor.purple, textColour: UIColor.black, popover: XGMovePopover(), viewController: self)
		self.addSubview(modifiedCopyButton, name: "MCB")
		self.addConstraintSize(view: modifiedCopyButton, height: 50, width: 200)
		
		saveButton = XGButton(title: "Save", colour: UIColor.blue, textColour: UIColor.black, action: {self.save()})
		self.addSubview(saveButton, name: "save")
		self.addConstraintSize(view: saveButton, height: 50, width: 200)
		
		self.createDummyViewsEqualWidths(6, baseName: "d")
		self.createDummyViewsEqualWidths(4, baseName: "e")
		self.createDummyViewsEqualWidths(5, baseName: "f")
		self.createDummyViewsEqualWidths(5, baseName: "g")
		self.createDummyViewsEqualWidths(4, baseName: "h")
		self.createDummyViewsEqualHeights(7, baseName: "v")
		
		self.addConstraintAlignTopAndBottomEdges(view1: startField, view2: indexField)
		self.addConstraintAlignTopAndBottomEdges(view1: startField, view2: nameField)
		self.addConstraints(visualFormat: "H:|-(>=0)-[index]-(50)-[name]-(50)-[start]-(>=0)-|", layoutFormat: [])
		self.addConstraints(visualFormat: "H:|[d1][priority][d2][pp][d3][power][d4][accuracy][d5][effectAccuracy][d6]|", layoutFormat: [.alignAllTop, .alignAllBottom])
		self.addConstraints(visualFormat: "H:|[e1][category][e2][type][e3][targets][e4]|", layoutFormat: [.alignAllTop, .alignAllBottom])
		self.addConstraints(visualFormat: "H:|[f1][contact][f2][protect][f3][magic][f4][snatch][f5]|", layoutFormat: [.alignAllTop, .alignAllBottom])
		self.addConstraints(visualFormat: "H:|[g1][mirror][g2][kings][g3][sound][g4][hm][g5]|", layoutFormat: [.alignAllTop, .alignAllBottom])
		self.addConstraints(visualFormat: "H:|[h1][OCB][h2][save][h3][MCB][h4]|", layoutFormat: [.alignAllTop, .alignAllBottom])
		self.addConstraints(visualFormat: "V:|-(5)-[name]-(5)-[desc]-(5)-[power][v1][effect][v7][anim][v2][type][v3][f3][v4][g3][v5][save][v6]|", layoutFormat: .alignAllCenterX)
		self.addConstraintAlignCenterX(view1: self.contentView, view2: nameField)
		
	}
	
	func updateView() {
		
		self.showActivityView{ (Bool) -> Void in
			
			self.startField.text = String(format: "\(self.move.startOffset) : 0x%x", self.move.startOffset)
			self.indexField.text = String(format: "\(self.move.moveIndex) : 0x%x", self.move.moveIndex)
			self.nameField.text  = self.move.name.string
			self.descField.text  = self.move.mdescription.string
			self.ppTextField.value = self.move.pp
			self.powerField.value = self.move.basePower
			self.accuracyField.value = self.move.accuracy
			self.effectAccuracyField.value = self.move.effectAccuracy
			self.effectButton.titleLabel?.text = XGMoveEffectPopover().effectList[self.move.effect]
			self.priorityField.value = self.move.priority <= 127 ? self.move.priority : (self.move.priority - 256)
			self.typeButton.setBackgroundImage(self.move.type.image, for: UIControlState())
			self.typeButton.titleLabel?.text = self.move.type.name
			self.categoryButton.text = self.move.category.string
			self.targetsButton.text = self.move.target.string
			self.contactButton.backgroundColor = self.move.contactFlag ? UIColor.green : UIColor.red
			self.protectButton.backgroundColor = self.move.protectFlag ? UIColor.green : UIColor.red
			self.magicButton.backgroundColor = self.move.magicCoatFlag ? UIColor.green : UIColor.red
			self.snatchButton.backgroundColor = self.move.snatchFlag ? UIColor.green : UIColor.red
			self.mirrorButton.backgroundColor = self.move.mirrorMoveFlag ? UIColor.green : UIColor.red
			self.kingsButton.backgroundColor = self.move.kingsRockFlag ? UIColor.green : UIColor.red
			self.soundButton.backgroundColor = self.move.soundBasedFlag ? UIColor.green : UIColor.red
			self.hmButton.backgroundColor = self.move.HMFlag ? UIColor.green : UIColor.red
			
			for i in 0 ..< self.animations.count {
				if self.move.animationID == self.animations[i] {
					let omove = XGOriginalMoves.move(i)
					self.animationButton.setBackgroundImage(omove.type.image, for: UIControlState())
					self.animationButton.titleLabel?.text = omove.name.string
				}
				
			}
			
			self.hideActivityView()
		}
		
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		var cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! XGTableViewCell!
		if cell == nil {
			cell = XGTableViewCell(style: .subtitle, reuseIdentifier: "cell")
		}
		
		if moveNames.count == 0 {
			cell?.backgroundColor = UIColor.black
			return cell!
		}
		
		let row = indexPath.row
		
		let name: String
		let type: XGMoveTypes
		let index: Int
		if searchController.isActive && searchController.searchBar.text != "" {
			name = filteredMoves[row].name.string
			type = filteredMoves[row].type
			index = filteredMoves[row].index
		} else {
			name = moveNames[row]
			type = moveTypes[row]
			index = row
		}
		
		cell?.title = name
		cell?.subtitle = String(format: "\(move.moveIndex) : 0x%x", move.moveIndex)
		cell?.background = type.image
		
		if type == XGMoveTypes.dark {
			cell?.textLabel?.textColor = UIColor.white
			cell?.detailTextLabel?.textColor = UIColor.white
		} else {
			cell?.textLabel?.textColor = UIColor.black
			cell?.detailTextLabel?.textColor = UIColor.black
		}
		
		cell?.textLabel?.backgroundColor = UIColor.clear
		cell?.detailTextLabel?.backgroundColor = UIColor.clear
		
		if XGMoves.move(index).isShadowMove {
			cell?.background = XGFiles.nameAndFolder("type_shadow.png", .Types).image
		}
		
		return cell!
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		self.currentIndexPath = indexPath
		let index: Int
		if searchController.isActive && searchController.searchBar.text != "" {
			index = filteredMoves[indexPath.row].index
		} else {
			index = indexPath.row
		}
		self.move = XGMove(index: index)
		self.updateView()
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if searchController.isActive && searchController.searchBar.text != "" {
			return filteredMoves.count
		}
		return kNumberOfMoves
	}
	
	override func popoverDidDismiss() {
		
		popoverPresenter.popover.dismiss(animated: true)
		
		if popoverPresenter == effectButton {
			
			self.move.effect = selectedItem as! Int
			
		} else if popoverPresenter == typeButton {
			
			self.move.type = selectedItem as! XGMoveTypes
			
		} else if popoverPresenter == originalCopyButton {
			
			let move = selectedItem as! XGOriginalMoves
			let byteCopier = XGByteCopier(copyFile: .original(.common_rel), copyOffset: move.startOffset, length: kSizeOfMoveData, targetFile: .common_rel, targetOffset: self.move.startOffset)
			let popover = XGByteCopyPopover(copier: byteCopier)
			let popButton = XGPopoverButton(title: "", colour: UIColor.clear, textColour: UIColor.clear, popover: popover, viewController: self)
			popButton.alpha = 0
			self.addSubview(popButton, name: "OPB")
			self.addConstraintAlignAllEdges(view1: self.originalCopyButton, view2: popButton)
			popButton.action()
			self.move.save()
			
		} else if popoverPresenter == views["OPB"] {
			
			popoverPresenter.removeFromSuperview()
			self.move = XGMove(index: self.move.moveIndex)
			
		} else if popoverPresenter == modifiedCopyButton {
			
			let move = selectedItem as! XGMoves
			let byteCopier = XGByteCopier(copyFile: .common_rel, copyOffset: move.startOffset, length: kSizeOfMoveData, targetFile: .common_rel, targetOffset: self.move.startOffset)
			let popover = XGByteCopyPopover(copier: byteCopier)
			let popButton = XGPopoverButton(title: "", colour: UIColor.clear, textColour: UIColor.clear, popover: popover, viewController: self)
			popButton.alpha = 0
			self.addSubview(popButton, name: "MPB")
			self.addConstraintAlignAllEdges(view1: self.modifiedCopyButton, view2: popButton)
			popButton.action()
			self.move.save()
			
		} else if popoverPresenter == views["MPB"] {
			
			popoverPresenter.removeFromSuperview()
			self.move = XGMove(index: self.move.moveIndex)
			
		} else if popoverPresenter == self.animationButton {
			let index = (selectedItem as! XGOriginalMoves).index
			self.move.animationID = animations[index]
			self.move.animation2ID = self.move.animationID - (self.move.animationID < 0x164 ? 0 : 1)
		}
		
		self.updateView()
	}
	
	func save() {
		self.showActivityView{ (Bool) -> Void in
			self.move.save()
			
			self.moveTypes[self.move.moveIndex] = self.move.type
			self.moveNames[self.move.moveIndex] = self.move.name.string
			
			self.table.reloadRows(at: [self.currentIndexPath], with: .fade)
			self.table.selectRow(at: self.currentIndexPath, animated: false, scrollPosition: .none)
			
			self.hideActivityView()
		}
	}
	
}




















