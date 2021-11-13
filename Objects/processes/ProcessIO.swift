//
//  ProcessIO.swift
//  GoD Tool
//
//  Created by Stars Momodu on 27/10/2021.
//

import Foundation

protocol ProcessIO: GoDReadWritable {

	// Queried to check if the process is still running
	var isRunning: Bool { get }
	// Kill the process
	func terminate()

	// Main IO interface. Convenience methods are implemented in an extension of this protocol;
	// they wrap around these main functions to allow easier IO for specific types such as integers, strings or assembly.
	@discardableResult
	func write(_ data: XGMutableData, atAddress address: UInt) -> Bool
	func read(atAddress address: UInt, length: UInt) -> XGMutableData?

	// If the process doesn't have state save capability, set the var to false and the functions can have dummy implementations
	var canUseSavedStates: Bool { get }
	func saveStateToSlot(_ slot: Int)
	func loadStateFromSlot(_ slot: Int)

	/// The main entry point into the process. This function should be used to start up and hook into the process being watched.
	/// There is a simple life cycle of `start > updates loop > finish` during which the closures passed in should be executed as
	/// appropriate so the object manipulating this process can perform IO requests.
	///
	/// Parameters:
	/// **onStart** - The process should call this closure once when it has finished preparing for execution.
	/// 			  The process should be ready to receive IO requests during this closure's execution.
	/// **onUpdate** - The process should call this closure once every cycle of its run loop.
	/// 			   The process should be ready to receive IO requests during this closure's execution.
	/// **onFinish** - The process should call this closure once when it has stopped running.
	/// 			   The process should not expect any IO requests during this closure's execution.
	func begin(onStart: ((ProcessIO) -> Bool)?,
					   onUpdate: ((ProcessIO) -> Bool)?,
					   onFinish: ((ProcessIO?) -> Void)?)
}
