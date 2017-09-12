//
//  XGRootTableViewCell.swift
//  XG Tool
//
//  Created by StarsMmd on 26/05/2015.
//  Copyright (c) 2015 StarsMmd. All rights reserved.
//

import UIKit

class XGRootTableViewCell: UITableViewCell {
	
	var background = UIImageView()
	var title = UILabel()
	
	override var textLabel : UILabel {
		
		get {
			return self.title
		}
		
	}
	
	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		self.addSubview(background)
		self.addSubview(title)
		self.background.translatesAutoresizingMaskIntoConstraints = false
		self.title.translatesAutoresizingMaskIntoConstraints = false
		
		self.title.font = UIFont(name: "Helvetica", size: 50)
		self.title.adjustsFontSizeToFitWidth = true
		self.title.textAlignment = .center
		
		let views = ["title" : self.title, "back" : self.background] as [String : Any]
		
		self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[title]|", options: [], metrics: nil, views: views))
		self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[back]|", options: [], metrics: nil, views: views))
		self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[title]|", options: [], metrics: nil, views: views))
		self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[back]|", options: [], metrics: nil, views: views))
		
		self.selectedBackgroundView = UIImageView(image: UIImage(named: "Selected Cell"))
		
	}

	convenience init(title: String, background : UIImage, reuseIdentifier: String) {
		self.init(style: .default, reuseIdentifier: reuseIdentifier)
		
		self.title.text  = title
		self.background.image = background
		
		self.selectedBackgroundView = UIImageView(image: UIImage(named: "Selected Cell"))
		
	}

	required init?(coder aDecoder: NSCoder) {
	    super.init(coder: aDecoder)
	}

}
