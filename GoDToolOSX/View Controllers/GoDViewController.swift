//
//  GoDViewController.swift
//  GoD Tool
//
//  Created by StarsMmd on 29/06/2016.
//  Copyright © 2016 StarsMmd. All rights reserved.
//

import AppKit
import Cocoa

class GoDViewController: NSViewController {

	@objc var activityView = NSImageView()
	@objc var activityIndicator = NSProgressIndicator()
	
	@objc var selectedItem	 : Any	= 0
	
	@objc var views    : [String : NSView ] = [String : NSView ]()
	@objc var metrics  : [String : NSNumber] = [String : NSNumber]()
	
	@objc var mainView : NSView! {
		get {
			return view
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.activityView.setBackgroundColour(GoDDesign.colourBlack())
		self.activityView.addSubview(self.activityIndicator)
		self.activityIndicator.style = .spinning
		self.activityIndicator.translatesAutoresizingMaskIntoConstraints = false
		self.activityView.addConstraintAlignCenters(view1: self.activityIndicator, view2: self.activityView)
		self.activityView.addConstraintSize(view: self.activityIndicator, height: 50, width: 50)
		self.activityIndicator.startAnimation(self)
		
		
	}
	
	var isActive = false
	
	override func viewWillAppear() {
		super.viewWillAppear()
		isActive = true
	}
	
	override func viewWillDisappear() {
		super.viewWillDisappear()
		isActive = false
	}
	
	override func presentAsModalWindow(_ viewController: NSViewController) {
		if isActive {
			super.presentAsModalWindow(viewController)
		}
	}

	var isInFullScreen: Bool {
		if let styleMask = view.window?.styleMask {
			let fullScreenMask = NSWindow.StyleMask.fullScreen
			return styleMask.isSuperset(of: fullScreenMask)
		}
		return false
	}

	func toggleFullScreen() {
		view.window?.toggleFullScreen(self)
	}

	func enterFullScreen() {
		if !isInFullScreen {
			toggleFullScreen()
		}
	}

	func exitFullScreen() {
		if isInFullScreen {
			toggleFullScreen()
		}
	}
	
	@objc func showActivityView() {
		self.showActivityView(nil)
	}
	
	@objc func showActivityView(_ completion: ( () -> Void)! ) {
		
		self.activityView.alphaValue = 0
		self.addSubview(activityView, name: "av")
		self.addConstraintAlignCenters(view1: activityView, view2: self.view)
		self.addConstraintEqualSizes(view1: activityView, view2: self.view)
		
		NSAnimationContext.runAnimationGroup({ (context) in
			context.duration = 0.25
			self.activityView.animator().alphaValue = 0.5
		}) {
			if completion != nil {
				completion()
			}
		}
		
	}
	
	@objc func hideActivityView() {
		NSAnimationContext.runAnimationGroup({ (context) in
			context.duration = 0.25
			self.activityView.animator().alphaValue = 0
		}) {
			self.activityView.removeFromSuperview()
		}
		
	}
	
	
	@objc func addSubview(_ view: NSView, name: String) {
		
		view.translatesAutoresizingMaskIntoConstraints = false
		self.mainView.addSubview(view)
		self.views[name] = view
		
	}
	
	@objc func addMetric(value: NSNumber, name: String) {
		self.metrics[name] = value
	}
	
	func addConstraints(visualFormat: String, layoutFormat: NSLayoutConstraint.FormatOptions) {
		self.mainView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: visualFormat, options: layoutFormat, metrics: self.metrics , views: self.views))
	}
	
	@objc func addConstraintEqualWidths(view1: NSView, view2: NSView) {
		self.mainView.addConstraint(NSLayoutConstraint(item: view1, attribute: .width, relatedBy: .equal, toItem: view2, attribute: .width, multiplier: 1, constant: 0))
	}
	
	@objc func addConstraintEqualHeights(view1: NSView, view2: NSView) {
		self.mainView.addConstraint(NSLayoutConstraint(item: view1, attribute: .height, relatedBy: .equal, toItem: view2, attribute: .height, multiplier: 1, constant: 0))
	}
	
	@objc func addConstraintEqualSizes(  view1: NSView, view2: NSView) {
		self.addConstraintEqualHeights(view1: view1, view2: view2)
		self.addConstraintEqualWidths( view1: view1, view2: view2)
	}
	
	@objc func addConstraintAlignCenterX(view1: NSView, view2: NSView) {
		self.mainView.addConstraint(NSLayoutConstraint(item: view1, attribute: .centerX, relatedBy: .equal, toItem: view2, attribute: .centerX, multiplier: 1, constant: 0))
	}
	
	@objc func addConstraintAlignCenterY(view1: NSView, view2: NSView) {
		self.mainView.addConstraint(NSLayoutConstraint(item: view1, attribute: .centerY, relatedBy: .equal, toItem: view2, attribute: .centerY, multiplier: 1, constant: 0))
	}
	
	@objc func addConstraintAlignCenters(view1: NSView, view2: NSView) {
		self.addConstraintAlignCenterX(view1: view1, view2: view2)
		self.addConstraintAlignCenterY(view1: view1, view2: view2)
	}
	
	@objc func addConstraintAlignLeftEdges(view1: NSView, view2: NSView, constant: CGFloat = 0) {
		self.mainView.addConstraint(NSLayoutConstraint(item: view1, attribute: .left, relatedBy: .equal, toItem: view2, attribute: .left, multiplier: 1, constant: constant))
	}
	
	@objc func addConstraintAlignRightEdges(view1: NSView, view2: NSView, constant: CGFloat = 0) {
		self.mainView.addConstraint(NSLayoutConstraint(item: view1, attribute: .right, relatedBy: .equal, toItem: view2, attribute: .right, multiplier: 1, constant: constant))
	}
	
	@objc func addConstraintAlignTopEdges(view1: NSView, view2: NSView, constant: CGFloat = 0) {
		self.mainView.addConstraint(NSLayoutConstraint(item: view1, attribute: .top, relatedBy: .equal, toItem: view2, attribute: .top, multiplier: 1, constant: constant))
	}
	
	@objc func addConstraintAlignTopEdge(view1: NSView, toBottomEdgeOf view2: NSView, constant: CGFloat = 0) {
		self.mainView.addConstraint(NSLayoutConstraint(item: view1, attribute: .top, relatedBy: .equal, toItem: view2, attribute: .bottom, multiplier: 1, constant: constant))
	}
	
	@objc func addConstraintAlignBottomEdges(view1: NSView, view2: NSView, constant: CGFloat = 0) {
		self.mainView.addConstraint(NSLayoutConstraint(item: view1, attribute: .bottom, relatedBy: .equal, toItem: view2, attribute: .bottom, multiplier: 1, constant: constant))
	}
	
	@objc func addConstraintAlignTopAndBottomEdges(view1: NSView, view2: NSView, constant: CGFloat = 0) {
		self.addConstraintAlignTopEdges(view1: view1, view2: view2, constant: constant)
		self.addConstraintAlignBottomEdges(view1: view1, view2: view2, constant: -constant)
	}
	
	@objc func addConstraintAlignLeftAndRightEdges(view1: NSView, view2: NSView, constant: CGFloat = 0) {
		self.addConstraintAlignLeftEdges(view1: view1, view2: view2, constant: constant)
		self.addConstraintAlignRightEdges(view1: view1, view2: view2, constant: -constant)
	}
	
	@objc func addConstraintAlignAllEdges(view1: NSView, view2: NSView, constant: CGFloat = 0) {
		self.addConstraintAlignLeftAndRightEdges(view1: view1, view2: view2, constant: constant)
		self.addConstraintAlignTopAndBottomEdges(view1: view1, view2: view2, constant: constant)
	}
	
	@objc func addConstraintHeight(view: NSView, height: NSNumber) {
		let view = ["v" : view]
		let metric = ["h" : height]
		self.mainView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v(h)]", options: [], metrics: metric , views: view))
	}
	
	@objc func addConstraintWidth( view: NSView, width : NSNumber) {
		let view = ["v" : view]
		let metric = ["w" : width]
		self.mainView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v(w)]", options: [], metrics: metric , views: view))
	}
	
	@objc func addConstraintSize( view: NSView, height: NSNumber, width : NSNumber) {
		self.addConstraintWidth( view: view, width : width)
		self.addConstraintHeight(view: view, height: height)
	}
	
	@objc func createDummyViewsEqualHeights(_ number : Int, baseName : String) {
		
		for  i in 1 ... number {
			
			let dummy = NSView()
			dummy.isHidden = true
			dummy.translatesAutoresizingMaskIntoConstraints = false
			
			self.addSubview(dummy, name: baseName + "\(i)")
			
			if i > 1 {
				self.addConstraintEqualHeights(view1: views[baseName + "\(1)"]!, view2: views[baseName + "\(i)"]!)
			}
			
		}
	}
	
	@objc func createDummyViewsEqualWidths(_ number : Int, baseName : String) {
		
		for i in 1 ... number{
			
			let dummy = NSView()
			dummy.translatesAutoresizingMaskIntoConstraints = false
			
			self.addSubview(dummy, name: baseName + "\(i)")
			
			if i > 1 {
				self.addConstraintEqualWidths(view1: views[baseName + "\(1)"]!, view2: views[baseName + "\(i)"]!)
			}
			
		}
	}
	

    
}
