//
//  pokemonTableViewController.swift
//  Mausoleum Tool
//
//  Created by StarsMmd on 22/10/2014.
//  Copyright (c) 2014 Steezy. All rights reserved.
//

import UIKit

class XGOriginalPokemonPopover: XGPopover, UISearchResultsUpdating, UISearchBarDelegate {
	
	let searchController = UISearchController(searchResultsController: nil)
	var pokes = [(name: String,type1: String,type2: String,index:Int)]()
	var filteredPokes = [(name: String,type1: String,type2: String,index:Int)]()
	
	override init() {
		super.init()
		
		var typeNames = [String]()
		for i in 0..<kNumberOfTypes {
			typeNames.append(XGMoveTypes(rawValue: i)!.name)
		}
		
		for i in 0 ..< kNumberOfPokemon {
			let mon = XGOriginalPokemon.pokemon(i)
			pokes.append( (mon.name,typeNames[mon.type1.rawValue],typeNames[mon.type2.rawValue],i))
		}
		
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
			filteredPokes = pokes.filter { (poke:(name: String,type1: String,type2: String,index:Int)) in
				let wantedInfo: String
				if scope == "Type" {
					wantedInfo = poke.type1 + poke.type2
				} else {
					wantedInfo = poke.name
				}
				return wantedInfo.simplified.contains(searchText.simplified)
			}
		}
		
		self.tableView.reloadData()
	}
	
	func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
		filterContentForSearchText(textAndScope: [searchBar.text!, searchBar.scopeButtonTitles![selectedScope]])
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if searchController.isActive && searchController.searchBar.text != "" {
			return filteredPokes.count
		}
		return kNumberOfPokemon
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = dequeueCell()
		
		let poke: XGOriginalPokemon
		if searchController.isActive && searchController.searchBar.text != "" {
			let index = filteredPokes[indexPath.row].index
			poke = XGOriginalPokemon.pokemon(index)
		} else {
			poke = XGOriginalPokemon.pokemon(indexPath.row)
		}
		
		cell.title		= poke.name
		cell.background = poke.type1.image
		
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let poke: XGOriginalPokemon
		if searchController.isActive && searchController.searchBar.text != "" {
			let index = filteredPokes[indexPath.row].index
			poke = XGOriginalPokemon.pokemon(index)
		} else {
			poke = XGOriginalPokemon.pokemon(indexPath.row)
		}
		delegate.selectedItem = poke as Any
		delegate.popoverDidDismiss()
	}
	
}
