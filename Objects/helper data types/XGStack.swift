//
//  XGStack.swift
//  GoDToolCL
//
//  Created by The Steez on 29/05/2018.
//

import Cocoa

class XGStack<T>: NSObject {

	private var data : [T] = [T]()
	
	func push(_ value: T) {
		data.append(value)
	}
	
	@discardableResult func pop() -> T {
		return data.removeLast()
	}
	
	func peek() -> T {
		return data.last!
	}
	
	var asArray : [T] {
		let array = self.data
		return array
	}
	
	var count : Int {
		return data.count
	}
	
	@objc var isEmpty : Bool {
		return data.count == 0
	}
}


