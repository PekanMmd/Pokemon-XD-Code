//
//  XGTextureImportViewController.swift
//  XG Tool
//
//  Created by StarsMmd on 04/06/2015.
//  Copyright (c) 2015 StarsMmd. All rights reserved.
//

import UIKit

class XGTextureImportViewController: XGViewController {
	
	var textureFile		= XGFiles.nameAndFolder("Texture FDAT", .Documents)
	var imageFile		= XGFiles.nameAndFolder("Texture PNG" , .Documents)
	
	var textureButton	= XGPopoverButton()
	var imageButton		= XGPopoverButton()
	
	var importButton	= XGButton()
	var autoButton		= XGButton()
	
	var imageView		= UIImageView()
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.title = "Texture Reimporter"
		
		setUpUI()
		self.configureView()
	}
	
	func setUpUI() {
	
		self.textureButton = XGPopoverButton(title: "", colour: UIColor.black, textColour: UIColor.white, popover: XGFilePickerPopover(folder: .Textures), viewController: self)
		self.imageButton   = XGPopoverButton(title: "", colour: UIColor.black, textColour: UIColor.white,popover: XGFilePickerPopover(folder: .Import ), viewController: self)
		self.importButton  = XGButton(title: "Import", colour: UIColor.blue, textColour: UIColor.white, action: {self.importTexture()})
		self.autoButton	   = XGButton(title: "Auto Import", colour: UIColor.red, textColour: UIColor.white, action: {})
		
		self.addSubview(textureButton, name: "tb")
		self.addSubview(imageButton, name: "imab")
		self.addSubview(importButton, name: "impb")
		self.addSubview(autoButton, name: "ab")
		self.addSubview(imageView, name: "iv")
		
		self.addConstraints(visualFormat: "H:|-(30)-[tb(300)]-(>=0)-[imab(300)]-(30)-|", layoutFormat: [])
		self.addConstraints(visualFormat: "H:|-(200)-[impb(250)]-(>=0)-[ab(250)]-(200)-|", layoutFormat: [])
		self.addConstraints(visualFormat: "V:|-(30)-[tb(100)]-(>=0)-[impb(80)]-(30)-|", layoutFormat: [])
		self.addConstraints(visualFormat: "V:|-(30)-[imab(100)]-(>=0)-[ab(80)]-(30)-|", layoutFormat: [])
		
		self.imageView.image = UIImage(named: "9")
		self.addConstraintWidth(view: imageView, width: 400)
		self.addConstraintHeight(view: imageView, height: 400)
		self.addConstraintAlignCenters(view1: self.view, view2: imageView)
		imageView.layer.cornerRadius = 10
		self.addShadowToView(view: imageView, radius: 5, xOffset: 5, yOffset: 5)
		
	}
	
	func configureView() {
		self.textureButton.titleLabel?.text = textureFile.fileName
		self.imageButton.titleLabel?.text	= imageFile.fileName
		
		if imageFile.exists {
			self.imageView.image = imageFile.image
		}
	}
	
	override func popoverDidDismiss() {
		super.popoverDidDismiss()
		
		if self.popoverPresenter == textureButton {
			self.textureFile = selectedItem as! XGFiles
		}
		if self.popoverPresenter == imageButton {
			self.imageFile = selectedItem as! XGFiles
		}
		
		self.configureView()
		
	}
	
	func importTexture() {
		
		self.showActivityView { (Bool) -> Void in
		
		if self.textureFile.exists && self.imageFile.exists {
			XGTexturePNGReimporter.replaceTextureData(textureFile: self.textureFile, withImage: self.imageFile)
		}
		
		
		XGAlertView.show(title: "Texture Import", message: "done", doneButtonTitle: nil, otherButtonTitles: ["Cool"], buttonAction: { (index: Int) -> Void in
			self.hideActivityView()
		})
			
		}
	}
	
	
	
}


















