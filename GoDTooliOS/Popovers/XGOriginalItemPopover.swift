//
//  XGOriginalItemPopover.swift
//  XG Tool
//
//  Created by The Steez on 25/06/2015.
//  Copyright (c) 2015 Ovation International. All rights reserved.
//

import UIKit

class XGOriginalItemPopover: XGPopover, UISearchResultsUpdating, UISearchBarDelegate {
	
	let searchController = UISearchController(searchResultsController: nil)
	var filteredItems = [XGOriginalItems]()
	
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
		self.perform(#selector(filterContentForSearchText), with: text, afterDelay: 0.3)
	}
	
	func filterContentForSearchText(searchText: String) {
		if searchText.characters.count > 0 {
			filteredItems = allOriginalItemsArray().filter { item in
				let itemName = item.name.string
				return itemName.lowercased().contains(searchText.lowercased())
			}
		}
		
		self.tableView.reloadData()
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if searchController.isActive && searchController.searchBar.text != "" {
			return filteredItems.count
		}
		return kNumberOfItems
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = dequeueCell()
		
		if searchController.isActive && searchController.searchBar.text != "" {
			cell.title = filteredItems[indexPath.row].name.string
		} else {
			cell.title = XGOriginalItems.item(indexPath.row).name.string
		}
		
		cell.background = UIImage(named: "Item Cell")!
		
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let item: XGOriginalItems
		if searchController.isActive && searchController.searchBar.text != "" {
			let i = filteredItems[indexPath.row].index
			item = XGOriginalItems.item(i)
		} else {
			item = XGOriginalItems.item(indexPath.row)
		}
		delegate.selectedItem = item as Any
		delegate.popoverDidDismiss()
	}
	
}
