//
//  XGThreadManager.swift
//  GoD Tool
//
//  Created by The Steez on 26/10/2018.
//

import Foundation

// About time I added background threads!
class XGThreadManager {

	// thought I'd make a singleton object just for the banter
	static let manager = XGThreadManager()


	// Wow, recent swift versions have really streamlined the whole multi threading process
	// This is about all I really need
	// Just need to make sure I put stuff on the right queues
	// Remember all UI stuff should go on the main queue
	func runInBackgroundAsync(_ closure: @escaping () -> Void) {
		let dispatchQueue = DispatchQueue(label: "GoDBackgroundQueueAsync", qos: .background)
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







