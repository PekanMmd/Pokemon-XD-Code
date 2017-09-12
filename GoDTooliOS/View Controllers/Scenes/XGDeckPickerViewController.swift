//
//  XGDeckPickerViewController.swift
//  XG Tool
//
//  Created by StarsMmd on 01/07/2015.
//  Copyright (c) 2015 StarsMmd. All rights reserved.
//

import UIKit

class XGDeckPickerViewController: XGTableViewController {
	
	var decks = [XGDecks]()
	var selectedRow = 0

    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.title = "Deck Selection"
		self.contentView.backgroundColor = UIColor.black
		
		self.decks = []
		decks.append(.DeckStory)
		decks.append(.DeckHundred)
		decks.append(.DeckColosseum)
		decks.append(.DeckVirtual)
		decks.append(.DeckImasugu)
		decks.append(.DeckBingo)
		decks.append(.DeckSample)
	
		self.table.reloadData()
    }
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		var cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! XGTableViewCell!
		if cell == nil {
			cell = XGTableViewCell(style: .subtitle, reuseIdentifier: "cell")
		}
		
		cell?.title = decks[indexPath.row].fileName
		cell?.background = UIImage(named: "Item Cell")!
		
		return cell!
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		self.selectedRow = indexPath.row
		self.performSegue(withIdentifier: "toDeckVC", sender: self)
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return decks.count
	}
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 150
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.destination.isKind(of: XGDeckViewController.self) {
			let deckVC = segue.destination as! XGDeckViewController
			deckVC.deck = decks[selectedRow]
		}
	}

}





















