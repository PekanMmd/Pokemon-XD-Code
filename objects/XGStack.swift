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
	
	func pop() -> T {
		return data.removeLast()
	}
	
	func popVoid() {
		// so I don't get so many compiler warnings about not using the return value
		let _ = self.pop()
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


