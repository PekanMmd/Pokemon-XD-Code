//
//  XGStringSearchViewController.swift
//  XG Tool
//
//  Created by The Steez on 22/05/2015.
//  Copyright (c) 2015 Ovation International. All rights reserved.
//

import UIKit
import Darwin

class XGStringSearchViewController: XGTableViewController {
	
	var stringTables = [XGStringTable]()
	
	var results = [XGString(string: "Search Results Appear Here.", file: nil, sid: nil)]
	
	var selectedString = XGString(string: "", file: nil, sid: nil)
	
	var filePickerButton = XGPopoverButton()
	
	var searchBar = XGTextField()
	var replaceBar = XGTextField()
	var resultsBox = UITextView()
	
	var resultsTable : UITableView {
		get {
			return self.table
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.loadStringTables()
		self.setUpUI()
		
	}
	
	func setUpUI() {
		
		self.title = "String Table Reader"
		
		view.backgroundColor = UIColor.orange
		
		searchBar = XGTextField(title: "Search ID or String", text: "", height: 60, width: 300, action: {})
		self.addSubview(searchBar, name: "sbar")
		
		replaceBar = XGTextField(title: "Replacement String", text: "", height: 60, width: 300, action: {})
		self.addSubview(replaceBar, name: "rbar")
		
		resultsBox.backgroundColor = UIColor.black
		resultsBox.textColor = UIColor.orange
		resultsBox.layer.cornerRadius = 10
		resultsBox.clipsToBounds = true
		resultsBox.font = UIFont(name: "Helvetica", size: 30)
		resultsBox.isScrollEnabled = true
		resultsBox.bounces = true
		resultsBox.translatesAutoresizingMaskIntoConstraints = false
		self.addSubview(resultsBox, name: "rbox")
		
		let searchButton = XGButton(title: "Search for ID", colour: UIColor.blue, textColour: UIColor.white, action: {self.searchID()})
		self.addSubview(searchButton, name: "sbut")
		
		let searchSubButton = XGButton(title: "Search for String", colour: UIColor.blue, textColour: UIColor.white, action: {self.searchForSubstring()})
		self.addSubview(searchSubButton, name: "ssbut")
		
		let replaceButton = XGButton(title: "Replace substring", colour: UIColor.red, textColour: UIColor.white, action: {self.replaceOccurences()})
		self.addSubview(replaceButton, name: "rbut")
		
		let replaceTextButton = XGButton(title: "Replace text", colour: UIColor.red, textColour: UIColor.white, action: {self.replace()})
		self.addSubview(replaceTextButton, name: "rtbut")
		
		let replaceAllButton = XGButton(title: "Replace All", colour: UIColor.red, textColour: UIColor.white, action: {self.replaceAllOccurences()})
		self.addSubview(replaceAllButton, name: "rabut")
		
		let filePicker = XGFilePickerPopover(folder: .StringTables)
		filePicker.files = [.dol,.common_rel,.tableres2] + filePicker.files
		filePickerButton = XGPopoverButton(title: "Search File", colour: UIColor.blue, textColour: UIColor.white, popover: filePicker, viewController: self)
		self.addSubview(filePickerButton, name: "fb")
		
		let specialsButton = XGPopoverButton(title: "Special Characters", colour: UIColor.green, textColour: UIColor.white, popover: XGStringCopierPopover(), viewController: self)
		self.addSubview(specialsButton, name: "spb")
		
		let saveButton = XGButton(title: "Save", colour: UIColor.green, textColour: UIColor.white, action: {
			self.save()
		})
		self.addSubview(saveButton, name: "save")
		
		self.createDummyViewsEqualWidths(3, baseName: "h")
		self.createDummyViewsEqualWidths(4, baseName: "i")
		self.createDummyViewsEqualWidths(4, baseName: "j")
		self.createDummyViewsEqualWidths(3, baseName: "g")
		self.createDummyViewsEqualHeights(4, baseName: "k")
		
		self.addConstraints(visualFormat: "H:[rbox(700)]", layoutFormat: [])
		self.addConstraints(visualFormat: "H:|[h1][sbar][h2][rbar][h3]|", layoutFormat: [.alignAllTop, .alignAllBottom])
		self.addConstraints(visualFormat: "H:|[i1][sbut(200)][i2][ssbut(200)][i3][fb(200)][i4]|", layoutFormat: [.alignAllTop, .alignAllBottom])
		self.addConstraints(visualFormat: "H:|[j1][rtbut(200)][j2][rbut(200)][j3][rabut(200)][j4]|", layoutFormat: [.alignAllTop, .alignAllBottom])
		self.addConstraints(visualFormat: "H:|[g1][spb(250)][g2][save(250)][g3]|", layoutFormat: [.alignAllTop, .alignAllBottom])
		self.addConstraintAlignCenterX(view1: self.contentView, view2: resultsBox)
		self.addConstraints(visualFormat: "V:|-(20)-[rbox(200)]-(10)-[h2][k1][ssbut(80)][k2][rbut(80)][k3][g2(80)][k4]|", layoutFormat: .alignAllCenterX)
		
	}
	
	func loadStringTables() {
		
		self.showActivityView { (Bool) -> Void in
			
			self.stringTables = [XGStringTable]()
			
			let stringTable1 = XGFiles.common_rel.stringTable
			let stringTable2 = XGFiles.tableres2.stringTable
			let stringTable3 = XGFiles.dol.stringTable
			
			self.stringTables = [stringTable1, stringTable2, stringTable3]
			
			XGFolders.StringTables.map{ (file: XGFiles) -> Void in
				self.stringTables.append(file.stringTable)
			}
			self.hideActivityView()
		}
	}
	
	func reloadTable(_ scrollToTop: Bool) {
		
		self.showActivityView{ (Bool) -> Void in
			self.resultsTable.reloadData()
			if scrollToTop {
				self.resultsTable.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
			}
			self.hideActivityView()
		}
	}
	
	func searchID() {
		
		self.showActivityView{ (Bool) -> Void in
			
			self.results = [self.searchStringIDInAllTables(self.searchBar.text)]
			self.searchBar.resignFirstResponder()
			self.reloadTable(true)
			
			self.hideActivityView()
		}
	}
	
	func searchStringID(_ sid: String, inTable table: XGStringTable) -> XGString? {
		
		return table.stringWithID(hexStringToInt(sid))
		
	}
	
	func searchStringIDInAllTables(_ sid: String) -> XGString {
		
		let id = hexStringToInt(sid)
		
		for table in self.stringTables {
			if table.containsStringWithId(id) {
				
				return table.stringWithID(id)!
				
			}
		}
		
		return XGString(string: "No strings were found with id: \(sid).", file: nil, sid: nil)
		
	}
	
	func hexStringToInt(_ hex: String) -> Int {
		
		return Int(strtoul(hex, nil, 16)) // converts hex string to uint and then cast as Int
		
	}
	
	func getAllStringsFromTable(_ table: XGStringTable) {
		
		self.showActivityView{ (Bool) -> Void in
			self.results = table.allStrings()
			
			self.hideActivityView()
		}
	}
	
	func arrayOfAllString() -> [XGString] {
		
		var r = [XGString]()
		for table in self.stringTables {
			let s = table.allStrings()
			r = r + s
		}
		return r
	}
	
	func getAllStrings() {
		self.showActivityView{ (Bool) -> Void in
			self.results = self.arrayOfAllString()
			self.reloadTable(true)
			
			self.hideActivityView()
		}
	}
	
	func searchForSubstring() {
		
		self.showActivityView{ (Bool) -> Void in
			let sub = self.searchBar.text
			let res = self.arrayOfAllString().filter{ $0.containsSubstring(sub) }
//			self.results = res.sort { $0.id < $1.id }
			self.results = res
			
			self.reloadTable(true)
			
			self.hideActivityView()
		}
	}
	
	func tableForString(_ string: XGString) -> XGStringTable {
		for table in self.stringTables {
			if table.file.fileName == string.table.fileName {
				return table
			}
		}
		return XGFiles.common_rel.stringTable
	}
	
	func replace() {
		self.showActivityView{ (Bool) -> Void in
			let new = self.selectedString.duplicateWithString(self.resultsBox.text)
			
			let table = self.tableForString(new)
			let saved = table.replaceString(new, alert: true)
			
			self.replaceResultForString(new)
			
			if (saved) || (!saved) {
				self.hideActivityView()
			}
		}
		
		self.reloadTable(false)
	}
	
	func replaceOccurences() {
		self.showActivityView{ (Bool) -> Void in
			let sub = self.searchBar.text
			let new = self.replaceBar.text
			
			let str = self.selectedString.string.replacingOccurrences(of: sub, with: new, options: [], range: nil)
			
			let table = self.tableForString(self.selectedString)
			let saved = table.replaceString(self.selectedString.duplicateWithString(str), alert: true)
			
			self.replaceResultForString(self.selectedString)
			self.reloadTable(false)
			
			if (saved) || (!saved) {
				self.hideActivityView()
			}
		}
		
		
	}
	
	func replaceAllOccurences() {
		self.showActivityView{ (Bool) -> Void in
			let sub = self.searchBar.text
			let new = self.replaceBar.text
			
			var saved = false
			
			for r in self.results {
				let str = r.string.replacingOccurrences(of: sub, with: new, options: [], range: nil)
				if r.string != str {
					let table = self.tableForString(r)
					saved = table.replaceString(r.duplicateWithString(str), alert: false)
					self.replaceResultForString(r)
				}
			}
			
			if (saved) || (!saved) {
				let message = saved ? "Replacements were all successful" : "At least one replacement failed"
				let button  = saved ? "Sweet" : "Awwn man..."
				
				self.reloadTable(true)
				
				XGAlertView.show(title: "Replaced", message: message, doneButtonTitle: button, otherButtonTitles: nil, buttonAction: {(buttonIndex : Int) -> Void in
				})
				self.hideActivityView()
			}
		}
		
		
	}
	
	override func popoverDidDismiss() {
		
		if popoverPresenter == filePickerButton {
			let f = selectedItem as! XGFiles
			self.results = f.stringTable.allStrings()
			self.reloadTable(true)
		}
		
		self.popoverPresenter.popover.dismiss(animated: true)
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		var cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! XGStringCell!
		if cell == nil {
			cell = XGStringCell(string: XGString(string: "", file: nil, sid: nil), reuseIdentifier: "cell")
		}
		
		if results.count == 0 {
			cell?.string = XGString(string: "No Results", file: nil, sid: nil)
		} else {
			cell?.string = self.results[indexPath.row]
		}
		cell?.background = XGResources.png("Item Cell").image
		
		cell?.textView.textColor = UIColor.black
		
		return cell!
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		self.currentIndexPath = indexPath
		self.selectedString = results[indexPath.row]
		self.resultsBox.text = selectedString.string
	}
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		
		if results.count == 0 {
			self.results = [XGString(string: "No results were found.", file: nil, sid: nil)]
		}
		
		let tv = UILabel()
		tv.lineBreakMode = .byWordWrapping
		tv.translatesAutoresizingMaskIntoConstraints = false
		let string = results[indexPath.row]
		tv.text = string.stringPlusIDAndFile
		tv.numberOfLines = 0
		tv.font = UIFont(name: "Helvetica", size: 20)
		tv.preferredMaxLayoutWidth = 280
		tv.frame.size.width = 280
		tv.frame.size.height = 1000
		tv.sizeToFit()
		let height = tv.frame.height + 100
		
		return height
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.results.count > 0 ? self.results.count : 1
	}
	
	func resultIndexForString(_ string : XGString) -> Int? {
		for i in 0 ..< results.count {
			if results[i].id == string.id {
				return i
			}
		}
		
		return nil
	}
	
	func replaceResultForString(_ string: XGString) {
		let index = resultIndexForString(string)
		if index != nil {
			results[index!] = string.table.stringTable.stringWithID(string.id)!
		}
	}
	
	
	func save() {
		for table in self.stringTables {
			self.showActivityView { (Bool) -> Void in
				table.save()
				
				self.hideActivityView()
			}
		}
	}

}





















