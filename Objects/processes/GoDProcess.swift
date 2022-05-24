//
//  GoDProcess.swift
//  GoD Tool
//
//  Created by Stars Momodu on 27/09/2021.
//

import Foundation
#if canImport(Darwin)
import Darwin
#elseif canImport(Glibc)
import Glibc
#endif

struct VMRegionInfo {
	let virtualAddress: UInt
	let size: UInt
}

#if canImport(Darwin)
class GoDProcess {
	private let process: Process

	private var task: mach_port_name_t?
	private var baseAddress: vm_address_t?

	var pid: Int32 {
		return process.processIdentifier
	}

	var isRunning: Bool {
		return process.isRunning
	}

	private var threads: [thread_act_t] {
		guard let task = self.task else {
			printg("Couldn't get threads for unloaded process")
			return []
		}
		var threadList: thread_act_array_t?
		var threadCount: mach_msg_type_number_t = 0
		let kret = task_threads(task, &threadList, &threadCount)
		guard kret == KERN_SUCCESS,
			  let threads = threadList else {
			printg("Couldn't load process threads for pid: \(pid). You may need to run the app with root permissions.")
			return []
		}
		var threadArray = [thread_act_t]()
		for i in 0 ..< threadCount.int {
			threadArray.append(threads[i])
		}
		return threadArray
	}

	init(process: Process) {
		self.process = process
		load()
	}

	func await() {
		process.waitUntilExit()
	}

	func terminate() {
		process.terminate()
	}

	func pause() {
		process.suspend()
	}

	func resume() {
		process.resume()
	}

	func readVirtualMemory(at offset: UInt, length: UInt, relativeToRegion region: VMRegionInfo? = nil) -> XGMutableData? {
		guard let task = self.task, let baseAddress = self.baseAddress else {
			if XGSettings.current.verbose {
				printg("Couldn't read virtual memory for unloaded process")
			}
			return nil
		}

		let relativeToAddress = region?.virtualAddress ?? baseAddress

		var pointer: vm_offset_t = 0
		var sizeRead: mach_msg_type_number_t = 0
		var kret = vm_read(task, relativeToAddress + offset, length, &pointer, &sizeRead)
		guard kret == KERN_SUCCESS else {
			if XGSettings.current.verbose {
				printg("Couldn't read virtual memory for process: \(pid). Length: \(length)")
				printg(kret == KERN_INVALID_ADDRESS ? "Invalid Address" : "KRETURN:\(kret)")
			}
			return nil
		}
		
		guard let rawPointer = UnsafeRawPointer.init(bitPattern: pointer) else {
			return nil
		}
		let data = Data(bytes: rawPointer, count: sizeRead.int)
		kret =  vm_deallocate(mach_task_self_, pointer, vm_size_t(sizeRead))
		if kret != KERN_SUCCESS {
			printg("Couldn't free virtual memory for process: \(pid). Length: \(length)")
			printg(kret == KERN_INVALID_ADDRESS ? "Invalid Address" : "KRETURN:\(kret)")
		}

		return XGMutableData(data: data)
	}

	@discardableResult
	func writeVirtualMemory(at offset: UInt, data: XGMutableData, relativeToRegion region: VMRegionInfo? = nil) -> Bool {
		guard let task = self.task, let baseAddress = self.baseAddress else {
			if XGSettings.current.verbose {
				printg("Couldn't write virtual memory for unloaded process")
			}
			return false
		}

		let relativeToAddress = region?.virtualAddress ?? baseAddress

		var rawBytes = data.rawBytes
		let count = rawBytes.count
		let buffer = UnsafeMutableRawPointer.allocate(byteCount: data.length, alignment: 4)
		memcpy(buffer, &rawBytes, count)
		let pointer: vm_offset_t = UInt(bitPattern: buffer)
		
		let kret = vm_write(task, relativeToAddress + offset, pointer, count.unsigned)
		if kret != KERN_SUCCESS {
			if XGSettings.current.verbose {
				printg("Couldn't write virtual memory for process: \(pid).", kret)
				if kret == KERN_INVALID_ADDRESS {
					print("Invalid Address")
				}
			}
		}
		buffer.deallocate()
		return kret == KERN_SUCCESS
	}

	func getNextRegion(fromOffset offset: UInt) -> VMRegionInfo? {
		guard let task = self.task else {
			printg("Couldn't scan virtual memory for unloaded process")
			return nil
		}

		let VM_REGION_BASIC_INFO_COUNT_64 = MemoryLayout<vm_region_basic_info_data_64_t>.size/4
		var info: [Int32] = [Int32](repeating: 0, count: VM_REGION_BASIC_INFO_COUNT_64)

		var size: mach_vm_size_t = 0
		var object_name: mach_port_t = 0
		var count: mach_msg_type_number_t = VM_REGION_BASIC_INFO_COUNT_64.unsigned
		var address: mach_vm_address_t = mach_vm_address_t(offset)

		let kret = mach_vm_region(task, &address, &size, VM_REGION_BASIC_INFO, &info, &count, &object_name)
		guard kret == KERN_SUCCESS else {
			if XGSettings.current.verbose {
				printg("Couldn't load base address for task: \(task).")
				printg("Error no:", kret)
			}
			return nil
		}

		return VMRegionInfo(virtualAddress: vm_address_t(address), size: UInt(size))
	}

	func getRegions(maxOffset: UInt) -> [VMRegionInfo] {
		var regions = [VMRegionInfo]()

		var totalSize: UInt = 0
		var lastRegion: VMRegionInfo?

		 repeat {
			var searchFromAddres: UInt = 0
			if let region = lastRegion {
				searchFromAddres = region.virtualAddress + region.size
			}
			lastRegion = getNextRegion(fromOffset: searchFromAddres)
			if let region = lastRegion {
				regions.append(region)
				totalSize += region.size
			}
		} while lastRegion != nil && totalSize < maxOffset

		return regions
	}

	private func load() {
		// You may need to run the app with root permissions
		var task: mach_port_name_t = 0
		let kret = task_for_pid(mach_task_self_, pid, &task)
		guard kret == KERN_SUCCESS else {
			printg("Couldn't load process for pid: \(pid). You may need to run the app with root permissions.")
			printg("K Return:", kret)
			return
		}
		self.task = task

		guard let baseAddress = GoDProcess.getBaseAddress(forTask: task) else {
			return
		}
		self.baseAddress = baseAddress
	}

	private static func getBaseAddress(forTask task: mach_port_t) -> vm_address_t? {
		let VM_REGION_BASIC_INFO_COUNT_64 = MemoryLayout<vm_region_basic_info_data_64_t>.size/4

		var info: [Int32] = [Int32](repeating: 0, count: VM_REGION_BASIC_INFO_COUNT_64)
		var size: mach_vm_size_t = 0

		var object_name: mach_port_t = 0
		var count: mach_msg_type_number_t = VM_REGION_BASIC_INFO_COUNT_64.unsigned
		var address: mach_vm_address_t = 1

		let kret = mach_vm_region(task, &address, &size, VM_REGION_BASIC_INFO, &info, &count, &object_name);
		guard kret == KERN_SUCCESS else {
			printg("Couldn't load base address for task: \(task). Make sure the application is running and the tool is running with root permissions.")
			return nil
		}

		return UInt(address)
	}
}
#elseif canImport(Glibc) && os(Linux)
class GoDProcess {
	private let process: Process
	private let fileDescriptor: Int32

	var pid: Int32 {
		return process.processIdentifier
	}

	var isRunning: Bool {
		return process.isRunning
	}

	init(process: Process) {
		self.process = process
		self.fileDescriptor = open("/proc/\(process.processIdentifier)/mem", O_RDWR)
	}

	func await() {
		process.waitUntilExit()
		close(self.fileDescriptor)
	}

	func terminate() {
		process.terminate()
		close(self.fileDescriptor)
	}

	func pause() {
		process.suspend()
	}

	func resume() {
		process.resume()
	}

	func readVirtualMemory(at offset: UInt, length: UInt, relativeToRegion region: VMRegionInfo? = nil) -> XGMutableData? {
		var address = offset
		if let regionInfo = region {
			address += regionInfo.virtualAddress
		}
		var buffer = [UInt8](repeating: 0, count: Int(length))
		let bytesRead = pread(self.fileDescriptor, &buffer, Int(length), Int(address))
		let data = XGMutableData(byteStream: buffer)
		return data
	}
	
	@discardableResult
	func writeVirtualMemory(at offset: UInt, data: XGMutableData, relativeToRegion region: VMRegionInfo? = nil) -> Bool {
		var address = offset
		if let regionInfo = region {
			address += regionInfo.virtualAddress
		}
		let bytes = data.rawBytes
		let bytesWritten = pwrite(self.fileDescriptor, &bytes, Int(data.length), Int(address))
		return bytesWritten != -1
	}
	
	func getNextRegion(fromOffset offset: UInt) -> VMRegionInfo? {
		let processFile = XGFiles.path("/proc/\(pid)/maps")
		if processFile.exists {
			let text = processFile.text
			let lines = text.split(separator: "\n")
			for line in lines {
				let parts = line.split(separator: " ")
				if parts.count > 0 {
					let addressRange = parts[0]
					let addressParts = addressRange.split(separator: "-")
					if addressParts.count > 1 {
						let startAddress = UInt(String(addressParts[0]).hexStringToInt())
						let endAddress = UInt(String(addressParts[1]).hexStringToInt())
						if offset <= startAddress {
							let length = endAddress - startAddress
							return VMRegionInfo(virtualAddress: startAddress, size: length)
						}
					}
				}
			}
		} else {
			print("file doesn't exist:", processFile.path)
		}
		return nil
	}
	
	func getRegions(maxOffset: UInt) -> [VMRegionInfo] {
		var regions = [VMRegionInfo]()
		
		var totalSize: UInt = 0
		var lastRegion: VMRegionInfo?
		
		repeat {
			var searchFromAddres: UInt = 0
			if let region = lastRegion {
				searchFromAddres = region.virtualAddress + region.size
			}
			lastRegion = getNextRegion(fromOffset: searchFromAddres)
			if let region = lastRegion {
				regions.append(region)
				totalSize += region.size
			}
		} while lastRegion != nil && totalSize < maxOffset
		
		return regions
	}
}
#else
class GoDProcess {
	private let process: Process

	var pid: Int32 {
		return process.processIdentifier
	}

	var isRunning: Bool {
		return process.isRunning
	}

	init(process: Process) {
		self.process = process
	}

	func await() {
		process.waitUntilExit()
	}

	func terminate() {
		process.terminate()
	}

	func pause() {
		process.suspend()
	}

	func resume() {
		process.resume()
	}

	func readVirtualMemory(at offset: UInt, length: UInt, relativeToRegion region: VMRegionInfo? = nil) -> XGMutableData? {
		return nil
	}

	@discardableResult
	func writeVirtualMemory(at offset: UInt, data: XGMutableData, relativeToRegion region: VMRegionInfo? = nil) -> Bool {
		return false
	}

	func getNextRegion(fromOffset offset: UInt) -> VMRegionInfo? {
		return nil
	}

	func getRegions(maxOffset: UInt) -> [VMRegionInfo] {
		return []
	}
}
#endif
