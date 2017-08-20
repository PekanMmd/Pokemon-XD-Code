//
//  moveTypeTableViewController.swift
//  Mausoleum Stats Tool
//
//  Created by The Steez on 12/01/2015.
//  Copyright (c) 2015 Ovation International. All rights reserved.
//

import UIKit

class XGTypePopover: XGPopover, UISearchResultsUpdating {
	
	let searchController = UISearchController(searchResultsController: nil)
	var filteredTypes = [XGMoveTypes]()
	
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
			filteredTypes = XGMoveTypes.allTypes.filter { type in
				return type.name.lowercased().contains(searchText.lowercased())
			}
		}
		
		self.tableView.reloadData()
	}
	
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if searchController.isActive && searchController.searchBar.text != "" {
			return filteredTypes.count
		}
		return kNumberOfTypes
	}
	
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = dequeueCell()
		
		let type: XGMoveTypes
		if searchController.isActive && searchController.searchBar.text != "" {
			type = filteredTypes[indexPath.row]
		} else {
			type = XGMoveTypes(rawValue: indexPath.row) ?? .normal
		}
		
		cell.title = type.name
		cell.background = type.image
		cell.textLabel?.textAlignment = .center
		
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let type: XGMoveTypes
		if searchController.isActive && searchController.searchBar.text != "" {
			type = filteredTypes[indexPath.row]
		} else {
			type = XGMoveTypes(rawValue: indexPath.row) ?? .normal
		}
		delegate.selectedItem = type as Any
		delegate.popoverDidDismiss()
	}
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 100
	}
	
}


















