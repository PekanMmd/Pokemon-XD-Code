//
//  XGTMViewController.swift
//  XG Tool
//
//  Created by The Steez on 07/08/2015.
//  Copyright (c) 2015 Ovation International. All rights reserved.
//

import UIKit

class XGTMViewController: XGTableViewController, UISearchResultsUpdating, UISearchBarDelegate {
	
	var currentMove = XGTMs.tm(1).move
	
	var name = XGTextField()
	var location = XGTextField()
	var move = XGPopoverButton()
	
	var saveButton = XGButton()
	
	let searchController = UISearchController(searchResultsController: nil)
	var filteredTMs = [XGTMs]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		searchController.searchResultsUpdater = self
		searchController.dimsBackgroundDuringPresentation = false
		definesPresentationContext = true
		self.table.tableHeaderView = searchController.searchBar
		searchController.searchBar.scopeButtonTitles = ["Name", "Type", "Location"]
		searchController.searchBar.delegate = self
		
		self.name = XGTextField(title: "", text: "", height: 100, width: 200, action: {  })
		self.name.isUserInteractionEnabled = false
		self.addSubview(name, name: "name")
		
		self.location = XGTextField(title: "", text: "", height: 100, width: 200, action: {  })
		self.location.isUserInteractionEnabled = false
		self.addSubview(location, name: "loc")
		
		self.move = XGPopoverButton(title: "", colour: UIColor.clear, textColour: UIColor.black, popover: XGMovePopover(), viewController: self)
		self.addSubview(move, name: "move")
		self.addConstraintSize(view: self.move, height: 100, width: 200)
		
		self.saveButton = XGButton(title: "Save", colour: UIColor.blue, textColour: UIColor.white, action: { self.save() })
		self.addSubview(saveButton, name: "save")
		self.addConstraintSize(view: self.saveButton, height: 100, width: 200)
		
		self.createDummyViewsEqualWidths(3, baseName: "h")
		self.createDummyViewsEqualHeights(4, baseName: "v")
		
		self.addConstraints(visualFormat: "H:|[h1][name][h2][loc][h3]|", layoutFormat: [.alignAllTop, .alignAllBottom])
		self.addConstraints(visualFormat: "V:|[v1][h2][v2][move][v3][save][v4]|", layoutFormat: .alignAllCenterX)
		
		
		self.update()
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
			filteredTMs = allTMsArray().filter { tm in
				let wantedInfo: String
				if scope == "Name" {
					wantedInfo = tm.move.name.string
				}
				else if scope == "Type" {
					wantedInfo = tm.move.type.name
				}
				else {
					wantedInfo = tm.location
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
	
	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		self.table.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
		self.table.reloadData()
	}
	
	func update() {
		self.showActivityView { (Bool) -> Void in
			
			let tm = XGTMs.tm(self.currentIndexPath.row + 1)
			
			self.name.text = tm.item.name.string
			self.location.text = tm.location
			self.move.textLabel.text = self.currentMove.name.string
			self.move.setBackgroundImage(self.currentMove.type.image, for: UIControlState())
			
			self.hideActivityView()
		}
		
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		var cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! XGTableViewCell!
		if cell == nil {
			cell = XGTableViewCell(style: .subtitle, reuseIdentifier: "cell")
		}
		
		
		let tm: XGTMs
		if searchController.isActive && searchController.searchBar.text != "" {
			tm = filteredTMs[indexPath.row]
		} else {
			tm = XGTMs.tm(indexPath.row + 1)
		}
		
		cell?.title = tm.move.name.string
		cell?.subtitle = tm.location
		cell?.background = tm.move.type.image
		
		return cell!
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		self.currentIndexPath = indexPath
		if searchController.isActive && searchController.searchBar.text != "" {
			let i = filteredTMs[indexPath.row].index
			self.currentMove = XGTMs.tm(i).move
		} else {
			self.currentMove = XGTMs.tm(indexPath.row + 1).move
		}
		
		self.update()
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if searchController.isActive && searchController.searchBar.text != "" {
			return filteredTMs.count
		}
		return kNumberOfTMs
	}
	
	override func popoverDidDismiss() {
		if self.popoverPresenter == self.move {
			self.currentMove = self.selectedItem as! XGMoves
			self.move.popover.dismiss(animated: true)
			self.update()
		}
	}
	
	func save() {
		self.showActivityView { (Bool) -> Void in
			
			XGTMs.tm(self.currentIndexPath.row + 1).replaceWithMove(self.currentMove)
			
			self.table.reloadRows(at: [self.currentIndexPath], with: .fade)
			self.table.selectRow(at: self.currentIndexPath, animated: false, scrollPosition: .none)
			
			self.hideActivityView()
		}
	}
	
	
}



















