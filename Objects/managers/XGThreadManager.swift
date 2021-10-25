//
//  XGThreadManager.swift
//  GoD Tool
//
//  Created by The Steez on 26/10/2018.
//

import Foundation

class SafeArray<T> {

	private let lock = DispatchSemaphore(value: 1)
	private var array: [T]

	convenience init() {
		self.init(initialValue: [])
	}

	init(initialValue: [T]) {
		self.array = initialValue
	}

	subscript(index: Int) -> T? {
		lock.wait()
		defer { lock.signal() }
		return index < array.count ? array[index] : nil
	}

	func remove(atIndex index: Int) {
		lock.wait()
		array.remove(at: index)
		lock.signal()
	}

	func removeAll() {
		lock.wait()
		array.removeAll()
		lock.signal()
	}

	func append(_ value: T) {
		lock.wait()
		array.append(value)
		lock.signal()
	}

	func perform(operation: ([T]) -> Void) {
		lock.wait()
		operation(array)
		lock.signal()
	}

	func perform(mutation: ([T]) -> [T]) {
		lock.wait()
		array = mutation(array)
		lock.signal()
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

	func runInBackgroundAsyncNamed(queue: String = "", _ closure: @escaping () -> Void) {
		let dispatchQueue = DispatchQueue(label: "GoDBackgroundQueueAsync_\(queue)", qos: .background)
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







