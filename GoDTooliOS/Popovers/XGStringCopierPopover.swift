//
//  XGStringCopierPopover.swift
//  XG Tool
//
//  Created by The Steez on 29/06/2015.
//  Copyright (c) 2015 Ovation International. All rights reserved.
//

import UIKit

class XGStringCopierPopover: XGPopover {

	var strings = [XGUnicodeCharacters]()
	
	required init!(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
		// Custom initialization
	}
	
	override init() {
		super.init()
		
		var ch = XGSpecialCharacters.newLine
		strings.append(ch.unicode)
		
		ch = .clearWindow
		strings.append(ch.unicode)
		
		ch = .dialogueEnd
		strings.append(ch.unicode)
		
		ch = .pause
		strings.append(ch.unicode)
		
		ch = .player13
		strings.append(ch.unicode)
		
		ch = .playerInField
		strings.append(ch.unicode)
		
		ch = .setSpeaker
		strings.append(ch.unicode)
		
		ch = .speaker
		strings.append(ch.unicode)
		
		for i in 0 ..< kNumberOfPredefinedFontColours {
			let ft = XGFontColours(rawValue: i)!
			strings.append(ft.unicode)
		}
		
		for i in 0 ..< kNumberOfSpecifiedFontColours {
			let ft = XGRGBAFontColours(rawValue: i)!
			strings.append(ft.unicode)
		}
	
		tableView.reloadData()
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return strings.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = dequeueCell()
		
		cell.title = strings[indexPath.row].name
		cell.background = UIImage(named: "Item Cell")!
		
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		XGString(string: strings[indexPath.row].string, file: nil, sid: nil).copyString()
		delegate.popoverDidDismiss()
	}

}















