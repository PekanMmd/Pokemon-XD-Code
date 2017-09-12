//
//  GoDTableViewDelegate.swift
//  GoD Tool
//
//  Created by StarsMmd on 01/07/2016.
//  Copyright © 2016 StarsMmd. All rights reserved.
//

import AppKit

protocol GoDTableViewDelegate : NSTableViewDelegate {
	
	func tableView(_ tableView: GoDTableView, didSelectRow row: Int)
	
}
