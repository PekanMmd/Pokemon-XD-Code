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

	var activityView = NSImageView()
	var activityIndicator = NSProgressIndicator()
	
	var selectedItem	 : Any	= 0
	
	var views    : [String : NSView ] = [String : NSView ]()
	var metrics  : [String : CGFloat] = [String : CGFloat]()
	
	var mainView : NSView! {
		get {
			return view
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.activityView.setBackgroundColour(GoDDesign.colourBlack())
		self.activityView.addSubview(self.activityIndicator)
		self.activityIndicator.style = .spinningStyle
		self.activityIndicator.translatesAutoresizingMaskIntoConstraints = false
		self.activityView.addConstraintAlignCenters(view1: self.activityIndicator, view2: self.activityView)
		self.activityView.addConstraintSize(view: self.activityIndicator, height: 50, width: 50)
		self.activityIndicator.startAnimation(self)
		
		self.addMetric(value: self.mainView.frame.height, name: "screenHeight")
		self.addMetric(value: self.mainView.frame.width , name: "screenWidth" )
		
	}
	
	func showActivityView() {
		self.showActivityView(nil)
	}
	
	func showActivityView(_ completion: ( () -> Void)! ) {
		
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
	
	func hideActivityView() {
		NSAnimationContext.runAnimationGroup({ (context) in
			context.duration = 0.25
			self.activityView.animator().alphaValue = 0
		}) {
			self.activityView.removeFromSuperview()
		}
		
	}
	
	func dispatchAfter(dispatchTime: Double, closure: @escaping () -> Void) {
		
		DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(dispatchTime * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
			closure()
		})
	}
	
	
	func addSubview(_ view: NSView, name: String) {
		
		view.translatesAutoresizingMaskIntoConstraints = false
		self.mainView.addSubview(view)
		self.views[name] = view
		
	}
	
	func addMetric(value: CGFloat, name: String) {
		self.metrics[name] = value
	}
	
	func addConstraints(visualFormat: String, layoutFormat: NSLayoutFormatOptions) {
		self.mainView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: visualFormat, options: layoutFormat, metrics: self.metrics as [String : NSNumber]?, views: self.views))
	}
	
	func addConstraintEqualWidths(view1: NSView, view2: NSView) {
		self.mainView.addConstraint(NSLayoutConstraint(item: view1, attribute: .width, relatedBy: .equal, toItem: view2, attribute: .width, multiplier: 1, constant: 0))
	}
	
	func addConstraintEqualHeights(view1: NSView, view2: NSView) {
		self.mainView.addConstraint(NSLayoutConstraint(item: view1, attribute: .height, relatedBy: .equal, toItem: view2, attribute: .height, multiplier: 1, constant: 0))
	}
	
	func addConstraintEqualSizes(  view1: NSView, view2: NSView) {
		self.addConstraintEqualHeights(view1: view1, view2: view2)
		self.addConstraintEqualWidths( view1: view1, view2: view2)
	}
	
	func addConstraintAlignCenterX(view1: NSView, view2: NSView) {
		self.mainView.addConstraint(NSLayoutConstraint(item: view1, attribute: .centerX, relatedBy: .equal, toItem: view2, attribute: .centerX, multiplier: 1, constant: 0))
	}
	
	func addConstraintAlignCenterY(view1: NSView, view2: NSView) {
		self.mainView.addConstraint(NSLayoutConstraint(item: view1, attribute: .centerY, relatedBy: .equal, toItem: view2, attribute: .centerY, multiplier: 1, constant: 0))
	}
	
	func addConstraintAlignCenters(view1: NSView, view2: NSView) {
		self.addConstraintAlignCenterX(view1: view1, view2: view2)
		self.addConstraintAlignCenterY(view1: view1, view2: view2)
	}
	
	func addConstraintAlignLeftEdges(view1: NSView, view2: NSView) {
		self.mainView.addConstraint(NSLayoutConstraint(item: view1, attribute: .left, relatedBy: .equal, toItem: view2, attribute: .left, multiplier: 1, constant: 0))
	}
	
	func addConstraintAlignRightEdges(view1: NSView, view2: NSView) {
		self.mainView.addConstraint(NSLayoutConstraint(item: view1, attribute: .right, relatedBy: .equal, toItem: view2, attribute: .right, multiplier: 1, constant: 0))
	}
	
	func addConstraintAlignTopEdges(view1: NSView, view2: NSView) {
		self.mainView.addConstraint(NSLayoutConstraint(item: view1, attribute: .top, relatedBy: .equal, toItem: view2, attribute: .top, multiplier: 1, constant: 0))
	}
	
	func addConstraintAlignBottomEdges(view1: NSView, view2: NSView) {
		self.mainView.addConstraint(NSLayoutConstraint(item: view1, attribute: .bottom, relatedBy: .equal, toItem: view2, attribute: .bottom, multiplier: 1, constant: 0))
	}
	
	func addConstraintAlignTopAndBottomEdges(view1: NSView, view2: NSView) {
		self.addConstraintAlignTopEdges(view1: view1, view2: view2)
		self.addConstraintAlignBottomEdges(view1: view1, view2: view2)
	}
	
	func addConstraintAlignLeftAndRightEdges(view1: NSView, view2: NSView) {
		self.addConstraintAlignLeftEdges(view1: view1, view2: view2)
		self.addConstraintAlignRightEdges(view1: view1, view2: view2)
	}
	
	func addConstraintAlignAllEdges(view1: NSView, view2: NSView) {
		self.addConstraintAlignLeftAndRightEdges(view1: view1, view2: view2)
		self.addConstraintAlignTopAndBottomEdges(view1: view1, view2: view2)
	}
	
	func addConstraintHeight(view: NSView, height: CGFloat) {
		let view = ["v" : view]
		let metric = ["h" : height]
		self.mainView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v(h)]", options: [], metrics: metric as [String : NSNumber]?, views: view))
	}
	
	func addConstraintWidth( view: NSView, width : CGFloat) {
		let view = ["v" : view]
		let metric = ["w" : width]
		self.mainView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v(w)]", options: [], metrics: metric as [String : NSNumber]?, views: view))
	}
	
	func addConstraintSize( view: NSView, height: CGFloat, width : CGFloat) {
		self.addConstraintWidth( view: view, width : width)
		self.addConstraintHeight(view: view, height: height)
	}
	
	func createDummyViewsEqualHeights(_ number : Int, baseName : String) {
		
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
	
	func createDummyViewsEqualWidths(_ number : Int, baseName : String) {
		
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
