//
//  XGOriginalMovePopover.swift
//  XG Tool
//
//  Created by StarsMmd on 01/06/2015.
//  Copyright (c) 2015 StarsMmd. All rights reserved.
//

import UIKit

class XGOriginalMovePopover: XGPopover, UISearchResultsUpdating, UISearchBarDelegate {
	
	var moves = [(String,Int,Int,Bool)]()
	var filteredMoves = [(String,Int,Int,Bool)]()
	
	let searchController = UISearchController(searchResultsController: nil)
	
	override init() {
		super.init()
		
		searchController.searchResultsUpdater = self
		searchController.dimsBackgroundDuringPresentation = false
		definesPresentationContext = true
		self.tableView.tableHeaderView = searchController.searchBar
		searchController.searchBar.scopeButtonTitles = ["Name", "Type"]
		searchController.searchBar.delegate = self
		
		let data  = XGFiles.original(.common_rel).data
		let table = XGFiles.original(.common_rel).stringTable
		
		var offset = Common_relIndices.Moves.startOffset()
		
		for i in 0 ..< kNumberOfMoves {
			
			let nameID = data.get2BytesAtOffset(offset + kMoveNameIDOffset)
			let name = table.stringSafelyWithID(nameID).string
			
			let type = data.getByteAtOffset(offset + kMoveTypeOffset)
			let isShadow = data.getByteAtOffset(offset + kHMFlagOffset) == 1
			
			moves.append((name,type,i,isShadow))
			
			offset += kSizeOfMoveData
		}
		
		
		moves.sort{
			if ($0.2 == 0) {return true};
			if ($1.2 == 0) {return false};
			if $0.3 {
				return $1.3 ? $0.0 < $1.0 : false
			};
			if $1.3 {
				return $0.3 ? $0.0 < $1.0 : true
			};
			if ($0.1 == $1.1) {
				return $0.0 < $1.0
			};
			return $0.1 < $1.1
		}
		
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
				let wantedInfo = (scope == "Type") ? XGOriginalMoves.move(move.2).type.name : move.0
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
		return kNumberOfMoves
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = dequeueCell()
		
		let move: (String, Int, Int, Bool)
		if searchController.isActive && searchController.searchBar.text != "" {
			move = filteredMoves[indexPath.row]
		} else {
			move = moves[indexPath.row]
		}
		
		cell.title = move.0
		cell.background = XGMoveTypes(rawValue: move.1)!.image
		
		if moves[indexPath.row].3 {
			cell.background = XGFiles.nameAndFolder("type_shadow.png", .Types).image
		}
		
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		var index: Int
		if searchController.isActive && searchController.searchBar.text != "" {
			index = filteredMoves[indexPath.row].2
		} else {
			index = moves[indexPath.row].2
		}
		delegate.selectedItem = XGOriginalMoves.move(index) as Any
		delegate.popoverDidDismiss()
	}
	
}
