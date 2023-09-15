//
//  XGRelocationTable.swift
//  GoD Tool
//
//  Created by The Steez on 19/10/2017.
//
//

import Foundation

func resetRelocationTables() {
	common = XGCommon()
	pocket = XGPocket()
}

var common: XGCommon!
class XGCommon: XGRelocationTable {
	convenience init() {
		self.init(file: .common_rel)
	}
	
	func getPointer(symbol: CommonIndexes) -> Int {
		return pointers[symbol.index]?.dataPointer ?? -1
	}
	
	func getPointerAddresses(symbol: CommonIndexes) -> [Int] {
		return pointers[symbol.index]?.addresses ?? []
	}

	func getSymbolLength(symbol: CommonIndexes) -> Int {
		return symbolLengths[symbol.index] ?? 0
	}

	func getValueAtPointer(symbol: CommonIndexes) -> Int {
		let startOffset = getPointer(index: symbol.index)
		return data.get4BytesAtOffset(startOffset)
	}

	func setValueAtPointer(symbol: CommonIndexes, newValue value: Int) {
		let startOffset = getPointer(index: symbol.index)
		data.replaceWordAtOffset(startOffset, withBytes: value.unsigned)
	}
	
	func expandSymbol(_ symbol: CommonIndexes, by byteCount: Int, save: Bool = false) {
		expandSymbolWithIndex(symbol.index, by: byteCount)
	}
}

var pocket = XGPocket()
class XGPocket : XGRelocationTable {
	convenience init() {
		self.init(file: .pocket_menu)
	}
	
	func getPointer(symbol: PocketIndexes) -> Int {
		return pointers[symbol.index]?.dataPointer ?? -1
	}
	
	func getPointerAddresses(symbol: PocketIndexes) -> [Int] {
		return pointers[symbol.index]?.addresses ?? []
	}

	func getSymbolLength(symbol: PocketIndexes) -> Int {
		return symbolLengths[symbol.index] ?? 0
	}

	func getValueAtPointer(symbol: PocketIndexes) -> Int {
		let startOffset = getPointer(index: symbol.index)
		return data.get4BytesAtOffset(startOffset)
	}

	func setValueAtPointer(symbol: PocketIndexes, newValue value: Int) {
		let startOffset = getPointer(index: symbol.index)
		data.replaceWordAtOffset(startOffset, withBytes: value.unsigned)
	}
	
	func expandSymbol(_ symbol: PocketIndexes, by byteCount: Int, save: Bool = false) {
		expandSymbolWithIndex(symbol.index, by: byteCount)
	}
}

class XGRelocationTable {

	private(set) var data: XGMutableData!
	private(set) var pointers = [Int : (section: Int, addresses: [Int], dataPointer: Int)]()
	private(set) var symbolLengths = [Int: Int]()
	private(set) var sections = [Int : (sectionInfoOffset: Int, sectionDataOffset: Int, isTextSection: Bool, length: Int)]()
	private(set) var imports = [Int : (importPointerOffset: Int, dataOffset: Int)]()
	private(set) var moduleID: Int?

	var header: GoDStructData!

	var isValid = true

	convenience init(file: XGFiles) {
		self.init(data: file.data ?? XGMutableData())
	}

	init(data: XGMutableData) {
		self.data = data
		parseHeader()
		parsePointers()
	}

	private func parseHeader() {
		sections = [:]
		imports = [:]
		moduleID = nil

		let numberOfSections = data.get4BytesAtOffset(0xc)
		let relVersion = data.get4BytesAtOffset(0x1c)

		let sizeOfImportTableEntry = 8
		let numberOfImportEntries = data.get4BytesAtOffset(0x2c) / sizeOfImportTableEntry

		let sectionInfoStruct = GoDStruct(name: "Section Info", format: [
			.bitMask(name: "Entry", description: "", length: .word, values: [
				(name: "File Offset", type: .uintHex, numberOfBits: 32, firstBitIndexLittleEndian: 0, mod: nil, div: 4, scale: nil),
				(name: "Unknown", type: .bool, numberOfBits: 1, firstBitIndexLittleEndian: 1, mod: nil, div: nil, scale: nil),
				(name: "Is Executable", type: .bool, numberOfBits: 1, firstBitIndexLittleEndian: 0, mod: nil, div: nil, scale: nil)
			]),
			.word(name: "Section Length", description: "", type: .uintHex)
		])

		let moduleImportStruct = GoDStruct(name: "Module Import", format: [
			.word(name: "Module ID", description: "id 0 is for Start.dol", type: .uint),
			.word(name: "File Offset", description: "", type: .uintHex)
		])

		let relHeaderStruct = GoDStruct(name: "Relocatable Module Header", format: [
			.word(name: "Module ID", description: "Unique ID for the module", type: .uint),
			.word(name: "Next Module", description: "Pointer to next module. Linked at run-time", type: .uintHex),
			.word(name: "Previous Module", description: "Pointer to previous module. Linked at run-time", type: .uintHex),
			.word(name: "Number of Sections", description: "", type: .uint),
			.pointer(property:
					.array(name: "Sections Info", description: "", property:
						.subStruct(name: "Section Info", description: "", property: sectionInfoStruct),
					count: numberOfSections),
				offsetBy: 0, isShort: false),
			.word(name: "Name Offset", description: "Has values but they don't seem to point to valid names. Sometimes poitner is beyond rel's file size", type: .uintHex),
			.word(name: "Name Length", description: "Also doesn't seem to match any kind of filename length", type: .uint),
			.word(name: "REL Version ID", description: "", type: .uint),
			.word(name: "BSS section size", description: "", type: .uintHex),
			.word(name: "Relocation Table Pointer", description: "Pointer to the relocation commands", type: .uintHex),
			.pointer(property:
					.array(name: "Module Imports", description: "", property:
						.subStruct(name: "Module Import", description: "", property: moduleImportStruct),
					count: numberOfImportEntries),
				offsetBy: 0, isShort: false),
			.word(name: "Import Table Size", description: "Each entry is 8 bytes", type: .uintHex),
			.byte(name: "Section for Prolog", description: "Index of section which contains prolog", type: .uint),
			.byte(name: "Section for Epilog", description: "Index of section which contains epilog", type: .uint),
			.byte(name: "Section for Unresolved", description: "Index of section which contains unresolved", type: .uint),
			.byte(name: "Section for BSS", description: "Index of section which contains BSS. Fille dynamically at run time", type: .uint),
			.word(name: "Prolog Offset", description: "Offset of prolog relative to the section that contains it", type: .uintHex),
			.word(name: "Epilog Offset", description: "Offset of epilog relative to the section that contains it", type: .uintHex),
			.word(name: "Unresolved Offset", description: "Offset of unresolved relative to the section that contains it", type: .uintHex),

		] + (relVersion < 2 ? [] : [
			.word(name: "Alignment", description: "Alignment constraint on all sections, expressed as power of 2.", type: .uint),
			.word(name: "BSS Alignment", description: "Alignment constraint on all '.bss' section, expressed as power of 2.", type: .uint)
		]) + (relVersion < 3 ? [] : [
			.word(name: "Fix Size", description: "If REL is linked with OSLinkFixed (instead of OSLink), the space after this address can be used for other purposes (like BSS).", type: .uintHex)
		]))

		header = GoDStructData(properties: relHeaderStruct, fileData: data, startOffset: 0)
		moduleID = header.get("Module ID")

		guard let sectionsInfo: [GoDStructData] = header.get("Sections Info") else {
			printg("Couldn't parse sections info from rel data")
			isValid = false
			return
		}

		var sections = [Int : (sectionInfoOffset: Int, sectionDataOffset: Int, isTextSection: Bool, length: Int)]()
		let firstSectionOffset = data.get4BytesAtOffset(0x10)
		let sizeOfSectionInfo = 8

		sectionsInfo.forEachIndexed { (id, data) in
			guard let dataEntry: [Int] = data.get("Entry"),
				  let sectionLength: Int = data.get("Section Length") else {
					  isValid = false
				return
			}
			sections[id] = (sectionInfoOffset: firstSectionOffset + (id * sizeOfSectionInfo), sectionDataOffset: dataEntry[0], isTextSection: dataEntry[2].boolean, length: sectionLength)
		}
		self.sections = sections

		let importsInfo: [GoDStructData] = header.get("Module Imports") ?? []

		var imports = [Int : (importPointerOffset: Int, dataOffset: Int)]()
		let firstImportOffset = data.get4BytesAtOffset(0x28)
		let sizeOfImportInfo = 8

		importsInfo.forEachIndexed { (index, data) in
			guard let moduleID: Int = data.get("Module ID"),
				  let moduleOffset: Int = data.get("File Offset") else {
					  isValid = false
				return
			}
			imports[moduleID] = (importPointerOffset: firstImportOffset + (index * sizeOfImportInfo) + 4, dataOffset: moduleOffset)
		}
		self.imports = imports
	}

	private func parsePointers() {
		pointers = [:]
		symbolLengths = [:]

		guard let relocationsOffset: Int = header.get("Relocation Table Pointer") else { return }
		var currentOffset = relocationsOffset
		var currentPointerID = 0

		while currentOffset <= data.length - 8 {
			let command = data.getByteAtOffset(currentOffset + 2)
			let sectionID = data.getByteAtOffset(currentOffset + 3)
			let symbolOffset = data.get4BytesAtOffset(currentOffset + 4)

			if command == 203 { break }

			guard let sectionStart = sections[sectionID]?.sectionDataOffset else {
				printg("Invalid section in relocation command")
				isValid = false
				return
			}
			let fileOffset = sectionStart + symbolOffset

			if command > 0 && command <= 13 {
				if let id = idForSymbol(withAddress: fileOffset) {
					var addresses = pointers[id]!.addresses
					addresses.append(currentOffset + 4)
					pointers[id] = (section: sectionID, addresses: addresses, dataPointer: fileOffset)
				} else {
					pointers[currentPointerID] = (section: sectionID, addresses: [currentOffset + 4], dataPointer: fileOffset)
					currentPointerID += 1
				}
			}

			currentOffset += 8
		}

		for (id, info) in sections where info.length > 0 && !info.isTextSection {
			let sectionstart = info.sectionDataOffset
			let sectionLength = info.length
			let sectionEnd = sectionstart + sectionLength

			let pointersInSection = pointers.keys.filter { (index) -> Bool in
				pointers[index]?.section == id
			}.sorted { (a, b) -> Bool in
				pointers[a]!.dataPointer < pointers[b]!.dataPointer
			}

			for i in 0 ..< pointersInSection.count - 1 {
				let currentSymbol = pointersInSection[i]
				let nextSymbol = pointersInSection[i + 1]
				let currentInfo = pointers[currentSymbol]!
				let nextInfo = pointers[nextSymbol]!
				let currentLength = nextInfo.dataPointer - currentInfo.dataPointer
				symbolLengths[currentSymbol] = currentLength
			}
			let lastSymbol = pointersInSection[pointersInSection.count - 1]
			let lastInfo = pointers[lastSymbol]!
			let lastLength = sectionEnd - lastInfo.dataPointer
			symbolLengths[lastSymbol] = lastLength
		}
	}

	func getPointer(index: Int) -> Int {
		return pointers[index]?.dataPointer ?? -1
	}
	
	func getPointerAddresses(index: Int) -> [Int] {
		return pointers[index]?.addresses ?? []
	}

	func getSymbolLength(index: Int) -> Int {
		return symbolLengths[index] ?? 0
	}

	func getValueAtPointer(index: Int) -> Int {
		let startOffset = getPointer(index: index)
		return data.get4BytesAtOffset(startOffset)
	}

	func setValueAtPointer(index: Int, newValue value: Int) {
		let startOffset = getPointer(index: index)
		data.replaceWordAtOffset(startOffset, withBytes: value.unsigned)
	}

	func replacePointer(index: Int, newAbsoluteOffset newOffset: Int) {
		if let info = pointers[index], let sectionInfo = sections[info.section] {
			for offset in info.addresses {
				data.replace4BytesAtOffset(offset, withBytes: newOffset - sectionInfo.sectionDataOffset)
			}
			pointers[index] = (section: info.section, addresses: info.addresses, dataPointer: newOffset)
		}
	}

	func printPointers() {
		for index in pointers.keys.sorted() {
			let pointer = getPointer(index: index)
			printg(index, pointer.hexString())
		}
	}

	func expandSymbolAtOffset(_ offset: Int, by byteCount: Int, save: Bool = false) {
		guard let symbol = idForSymbol(withAddress: offset) else {
			printg("Couldn't find symbol starting at \(offset.hexString()) in file \(data.file.path)")
			return
		}

		expandSymbolWithIndex(symbol, by: byteCount, save: save)
	}

	func expandSymbolWithIndex(_ index: Int, by byteCount: Int, save: Bool = false) {
		guard let pointerInfo = pointers[index] else {
			printg("Couldn't expand symbol \(index) of \(data.file.path). Index doesn't exist.")
			return
		}
		guard let sectionForInsertion = sections[pointerInfo.section] else {
			printg("Couldn't insert bytes into section \(pointerInfo.section) of \(data.file.path). Section doesn't exist.")
			return
		}
		guard let symbolLength = symbolLengths[index] else {
			printg("Couldn't expand symbol \(index) of \(data.file.path). Index length not found.")
			return
		}
		insertBytes(count: byteCount, at: pointerInfo.dataPointer - sectionForInsertion.sectionDataOffset + symbolLength, relativeToSectionWithID: pointerInfo.section, save: save)
	}

	func idForSymbol(withAddress address: Int) -> Int? {
		for (id, info) in pointers {
			if info.dataPointer == address {
				return id
			}
		}
		return nil
	}

	private func getInfoForSection(withIndex index: Int) -> GoDStructData? {
		guard let sections: [GoDStructData] = header.get("Sections Info"),
			  sections.count < index else { return nil }

		return sections[index]
	}

	private func insertBytes(count: Int, at offset: Int, relativeToSectionWithID sectionID: Int, save: Bool = false) {
		guard let sectionForInsertion = sections[sectionID] else {
			printg("Couldn't insert bytes into section \(sectionID) of \(data.file.path). Section doesn't exist.")
			return
		}
		var alignedCount = count
		while alignedCount % 4 != 0 {
			alignedCount += 1
		}

		let fileOffset = sectionForInsertion.sectionDataOffset + offset

		let sectionsInfoOffset = data.get4BytesAtOffset(0x10)
		if sectionsInfoOffset >= fileOffset {
			data.replace4BytesAtOffset(0x10, withBytes: sectionsInfoOffset + alignedCount)
		}

		let relocationsOffset = data.get4BytesAtOffset(0x24)
		if relocationsOffset >= fileOffset {
			data.replace4BytesAtOffset(0x24, withBytes: relocationsOffset + alignedCount)
		}

		let importsOffset = data.get4BytesAtOffset(0x28)
		if importsOffset >= fileOffset {
			data.replace4BytesAtOffset(0x28, withBytes: importsOffset + alignedCount)
		}

		let fixSize = data.get4BytesAtOffset(0x48)
		if fixSize >= fileOffset {
			data.replace4BytesAtOffset(0x48, withBytes: fixSize + alignedCount)
		}

		for (id, info) in sections {
			if info.sectionDataOffset >= fileOffset {
				data.replace4BytesAtOffset(info.sectionInfoOffset, withBytes: info.sectionDataOffset + alignedCount | (info.isTextSection ? 1 : 0))
			}
			if id == sectionID {
				data.replace4BytesAtOffset(info.sectionInfoOffset + 4, withBytes: info.length + alignedCount)
			}
		}

		for (id, info) in pointers where info.section == sectionID {
			if info.dataPointer >= fileOffset {
				replacePointer(index: id, newAbsoluteOffset: info.dataPointer + alignedCount)
			}
		}

		var extraRelocationsInserted = 0

		// parse relocation commands to check if any of them relocate addresses to the section
		// where the expansion happens itself. Rather than filling in assembly instructions
		// in epilog/prolog, some commands fill in actual data in the data sections
		// The offsets where they write to may need to be updated if they've been shifted
		var currentOffset = relocationsOffset
		var currentWriteAddress = 0
		var currentWriteSection = -1
		var writeSectionHasHadSkipInserted = false
		var importSection = 0

		while currentOffset <= data.length - 8 {
			let seekUpdate = data.get2BytesAtOffset(currentOffset)
			let command = data.getByteAtOffset(currentOffset + 2)
			let relocSectionID = data.getByteAtOffset(currentOffset + 3)

			if command == 203 {
				importSection += 1
			} else if command == 202 {
				guard let sectionStart = sections[sectionID]?.sectionDataOffset else {
					assertionFailure("Invalid section in relocation command")
					isValid = false
					return
				}

				currentWriteAddress = sectionStart
				currentWriteSection = relocSectionID
				writeSectionHasHadSkipInserted = false
			} else {
				// track offset
				if !writeSectionHasHadSkipInserted && currentWriteSection == sectionID {
					currentWriteAddress += seekUpdate
					if currentWriteAddress >= fileOffset {
						var bytesToAdd = alignedCount + seekUpdate

						while bytesToAdd > 0xFFFF {
							// add skip
							data.insertBytes(bytes: [0xFF, 0xFF, 0xC9, 0x00, 0x00, 0x00, 0x00, 0x00], atOffset: currentOffset)
							extraRelocationsInserted += importSection == 0 ? 1 : 0
							bytesToAdd -= 0xFFFF
							currentOffset += 8
						}
						data.replace2BytesAtOffset(currentOffset, withBytes: bytesToAdd)

						writeSectionHasHadSkipInserted = true
					}
				}
			}

			currentOffset += 8
		}

		guard imports.keys.count <= 2 else {
			assertionFailure("Code not written to handle updating the module import pointers when there are more than 2 sections. The extra relocations before that module need to be calculated so each module can be shifted by the right amount")
			return
		}

		for (_, info) in imports {
			if let moduleID = self.moduleID, let moduleImport = imports[moduleID], info.dataOffset > moduleImport.dataOffset {
				let extraRelocationsSize = extraRelocationsInserted * 8
				data.replace4BytesAtOffset(info.importPointerOffset, withBytes: info.dataOffset + alignedCount + extraRelocationsSize)
			} else if info.dataOffset >= fileOffset {
				data.replace4BytesAtOffset(info.importPointerOffset, withBytes: info.dataOffset + alignedCount)
			}
		}

		data.insertRepeatedByte(byte: 0, count: alignedCount, atOffset: fileOffset)

		if save {
			data.save()
		}

		parseHeader()
		parsePointers()
	}
}







