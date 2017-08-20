//
//  XGDDPKPopover.swift
//  XG Tool
//
//  Created by The Steez on 31/07/2015.
//  Copyright (c) 2015 Ovation International. All rights reserved.
//

import UIKit

class XGDDPKPopover: XGPopover, UISearchResultsUpdating, UISearchBarDelegate {
	
	var deck = XGDecks.DeckDarkPokemon
	
	let searchController = UISearchController(searchResultsController: nil)
	var filteredDeckPokes = [XGDeckPokemon]()
	
	override init() {
		super.init()
		
		searchController.searchResultsUpdater = self
		searchController.dimsBackgroundDuringPresentation = false
		definesPresentationContext = true
		self.tableView.tableHeaderView = searchController.searchBar
		searchController.searchBar.scopeButtonTitles = ["Name", "Type"]
		searchController.searchBar.delegate = self
	}
	
	required init!(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
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
			var allPokes: [XGDeckPokemon] = []
			for i in 0 ..< deck.DDPKEntries {
				allPokes.append(XGDeckPokemon.ddpk(i))
			}
			filteredDeckPokes = allPokes.filter { dpoke in
				let poke = dpoke.pokemon
				
				let wantedInfo: String
				if scope == "Type" {
					wantedInfo = poke.type1.name + poke.type2.name
				} else {
					wantedInfo = poke.name.string
				}
				
				return wantedInfo.lowercased().contains(searchText.lowercased())
			}
		}
		
		self.tableView.reloadData()
	}
	
	func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
		filterContentForSearchText(textAndScope: [searchBar.text!, searchBar.scopeButtonTitles![selectedScope]])
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if searchController.isActive && searchController.searchBar.text != "" {
			return filteredDeckPokes.count
		}
		return deck.DDPKEntries
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = dequeueCell()
		
		let dpoke: XGDeckPokemon
		if searchController.isActive && searchController.searchBar.text != "" {
			dpoke = filteredDeckPokes[indexPath.row]
		} else {
			dpoke = XGDeckPokemon.ddpk(indexPath.row)
		}
		let poke  = dpoke.pokemon
		
		cell.title		= "\(indexPath.row): " + poke.name.string + " - Lv. \(dpoke.level)"
		cell.background = poke.type1.image
		cell.picture	= poke.face
		
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let dpoke: XGDeckPokemon
		if searchController.isActive && searchController.searchBar.text != "" {
			dpoke = filteredDeckPokes[indexPath.row]
		} else {
			dpoke = XGDeckPokemon.ddpk(indexPath.row)
		}
		delegate.selectedItem = dpoke as Any
		delegate.popoverDidDismiss()
	}
	
}













