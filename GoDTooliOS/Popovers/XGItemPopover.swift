//
//  itemTableViewController.swift
//  Mausoleum Tool
//
//  Created by The Steez on 03/11/2014.
//  Copyright (c) 2014 Steezy. All rights reserved.
//

import UIKit

class XGItemPopover: XGPopover, UISearchResultsUpdating {
	
	let searchController = UISearchController(searchResultsController: nil)
	let itemsArray = allItemsArray().filter { (i) -> Bool in
		let itemName = i.name.string
		return ((itemName != "-") || (i.index == 0)) && (i.index < 339)
	}.sorted { (i1, i2) -> Bool in
		return i1.name.string < i2.name.string
	}
	var filteredItems = [XGItems]()
	
	override init() {
		super.init()
		
		searchController.searchResultsUpdater = self
		searchController.dimsBackgroundDuringPresentation = false
		definesPresentationContext = true
		self.tableView.tableHeaderView = searchController.searchBar
	}
	
	required init!(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	func updateSearchResults(for searchController: UISearchController) {
		let text = searchController.searchBar.text!
		NSObject.cancelPreviousPerformRequests(withTarget: self)
		self.perform(#selector(filterContentForSearchText), with: text, afterDelay: 1.0)
	}
	
	func filterContentForSearchText(searchText: String) {
		if searchText.characters.count > 0 {
			let search = searchText.simplified
			filteredItems = itemsArray.filter { item in
				let itemName = item.name.string
				return itemName.simplified.contains(search)
			}
		}
		
		self.tableView.reloadData()
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if searchController.isActive && searchController.searchBar.text != "" {
			return filteredItems.count
		}
		return itemsArray.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = dequeueCell()
		
		let item = (searchController.isActive && searchController.searchBar.text != "") ? filteredItems[indexPath.row] : itemsArray[indexPath.row]
		
		cell.title = item.name.string
		
		cell.background = UIImage(named: "Item Cell")!
		
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let item: XGItems
		if searchController.isActive && searchController.searchBar.text != "" {
			item = filteredItems[indexPath.row]
		} else {
			item = itemsArray[indexPath.row]
		}
		delegate.selectedItem = item as Any
		delegate.popoverDidDismiss()
	}
	
}
