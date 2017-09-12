//
//  TrainerCell.swift
//  Mausoleum Tool
//
//  Created by StarsMmd on 03/10/2014.
//  Copyright (c) 2014 Steezy. All rights reserved.
//

import UIKit

class XGTableViewCell: UITableViewCell {
	
	var title : String {
		
		get {
			return textLabel!.text ?? ""
		}
		
		set {
			textLabel!.text = newValue
		}
	}
	
	var subtitle : String {
		
		get {
			return detailTextLabel!.text ?? ""
		}
		
		set {
			detailTextLabel!.text = newValue
		}
	}
	
	var background : UIImage {
		get {
			return UIImage()
		}
		set {
			self.backgroundView = UIImageView(image: newValue)
		}
	}
	
	var picture : UIImage? {
		get {
			return imageView?.image
		}
		
		set {
			self.imageView?.image = newValue
		}
	}
	
	init() {
		super.init(style: UITableViewCellStyle.subtitle, reuseIdentifier: "cell")
		self.selectionStyle = .blue
		self.selectedBackgroundView = UIImageView(image: UIImage(named: "Selected Cell"))
		self.textLabel?.adjustsFontSizeToFitWidth = true
	}

	required init?(coder aDecoder: NSCoder) {
	   super.init(coder: aDecoder)
	}
	
	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		self.selectionStyle = .blue
		self.selectedBackgroundView = UIImageView(image: UIImage(named: "Selected Cell"))
		self.textLabel?.adjustsFontSizeToFitWidth = true
	}

}











