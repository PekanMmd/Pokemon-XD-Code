//
//  itemTableViewController.swift
//  Mausoleum Tool
//
//  Created by StarsMmd on 03/11/2014.
//  Copyright (c) 2014 Steezy. All rights reserved.
//

import UIKit

class XGAbilityPopover: XGPopover, UISearchResultsUpdating {
	
	var abilities = [XGAbilities]()
	var filteredAbilities = [XGAbilities]()
	
	let searchController = UISearchController(searchResultsController: nil)
	
	override init() {
		super.init()
		
		searchController.searchResultsUpdater = self
		searchController.dimsBackgroundDuringPresentation = false
		definesPresentationContext = true
		self.tableView.tableHeaderView = searchController.searchBar
		
		for i in 0 ..< (kNumberOfAbilities + 1) {
			self.abilities.append( .ability(i) )
		}
		
		abilities.sort{ $0.name.string < $1.name.string }
		abilities = abilities.filter { (ab) -> Bool in
			return (ab.name.string != "-") || (ab.index == 0)
		}
	}
	
	required init!(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
	}
	
	func updateSearchResults(for searchController: UISearchController) {
		let text = searchController.searchBar.text!
		NSObject.cancelPreviousPerformRequests(withTarget: self)
		self.perform(#selector(filterContentForSearchText), with: text, afterDelay: 0.3)
	}
	
	func filterContentForSearchText(searchText: String) {
		if searchText.characters.count > 0 {
			filteredAbilities = abilities.filter { ability in
				let abilityName = ability.name.string
				return abilityName.lowercased().contains(searchText.lowercased())
			}
		}
		
		self.tableView.reloadData()
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if searchController.isActive && searchController.searchBar.text != "" {
			return filteredAbilities.count
		}
		return abilities.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = dequeueCell()
		
		if searchController.isActive && searchController.searchBar.text != "" {
			cell.title = filteredAbilities[indexPath.row].name.string
		} else {
			cell.title = abilities[indexPath.row].name.string
		}
		cell.background = XGResources.png("Item Cell").image
		
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let ability: XGAbilities
		if searchController.isActive && searchController.searchBar.text != "" {
			ability = filteredAbilities[indexPath.row]
		} else {
			ability = abilities[indexPath.row]
		}
		delegate.selectedItem = ability as Any
		delegate.popoverDidDismiss()
	}
	
	
}
