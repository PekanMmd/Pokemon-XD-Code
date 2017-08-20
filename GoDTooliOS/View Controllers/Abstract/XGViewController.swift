//
//  XGViewController.swift
//  XG Tool
//
//  Created by The Steez on 06/06/2015.
//  Copyright (c) 2015 Ovation International. All rights reserved.
//

import UIKit

class XGViewController: UIViewController, XGPopoverDelegate  {
	
	var activityView = XGActivityView()
	
	var popoverPresenter = XGPopoverButton()
	var selectedItem	 : Any	= 0
	
	var views    : [String : UIView ] = [String : UIView ]()
	var metrics  : [String : CGFloat] = [String : CGFloat]()
	
	var contentView : UIView! {
		get {
			return view
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.addMetric(value: self.contentView.frame.height, name: "screenHeight")
		self.addMetric(value: self.contentView.frame.width , name: "screenWidth" )
		
		self.contentView.backgroundColor = UIColor.orange

	}
	
	func openPopover(_ sender: XGPopoverButton) {
		self.popoverPresenter = sender
		
		sender.showPopover()
		
	}
	
	func popoverDidDismiss() {
		self.popoverPresenter.popover.dismiss(animated: true)
	}
	
	func showActivityView() {
		self.showActivityView(nil)
	}
	
	func showActivityView(_ completion: ( (Bool) -> Void)! ) {
		
		self.view.addSubview(activityView)
		let views = ["av" : activityView]
		self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[av]|", options: [], metrics: nil, views: views))
		self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[av]|", options: [], metrics: nil, views: views))
		UIView.animate(withDuration: 0.25, animations: {
			self.activityView.alpha = 1.0
		}, completion : { (done: Bool) -> Void in
			if completion != nil {
				completion(done)
			}
		})
		
	}
	
	func hideActivityView() {
		UIView.animate(withDuration: 0.25, animations: {
			self.activityView.alpha = 0
		}, completion: { (Bool) -> Void in
			self.activityView.removeFromSuperview()
		})
	}
	
	func dispatchAfter(dispatchTime: Double, closure: @escaping () -> Void) {
		
		DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(dispatchTime * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
			closure()
		})
	}
	
	
	func addSubview(_ view: UIView, name: String) {
		
		view.translatesAutoresizingMaskIntoConstraints = false
		self.contentView.addSubview(view)
		self.views[name] = view
		
	}
	
	func addMetric(value: CGFloat, name: String) {
		self.metrics[name] = value
	}
	
	func addConstraints(visualFormat: String, layoutFormat: NSLayoutFormatOptions) {
		self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: visualFormat, options: layoutFormat, metrics: self.metrics, views: self.views))
	}
	
	func addConstraintEqualWidths(view1: UIView, view2: UIView) {
		self.contentView.addConstraint(NSLayoutConstraint(item: view1, attribute: .width, relatedBy: .equal, toItem: view2, attribute: .width, multiplier: 1, constant: 0))
	}
	
	func addConstraintEqualHeights(view1: UIView, view2: UIView) {
		self.contentView.addConstraint(NSLayoutConstraint(item: view1, attribute: .height, relatedBy: .equal, toItem: view2, attribute: .height, multiplier: 1, constant: 0))
	}
	
	func addConstraintEqualSizes(  view1: UIView, view2: UIView) {
		self.addConstraintEqualHeights(view1: view1, view2: view2)
		self.addConstraintEqualWidths( view1: view1, view2: view2)
	}
	
	func addConstraintAlignCenterX(view1: UIView, view2: UIView) {
		self.contentView.addConstraint(NSLayoutConstraint(item: view1, attribute: .centerX, relatedBy: .equal, toItem: view2, attribute: .centerX, multiplier: 1, constant: 0))
	}
	
	func addConstraintAlignCenterY(view1: UIView, view2: UIView) {
		self.contentView.addConstraint(NSLayoutConstraint(item: view1, attribute: .centerY, relatedBy: .equal, toItem: view2, attribute: .centerY, multiplier: 1, constant: 0))
	}
	
	func addConstraintAlignCenters(view1: UIView, view2: UIView) {
		self.addConstraintAlignCenterX(view1: view1, view2: view2)
		self.addConstraintAlignCenterY(view1: view1, view2: view2)
	}
	
	func addConstraintAlignLeftEdges(view1: UIView, view2: UIView) {
		self.contentView.addConstraint(NSLayoutConstraint(item: view1, attribute: .left, relatedBy: .equal, toItem: view2, attribute: .left, multiplier: 1, constant: 0))
	}
	
	func addConstraintAlignRightEdges(view1: UIView, view2: UIView) {
		self.contentView.addConstraint(NSLayoutConstraint(item: view1, attribute: .right, relatedBy: .equal, toItem: view2, attribute: .right, multiplier: 1, constant: 0))
	}
	
	func addConstraintAlignTopEdges(view1: UIView, view2: UIView) {
		self.contentView.addConstraint(NSLayoutConstraint(item: view1, attribute: .top, relatedBy: .equal, toItem: view2, attribute: .top, multiplier: 1, constant: 0))
	}
	
	func addConstraintAlignBottomEdges(view1: UIView, view2: UIView) {
		self.contentView.addConstraint(NSLayoutConstraint(item: view1, attribute: .bottom, relatedBy: .equal, toItem: view2, attribute: .bottom, multiplier: 1, constant: 0))
	}
	
	func addConstraintAlignTopAndBottomEdges(view1: UIView, view2: UIView) {
		self.addConstraintAlignTopEdges(view1: view1, view2: view2)
		self.addConstraintAlignBottomEdges(view1: view1, view2: view2)
	}
	
	func addConstraintAlignLeftAndRightEdges(view1: UIView, view2: UIView) {
		self.addConstraintAlignLeftEdges(view1: view1, view2: view2)
		self.addConstraintAlignRightEdges(view1: view1, view2: view2)
	}
	
	func addConstraintAlignAllEdges(view1: UIView, view2: UIView) {
		self.addConstraintAlignLeftAndRightEdges(view1: view1, view2: view2)
		self.addConstraintAlignTopAndBottomEdges(view1: view1, view2: view2)
	}
	
	func addConstraintHeight(view: UIView, height: CGFloat) {
		let view = ["v" : view]
		let metric = ["h" : height]
		self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v(h)]", options: [], metrics: metric, views: view))
	}
	
	func addConstraintWidth( view: UIView, width : CGFloat) {
		let view = ["v" : view]
		let metric = ["w" : width]
		self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v(w)]", options: [], metrics: metric, views: view))
	}
	
	func addConstraintSize( view: UIView, height: CGFloat, width : CGFloat) {
		self.addConstraintWidth( view: view, width : width)
		self.addConstraintHeight(view: view, height: height)
	}
	
	func createDummyViewsEqualHeights(_ number : Int, baseName : String) {
		
		for i in 1 ... number {
			
			let dummy = UIView()
			dummy.isUserInteractionEnabled = false
			dummy.alpha = 0.0
			dummy.isHidden = true
			dummy.translatesAutoresizingMaskIntoConstraints = false
			
			self.addSubview(dummy, name: baseName + "\(i)")
			
			if i > 1 {
				self.addConstraintEqualHeights(view1: views[baseName + "\(1)"]!, view2: views[baseName + "\(i)"]!)
			}
			
		}
	}
	
	func createDummyViewsEqualWidths(_ number : Int, baseName : String) {
		
		for i in 1 ... number {
			
			let dummy = UIView()
			dummy.translatesAutoresizingMaskIntoConstraints = false
			
			self.addSubview(dummy, name: baseName + "\(i)")
			
			if i > 1 {
				self.addConstraintEqualWidths(view1: views[baseName + "\(1)"]!, view2: views[baseName + "\(i)"]!)
			}
			
		}
	}
	
	func addShadowToView(view: UIView, radius: CGFloat, xOffset: CGFloat, yOffset: CGFloat) {
		
		view.layer.masksToBounds = false
		view.layer.shadowOpacity = 0.9
		view.layer.shadowOffset = CGSize(width: xOffset, height: yOffset)
		view.layer.shadowColor = UIColor.black.cgColor
		view.layer.shadowRadius = radius
		
	}


}











































