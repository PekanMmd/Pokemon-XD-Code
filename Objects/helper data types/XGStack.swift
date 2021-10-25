//
//  XGStack.swift
//  GoDToolCL
//
//  Created by The Steez on 29/05/2018.
//

import Foundation

class XGStack<T>: NSObject {
	typealias Element = T

	private var data : [T] = [T]()
	
	func push(_ value: T) {
		data.append(value)
	}
	
	@discardableResult func pop() -> T {
		return data.removeLast()
	}
	
	func peek() -> T? {
		return data.last
	}
	
	var asArray : [T] {
		let array = self.data
		return array
	}
	
	var count : Int {
		return data.count
	}
	
	var isEmpty : Bool {
		return data.count == 0
	}
}

extension XGStack where Element:Equatable {
	func contains(_ element: Element) -> Bool {
		return data.contains(element)
	}
}


