//
//  XGThreadManager.swift
//  GoD Tool
//
//  Created by The Steez on 26/10/2018.
//

import Foundation

@propertyWrapper
struct Atomic<Value> {

	private let lock = DispatchSemaphore(value: 1)
	private var value: Value

	init(wrappedValue: Value) {
		self.value = wrappedValue
	}

	var wrappedValue: Value {
		get {
			lock.wait()
			defer { lock.signal() }
			return value
		}
		set {
			lock.wait()
			value = newValue
			lock.signal()
		}
	}
}

class XGThreadManager {

	static let manager = XGThreadManager()
	private init() {}

	func runInBackgroundAsync(queue: Int = 0, _ closure: @escaping () -> Void) {
		let dispatchQueue = DispatchQueue(label: "GoDBackgroundQueueAsync\(queue)", qos: .background)
		dispatchQueue.async {
			closure()
		}
	}

	func runInBackgroundSync(_ closure: @escaping () -> Void) {
		let dispatchQueue = DispatchQueue(label: "GoDBackgroundQueueSync", qos: .background)
		dispatchQueue.sync {
			closure()
		}
	}

	func runInForegroundAsync(_ closure: @escaping () -> Void) {
		let dispatchQueue = DispatchQueue.main
		dispatchQueue.async {
			closure()
		}
	}

	func runInForegroundSync(_ closure: @escaping () -> Void) {
		let dispatchQueue = DispatchQueue.main
		dispatchQueue.sync {
			closure()
		}
	}

}







