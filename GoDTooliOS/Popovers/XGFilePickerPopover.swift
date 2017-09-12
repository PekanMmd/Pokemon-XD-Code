//
//  XGFilePicker.swift
//  XG Tool
//
//  Created by StarsMmd on 03/06/2015.
//  Copyright (c) 2015 StarsMmd. All rights reserved.
//

import Foundation

import UIKit

class XGFilePickerPopover: XGPopover {
	
	var folder = XGFolders.Documents
	var files = [XGFiles]()
	
	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
	}
	
	init(folder: XGFolders) {
		super.init()
		self.folder = folder
		self.files = folder.files
		
		files = files.filter{ $0.fileName.substring(with: ($0.fileName.startIndex ..< $0.fileName.startIndex)) != "." }
		
		self.delegate = delegate
		self.tableView.backgroundColor = UIColor.orange
	}

	required init!(coder aDecoder: NSCoder) {
	    super.init(coder: aDecoder)
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return files.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = dequeueCell()
		
		cell.title = files[indexPath.row].fileName
		
		switch self.folder {
			case .PNG: cell.picture = folder.files[indexPath.row].image
			case .PokeBody: cell.picture = folder.files[indexPath.row].image
			case .PokeFace: cell.picture = folder.files[indexPath.row].image
			case .Types: cell.picture = folder.files[indexPath.row].image
			case .Trainers: cell.picture = folder.files[indexPath.row].image
			
			default: break
		}
		
		cell.background = UIImage(named: "File Cell")!
		
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		delegate.selectedItem =  files[indexPath.row] as Any
		delegate.popoverDidDismiss()
	}
	
	
	
}







