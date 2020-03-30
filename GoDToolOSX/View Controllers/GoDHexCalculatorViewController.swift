//
//  GoDHexCalculatorViewController.swift
//  GoD Tool
//
//  Created by The Steez on 24/10/2018.
//

import Cocoa

class GoDHexCalculatorViewController: GoDViewController {
	
	@IBOutlet var value1: NSTextField!
	@IBOutlet var value2: NSTextField!
	@IBOutlet var result: NSTextField!
	
	
	@IBAction func toHex1(_ sender: Any) {
		if let val = Int(value1.stringValue) {
			value1.stringValue = val.hexString()
		}
	}
	@IBAction func toDec1(_ sender: Any) {
		if value1.stringValue.isHexInteger {
			value1.stringValue = value1.stringValue.hexStringToInt().string
		}
	}
	
	@IBAction func toHex2(_ sender: Any) {
		if let val = Int(value2.stringValue) {
			value2.stringValue = val.hexString()
		}
	}
	@IBAction func toDec2(_ sender: Any) {
		if value2.stringValue.isHexInteger {
			value2.stringValue = value2.stringValue.hexStringToInt().string
		}
	}
	
	@IBAction func add(_ sender: Any) {
		if let val1 = value1.stringValue.integerValue {
			if let val2 = value2.stringValue.integerValue {
				let val3 = val1 + val2
				result.stringValue = " hex: \(val3.hexString()) dec: \(val3)"
			}
		}
	}
	@IBAction func multiply(_ sender: Any) {
		if let val1 = value1.stringValue.integerValue {
			if let val2 = value2.stringValue.integerValue {
				let val3 = val1 * val2
				result.stringValue = " hex: \(val3.hexString()) dec: \(val3)"
			}
		}
	}
	@IBAction func power(_ sender: Any) {
		if let val1 = value1.stringValue.integerValue {
			if let val2 = value2.stringValue.integerValue {
				let val3 = Int(pow(Double(val1), Double(val2)))
				result.stringValue = " hex: \(val3.hexString()) dec: \(val3)"
			}
		}
	}
	@IBAction func subtract(_ sender: Any) {
		if let val1 = value1.stringValue.integerValue {
			if let val2 = value2.stringValue.integerValue {
				let val3 = val1 - val2
				result.stringValue = " hex: \(val3.hexString()) dec: \(val3)"
			}
		}
	}
	@IBAction func divide(_ sender: Any) {
		if let val1 = value1.stringValue.integerValue {
			if let val2 = value2.stringValue.integerValue {
				if val2 != 0 {
					let val3 = val1 / val2
					result.stringValue = " hex: \(val3.hexString()) dec: \(val3)"
				}
			}
		}
	}
	@IBAction func mod(_ sender: Any) {
		if let val1 = value1.stringValue.integerValue {
			if let val2 = value2.stringValue.integerValue {
				if val2 != 0 {
				let val3 = val1 % val2
					result.stringValue = " hex: \(val3.hexString()) dec: \(val3)"
				}
			}
		}
	}
	
	@IBAction func swap(_ sender: Any) {
		let temp = value2.stringValue
		value2.stringValue = value1.stringValue
		value1.stringValue = temp
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		value1.stringValue = "0x0"
		value2.stringValue = "0"
	}
	
	
	func show(sender: GoDViewController) {
		sender.presentAsModalWindow(self)
	}
    
}
