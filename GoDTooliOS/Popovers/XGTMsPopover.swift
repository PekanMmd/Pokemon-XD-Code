//
//  XGTMsPopover.swift
//  XG Tool
//
//  Created by StarsMmd on 25/08/2015.
//  Copyright (c) 2015 StarsMmd. All rights reserved.
//

import UIKit

class XGTMsPopover: XGPopover, UISearchResultsUpdating, UISearchBarDelegate {
	
	var moves = [XGMoves]()
	var stats = XGPokemonStats(index: 0)
	
	let searchController = UISearchController(searchResultsController: nil)
	var filteredMoves = [XGMoves]()
	
	override init() {
		super.init()
		
		for i in 1 ... kNumberOfTMs {
			
			moves.append(XGTMs.tm(i).move)
		}
		
		searchController.searchResultsUpdater = self
		searchController.dimsBackgroundDuringPresentation = false
		definesPresentationContext = true
		self.tableView.tableHeaderView = searchController.searchBar
		searchController.searchBar.scopeButtonTitles = ["Name", "Type"]
		searchController.searchBar.delegate = self
		
	}
	
	convenience init(stats: XGPokemonStats) {
		self.init()
		self.stats = stats
		self.tableView.reloadData()
	}
	
	required init!(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
		// Custom initialization
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
			filteredMoves = moves.filter { move in
				let wantedInfo: String
				if scope == "Name" {
					wantedInfo = move.name.string
				} else {
					wantedInfo = move.type.name
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
			return filteredMoves.count
		}
		return kNumberOfTMs
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = dequeueCell()
		
		let move: XGMoves
		if searchController.isActive && searchController.searchBar.text != "" {
			move = filteredMoves[indexPath.row]
		} else {
			move = moves[indexPath.row]
		}
		
		cell.title = move.name.string
		cell.background = move.type.image
		cell.picture = stats.learnableTMs[indexPath.row] ? UIImage(named: "ball red") : UIImage(named: "ball grey")
		
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		stats.learnableTMs[indexPath.row] = !stats.learnableTMs[indexPath.row]
		self.tableView.reloadRows(at: [indexPath], with: .fade)
	}
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 50
	}
	
}




