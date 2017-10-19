//
//  movesTableViewController.swift
//  Mausoleum Tool
//
//  Created by StarsMmd on 03/11/2014.
//  Copyright (c) 2014 Steezy. All rights reserved.
//

import UIKit

class XGMovePopover: XGPopover, UISearchResultsUpdating, UISearchBarDelegate {
	
	var moves = [(name: String,type: Int,index: Int,isShadow: Bool)]()
	var filteredMoves = [(name: String,type: Int,index: Int,isShadow: Bool)]()
	var typeNames = [String]()
	
	let searchController = UISearchController(searchResultsController: nil)
	
	override init() {
		super.init()
		
		searchController.searchResultsUpdater = self
		searchController.dimsBackgroundDuringPresentation = false
		definesPresentationContext = true
		self.tableView.tableHeaderView = searchController.searchBar
		searchController.searchBar.scopeButtonTitles = ["Name", "Type"]
		searchController.searchBar.delegate = self
		
		let data = XGFiles.common_rel.data
		let table = XGFiles.common_rel.stringTable
		
		var offset = CommonIndexes.Moves.startOffset()
		
		for i in 0 ..< kNumberOfMoves {
			
			let nameID = data.get2BytesAtOffset(offset + kMoveNameIDOffset)
			let name = table.stringSafelyWithID(nameID).string
			
			let type = data.getByteAtOffset(offset + kMoveTypeOffset)
			let isShadow = data.getByteAtOffset(offset + kHMFlagOffset) == 1
			
			moves.append((name,type,i,isShadow))
			
			offset += kSizeOfMoveData
		}
		
		moves = moves.filter { (m:(name: String,type: Int,index: Int,isShadow: Bool)) -> Bool in
			return m.name != "*" && m.name != "--"
		}
		
		moves = moves.filter { (m:(name: String,type: Int,index: Int,isShadow: Bool)) -> Bool in
			return m.name != "-" || m.index == 0 || m.index == 356
		}
		
		
		moves.sort{
			if ($0.index == 0) {return true};
			if ($1.index == 0) {return false};
			if $0.isShadow {
				return $1.isShadow ? $0.name < $1.name : false
			};
			if $1.isShadow {
				return $0.isShadow ? $0.name < $1.name : true
			};
			if ($0.type == $1.type) {
				return $0.name < $1.name
			};
			return $0.type < $1.type
		}
		
		for i in 0 ..< kNumberOfTypes {
			typeNames.append(XGMoveTypes(rawValue: i)!.name)
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
				let wantedInfo = (scope == "Type") ? typeNames[move.type] : move.name
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
			return filteredMoves.count
		}
		return moves.count
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
			cell.background = UIImage(contentsOfFile: XGFolders.Types.path + "/type_shadow.png")!
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
		delegate.selectedItem = XGMoves.move(index) as Any
		delegate.popoverDidDismiss()
	}
	
}












