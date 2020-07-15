//
//  GoDTableViewDelegate.swift
//  GoD Tool
//
//  Created by StarsMmd on 01/07/2016.
//  Copyright © 2016 StarsMmd. All rights reserved.
//

import AppKit

protocol GoDTableViewDelegate: NSTableViewDelegate {
	
	func tableView(_ tableView: GoDTableView, didSelectRow row: Int)
}

enum GoDSearchBarBehaviour {
	case none, onTextChange, onEndEditing
}

protocol GoDTableViewDataSource: NSTableViewDataSource {

	func searchBarBehaviourForTableView(_ tableView: GoDTableView) -> GoDSearchBarBehaviour
	func tableView(_ tableView: GoDTableView, didSearchForText text: String)
}

extension GoDTableViewDataSource {

	func tableView(_ tableView: GoDTableView, didSearchForText text: String) {}
	func searchBarBehaviourForTableView(_ tableView: GoDTableView) -> GoDSearchBarBehaviour {
		.none
	}
}
