//
//  TAViewLayoutManager.swift
//  TileApp
//
//  Created by StarsMmd on 15/08/2017.
//  Copyright © 2017 Stars. All rights reserved.
//


import UIKit

protocol XGViewLayoutManager {
	
	var contentview : UIView! { get }
	
}

extension XGViewLayoutManager {
	
	func addConstraints(visualFormat: String, layoutFormat: NSLayoutFormatOptions, metrics: [String: CGFloat]?, views: [String: UIView]) {
		self.contentview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: visualFormat, options: layoutFormat, metrics: metrics, views: views))
	}
	
	func addConstraintEqualWidths(view1: UIView, view2: UIView) {
		self.contentview.addConstraint(NSLayoutConstraint(item: view1, attribute: .width, relatedBy: .equal, toItem: view2, attribute: .width, multiplier: 1, constant: 0))
	}
	
	func addConstraintEqualHeights(view1: UIView, view2: UIView) {
		self.contentview.addConstraint(NSLayoutConstraint(item: view1, attribute: .height, relatedBy: .equal, toItem: view2, attribute: .height, multiplier: 1, constant: 0))
	}
	
	func addConstraintEqualSizes(view1: UIView, view2: UIView) {
		self.contentview.addConstraintEqualHeights(view1: view1, view2: view2)
		self.contentview.addConstraintEqualWidths( view1: view1, view2: view2)
	}
	
	func addConstraintAlignCenterX(view1: UIView, view2: UIView) {
		self.contentview.addConstraint(NSLayoutConstraint(item: view1, attribute: .centerX, relatedBy: .equal, toItem: view2, attribute: .centerX, multiplier: 1, constant: 0))
	}
	
	func addConstraintAlignCenterY(view1: UIView, view2: UIView) {
		self.contentview.addConstraint(NSLayoutConstraint(item: view1, attribute: .centerY, relatedBy: .equal, toItem: view2, attribute: .centerY, multiplier: 1, constant: 0))
	}
	
	func addConstraintAlignCenters(view1: UIView, view2: UIView) {
		self.contentview.addConstraintAlignCenterX(view1: view1, view2: view2)
		self.contentview.addConstraintAlignCenterY(view1: view1, view2: view2)
	}
	
	func addConstraintAlignLeftEdges(view1: UIView, view2: UIView) {
		self.contentview.addConstraint(NSLayoutConstraint(item: view1, attribute: .left, relatedBy: .equal, toItem: view2, attribute: .left, multiplier: 1, constant: 0))
	}
	
	func addConstraintAlignRightEdges(view1: UIView, view2: UIView) {
		self.contentview.addConstraint(NSLayoutConstraint(item: view1, attribute: .right, relatedBy: .equal, toItem: view2, attribute: .right, multiplier: 1, constant: 0))
	}
	
	func addConstraintAlignTopEdges(view1: UIView, view2: UIView) {
		self.contentview.addConstraint(NSLayoutConstraint(item: view1, attribute: .top, relatedBy: .equal, toItem: view2, attribute: .top, multiplier: 1, constant: 0))
	}
	
	func addConstraintAlignBottomEdges(view1: UIView, view2: UIView) {
		self.contentview.addConstraint(NSLayoutConstraint(item: view1, attribute: .bottom, relatedBy: .equal, toItem: view2, attribute: .bottom, multiplier: 1, constant: 0))
	}
	
	func addConstraintAlignTopAndBottomEdges(view1: UIView, view2: UIView) {
		self.contentview.addConstraintAlignTopEdges(view1: view1, view2: view2)
		self.contentview.addConstraintAlignBottomEdges(view1: view1, view2: view2)
	}
	
	func addConstraintAlignLeftAndRightEdges(view1: UIView, view2: UIView) {
		self.contentview.addConstraintAlignLeftEdges(view1: view1, view2: view2)
		self.contentview.addConstraintAlignRightEdges(view1: view1, view2: view2)
	}
	
	func addConstraintAlignAllEdges(view1: UIView, view2: UIView) {
		self.contentview.addConstraintAlignLeftAndRightEdges(view1: view1, view2: view2)
		self.contentview.addConstraintAlignTopAndBottomEdges(view1: view1, view2: view2)
	}
	
	func addConstraintHeight(view: UIView, height: CGFloat) {
		let view = ["v" : view]
		let metric = ["h" : height]
		self.contentview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v(h)]", options: [], metrics: metric, views: view))
	}
	
	func addConstraintWidth( view: UIView, width : CGFloat) {
		let view = ["v" : view]
		let metric = ["w" : width]
		self.contentview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v(w)]", options: [], metrics: metric, views: view))
	}
	
	func addConstraintSize( view: UIView, height: CGFloat, width : CGFloat) {
		self.contentview.addConstraintWidth( view: view, width : width)
		self.contentview.addConstraintHeight(view: view, height: height)
	}
	
	func addShadowToView(view: UIView, radius: CGFloat, xOffset: CGFloat, yOffset: CGFloat) {
		
		view.layer.masksToBounds = false
		view.layer.shadowOpacity = 0.9
		view.layer.shadowOffset = CGSize(width: xOffset, height: yOffset)
		view.layer.shadowColor = UIColor.black.cgColor
		view.layer.shadowRadius = radius
		
	}
	
}
