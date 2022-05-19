//
//  GoDOffsetIO.swift
//  GoD Tool
//
//  Created by Stars Momodu on 11/05/2022.
//

import Foundation

class GoDOffsetIO: GoDReadWritable {
	fileprivate let ioOffset: Int
	private let readWritable: GoDReadWritable
	
	init(io: GoDReadWritable, offset: Int = 0) {
		self.readWritable = io
		self.ioOffset = offset
	}
	
	func read(atAddress address: UInt, length: UInt) -> XGMutableData? {
		return readWritable.read(atAddress: address + UInt(ioOffset), length: length)
	}
	
	func write(_ data: XGMutableData, atAddress address: UInt) -> Bool {
		return readWritable.write(data, atAddress: address + UInt(ioOffset))
	}
}

/// Read and write addresses in Start.dol but shift to the equivalent address in RAM
class GoDDolToRAMIO: GoDOffsetIO {
	init(io: GoDReadWritable) {
		super.init(io: io, offset: kDolToRAMOffsetDifference)
	}
}

/// Read and write addresses in Start.dol in RAM but shift to the equivalent address in the file
class GoDDolFromRAMIO: GoDOffsetIO {
	init(io: GoDReadWritable) {
		super.init(io: io, offset: -kDolToRAMOffsetDifference)
	}
}

/// Read and write addresses in Common.rel but shift to the equivalent address in RAM
class GoDRelToRAMIO: GoDOffsetIO {
	init(io: GoDReadWritable) {
		super.init(io: io, offset: kRELtoRAMOffsetDifference)
	}
}

/// Read and write addresses in Common.rel in RAM but shift to the equivalent address in the file
class GoDRelFromRAMIO: GoDOffsetIO {
	init(io: GoDReadWritable) {
		super.init(io: io, offset: -kRELtoRAMOffsetDifference)
	}
}
