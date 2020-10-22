//
//  DummyThreadManager.swift
//  GoD Tool
//
//  Created by Stars Momodu on 22/10/2020.
//

import Foundation

class XGThreadManager {

	static let manager = XGThreadManager()
	private init() {}

	func runInBackgroundAsync(_ closure: @escaping () -> Void) {
		closure()
	}

	func runInBackgroundSync(_ closure: @escaping () -> Void) {
		closure()
	}

	func runInForegroundAsync(_ closure: @escaping () -> Void) {
		closure()
	}

	func runInForegroundSync(_ closure: @escaping () -> Void) {
		closure()
	}

}
