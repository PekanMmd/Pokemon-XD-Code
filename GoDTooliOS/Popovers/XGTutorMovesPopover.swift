//
//  XGTutorMovesPopover.swift
//  XG Tool
//
//  Created by The Steez on 25/08/2015.
//  Copyright (c) 2015 Ovation International. All rights reserved.
//

import UIKit

class XGTutorMovesPopover: XGPopover {

	var moves = [XGMoves]()
	var stats = XGPokemonStats(index: 0)
	
	override init() {
		super.init()
		
		for i in 1 ... kNumberOfTutorMoves {
			
			moves.append(XGTMs.tutor(i).move)
		}
		
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
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return kNumberOfTutorMoves
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = dequeueCell()
		
		let move = moves[indexPath.row]
		
		cell.title = move.name.string
		cell.background = move.type.image
		cell.picture = stats.tutorMoves[indexPath.row] ? UIImage(named: "ball red") : UIImage(named: "ball grey")
		
		
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		stats.tutorMoves[indexPath.row] = !stats.tutorMoves[indexPath.row]
		self.tableView.reloadRows(at: [indexPath], with: .fade)
	}

	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 50
	}
}





