//
//  ViewController.swift
//  XD Randomiser
//
//  Created by The Steez on 05/09/2017.
//
//

import Cocoa

class XDRViewController: NSViewController, GoDViewLayoutManager {
	
	var contentview: NSView {
		return self.view
	}

	override var representedObject: Any? {
		didSet {
		// Update the view, if already loaded.
		}
	}

	var active = false {
		didSet {
			activeSet()
		}
	}
	
	func activeSet() {
		return
	}
	
	var progressBar = NSProgressIndicator(frame: NSRect(x: 25, y: 160, width: 200, height: 80))
	var back = NSImageView()
	
	var views    : [String : NSView ] = [String : NSView ]()
	var metrics  : [String : CGFloat] = [String : CGFloat]()
	
	var contentView : NSView! {
		get {
			return view
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		progressBar.controlTint = .blueControlTint
		progressBar.isIndeterminate = false
		back.frame = self.view.frame
		back.image = NSImage(named: "back")
		back.alphaValue = 0.25
		back.imageScaling = .scaleAxesIndependently
		back.refusesFirstResponder = false
		
	}
	
	func showActivityView() {
		self.showActivityView(nil)
	}
	
	func showActivityView(_ completion: ( (Bool) -> Void)! ) {
		active = true
		//		self.view.addSubview(back)
		self.view.addSubview(progressBar)
		dispatchAfter(dispatchTime: 0.5, closure: {
			DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.background).async(execute: { () -> Void in
				completion(true)
			})
			
		})
		
	}
	
	func hideActivityView() {
		active = false
		//		back.removeFromSuperview()
		progressBar.removeFromSuperview()
		progressBar.doubleValue = 0
	}
	
	func dispatchAfter(dispatchTime: Double, closure: @escaping () -> Void) {
		
		DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(dispatchTime * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
			closure()
		})
	}

}

