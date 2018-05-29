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
}


