//
//  XGStringTableReference.swift
//  XG Tool
//
//  Created by StarsMmd on 19/05/2015.
//  Copyright (c) 2015 StarsMmd. All rights reserved.
//

import Foundation

let kNumberOfStringsOffset = 0x04
let kEndOfHeader		   = 0x10

class XGStringTable: NSObject, XGDictionaryRepresentable {
	
	var file = XGFiles.nameAndFolder("", .Documents)
	var startOffset = 0x0
	var stringTable = XGMutableData()
	var stringOffsets = [Int : Int]()
	
	var numberOfEntries : Int {
		get {
			return stringTable.get2BytesAtOffset(kNumberOfStringsOffset)
		}
	}
	
	var fileSize : Int {
		get {
			return self.stringTable.length
		}
	}
	
	var extraCharacters : Int {
		
		get {
			var currentChar = 0x00
			var currentOffset = fileSize - 3 // the file always ends in 0x0000 to end its last string so it isn't included
			
			var length = 0
			
			while currentChar == 0x00 {
				
				currentChar = stringTable.getByteAtOffset(currentOffset)
				
				if currentChar == 0x00 { length += 1 }
				
				currentOffset -= 1
				
			}
			
			return length
		}
		
	}
	
	class func common_rel() -> XGStringTable {
		
		return XGStringTable(file: .common_rel, startOffset: 0x04E274, fileSize: 0x0DC70)
		
	}
	
	class func tableres2() -> XGStringTable {
		
		return XGStringTable(file: .tableres2, startOffset: 0x048F88, fileSize: 0x16E84)
		
	}
	
	class func dol() -> XGStringTable {
		
		return  XGStringTable(file: .dol, startOffset: 0x374FC0, fileSize: 0x178BE)
		
	}
	
	class func dol2() -> XGStringTable {
		
		return  XGStringTable(file: .dol, startOffset: 0x38c7c4, fileSize: 0x41c)
		
	}
	
	class func common_relOriginal() -> XGStringTable {
		
		return XGStringTable(file: .original(.common_rel), startOffset: 0x04E274, fileSize: 0x0DC70)
		
	}
	
	class func tableres2Original() -> XGStringTable {
		
		return XGStringTable(file: .original(.tableres2), startOffset: 0x048F88, fileSize: 0x16E84)
		
	}
	
	class func dolOriginal() -> XGStringTable {
		
		return  XGStringTable(file: .original(.dol), startOffset: 0x374FC0, fileSize: 0x178BE)
		
	}
	
	class func dol2Original() -> XGStringTable {
		
		return  XGStringTable(file: .original(.dol), startOffset: 0x38c7c4, fileSize: 0x41c)
		
	}
	
	init(file: XGFiles, startOffset: Int, fileSize: Int) {
		super.init()
		
		self.file = file
		self.startOffset = startOffset
		self.stringTable = XGMutableData(byteStream: file.data.charStream, file: file)
		
		stringTable.deleteBytesInRange(NSMakeRange(0, startOffset))
		stringTable.deleteBytesInRange(NSMakeRange(fileSize, stringTable.length - fileSize))
		
		getOffsets()
	}
	
	func save() {
		
		let data = file.data
		
		data.replaceBytesFromOffset(self.startOffset, withByteStream: stringTable.byteStream)
		
		data.save()
		
	}
	
	func getOffsets() {
		
		var currentOffset = kEndOfHeader
		
		for _ in 0 ..< numberOfEntries {
			
			let id = stringTable.get4BytesAtOffset(currentOffset)
			
			currentOffset += 4
			
			let offset = stringTable.get4BytesAtOffset(currentOffset)
			
			self.stringOffsets[Int(id)] = Int(offset)
			
			currentOffset += 4
			
		}
		
	}
	
	func updateOffsets() {
		
		var currentOffset = kEndOfHeader
		
		var sids = [Int]()
		
		for (sid, _) in self.stringOffsets {
			sids.append(sid)
		}
		
		sids.sort{$0 < $1}
		
		for sid in sids {
			
			stringTable.replace4BytesAtOffset(currentOffset, withBytes: UInt32(sid))
			
			currentOffset += 4
			
			stringTable.replace4BytesAtOffset(currentOffset, withBytes: UInt32(stringOffsets[sid]!))
			
			currentOffset += 4
			
		}
		
	}
	
	
	
	func decreaseOffsetsAfter(_ offset: Int, byCharacters characters: Int) {
		
		for (sid, off) in self.stringOffsets {
			
			if off > offset {
				stringOffsets[sid] = off - characters
			}
		}
		
	}
	
	func increaseOffsetsAfter(_ offset: Int, byCharacters characters: Int) {
		
		for (sid, off) in self.stringOffsets {
			
			if off > offset {
				stringOffsets[sid] = off + characters
			}
		}
		
	}
	
	func offsetForStringID(_ stringID : Int) -> Int? {
		
		return self.stringOffsets[stringID]
	}
	
	func endOffsetForStringId(_ stringID : Int) -> Int {
		
		let startOff = offsetForStringID(stringID)!
		
		let text = stringWithID(stringID)!
		
		return startOff + text.dataLength
		
	}
	
	func getStringAtOffset(_ offset: Int) -> XGString {
		
		var currentOffset = offset
		
		var currChar = 0x0
		var nextChar = 0x1
		
		let string = XGString(string: "", file: self.file, sid: 0)
		
		while (nextChar != 0x00) {
			
			if currentOffset + 2 > fileSize {
				nextChar = 0x0
				break
			}
			
			currChar = stringTable.get2BytesAtOffset(currentOffset)
			currentOffset += 2
			
			
			// These are special characters used by the game. Similar to escape sequences like \n or \t for newlines and tabs.
			// It is to be hoped that we'll be able to figure out what they all mean eventually.
			if currChar == 0xFFFF {
				
				let sp = XGSpecialCharacters(rawValue: stringTable.getByteAtOffset(currentOffset))!
				currentOffset += 1
				
				let extra = sp.extraBytes
				
				let stream = stringTable.getByteStreamFromOffset(currentOffset, length: extra)
				currentOffset += extra
				
				string.append(.special(sp, stream))
				
			} else {
			// This is a regular character so read normally.
				
				string.append(.unicode(currChar))
			}
			
			nextChar = stringTable.get2BytesAtOffset(currentOffset)
			
		}
		
		return string
		
	}
	
	func stringWithID(_ stringID: Int) -> XGString? {
		
		let offset = offsetForStringID(stringID)
		
		if offset != nil {
			
			let string = getStringAtOffset(offset!)
			string.id = stringID
			return string
			
		}
		
		return nil
	}
	
	func stringSafelyWithID(_ stringID: Int) -> XGString {
		
		let string = stringWithID(stringID)
		
		return string ?? XGString(string: "-", file: .nameAndFolder("",.Documents), sid: 0)
	}
	
	func containsStringWithId(_ stringID: Int) -> Bool {
		
			return stringOffsets.index(forKey: stringID) != nil
		
	}
	
	func allStrings() -> [XGString] {
		
		var strings = [XGString]()
		
		for (sid, _) in self.stringOffsets {
			
			let string = self.stringSafelyWithID(sid)
			strings.append(string)
			
		}
		return strings
	}
	
	func purge() {
		
		let strings = allStrings()
		for str in strings {
			
			let string = XGString(string: "-", file: self.file, sid: str.id)
			
			let copyStream = self.stringTable.getCharStreamFromOffset(0, length: self.stringOffsets[str.id]!)
			
			let dataCopy = XGMutableData(byteStream: copyStream, file: self.file)
			
			let oldText = self.stringWithID(str.id)!
			let difference = string.dataLength - oldText.dataLength
			
			if difference <= self.extraCharacters {
				
				let stream = string.byteStream
				
				dataCopy.appendBytes(stream)
				
				
				let oldEnd = self.endOffsetForStringId(string.id)
				
				let newEnd = stringTable.getCharStreamFromOffset(oldEnd, length: fileSize - oldEnd)
				
				let endData = XGMutableData(byteStream: newEnd, file: self.file)
				
				dataCopy.appendBytes(endData.charStream)
				
				if string.dataLength > oldText.dataLength {
					
					for _ in 0 ..< difference {
						
						let currentOff = dataCopy.length - 1
						let range = NSMakeRange(currentOff, 1)
						
						dataCopy.deleteBytesInRange(range)
						
					}
					
					self.increaseOffsetsAfter(stringOffsets[string.id]!, byCharacters: difference)
				}
				
				if string.dataLength < oldText.dataLength {
					
					let difference = oldText.dataLength - string.dataLength
					var emptyByte : UInt8 = 0x0
					
					for _ in 0 ..< difference {
						
						dataCopy.data.append(&emptyByte, length: 1)
						
					}
					
					self.decreaseOffsetsAfter(stringOffsets[string.id]!, byCharacters: difference)
				}
				
			}
			
			self.stringTable = dataCopy
			self.updateOffsets()
			
		}
		
		self.save()
		printg("Purged String Table:",self.file.fileName)
		
		
	}
	
	func printAllStrings() {
		for string in self.allStrings() {
			print(string.string,"\n")
		}
	}
	
	class func jsonFromTrainerNames() {
		var dict = [ String : String ]()
		
		let decks : [XGDecks] = [XGDecks.DeckStory, XGDecks.DeckHundred, XGDecks.DeckColosseum, XGDecks.DeckVirtual]
		
		for deck in decks {
			
			print("-------------------------------")
			print("-------------------------------")
			print("-------------------------------")
			print("starting deck:" + deck.fileName)
			print("-------------------------------")
			
			let numTr = deck.DTNREntries
			print("Entries: \(numTr)")
			print("-------------------------------")
			
			for i in 1 ..< numTr {
				
				let tr = XGTrainer(index: i, deck: .DeckStory)
				
				dict[tr.name.string] = "\(tr.nameID)"
				
			}
			
		}
		
		var arr = [ [String] ]()
		
		for k in dict.keys {
			arr.append([ k, dict[k]! ])
		}
		
		arr = arr.sorted { $0[0] < $1[0] }
		
		do {
			let data = try JSONSerialization.data(withJSONObject: arr, options: .prettyPrinted)
			
			let saved = (try? data.write(to: URL(fileURLWithPath: XGFolders.JSON.path + "/Trainers.json"), options: [.atomic])) != nil
			print("-------------------------------")
			print("saved = \(saved)")
			print("-------------------------------")
			print("-------------------------------")
			print("-------------------------------")
			
		} catch {
			
		}
	}
	
	class func trainerNamesFromJSON() {
		
		do {
			let data : [ [String] ] = try JSONSerialization.jsonObject( with: Data(contentsOf: URL(fileURLWithPath: XGFiles.nameAndFolder("Trainers.json", .JSON).path)), options: []) as! [[String]]
			print("\(data)")
			
			for d in data {
				XGFiles.common_rel.stringTable.replaceString(XGString(string: d[0], file: .common_rel, sid: Int(d[1]) ), alert: false)
			}
			
		} catch {
			
		}
		
	}
	
	var dictionaryRepresentation: [String : AnyObject] {
		get {
			let strings = self.allStrings()
			
			var strArray = [ [String : String] ]()
			
			for str in strings {
				
				strArray.append(["\(str.id)" : str.string])
				
			}
			
			var dictRep = [String : AnyObject]()
			
			dictRep["fileName"] = self.file.fileName as AnyObject
			dictRep["numberOfStrings"] = self.numberOfEntries as AnyObject
			dictRep["spareCharacters"] = self.extraCharacters as AnyObject?
			
			return ["metadata" : dictRep as AnyObject, "strings" : strArray as AnyObject]
		}
	}
	
	var readableDictionaryRepresentation: [String : AnyObject] {
		get {
			let strings = self.allStrings()
			
			var strArray = [ [String : String] ]()
			
			for str in strings {
				
				strArray.append([String(format: "0x%x", str.id) : str.string])
				
			}
			
			var dictRep = [String : AnyObject]()
			
			dictRep["fileName"] = self.file.fileName as AnyObject
			dictRep["numberOfStrings"] = self.numberOfEntries as AnyObject
			dictRep["spareCharacters"] = self.extraCharacters as AnyObject?
			
			let rep = [ ["metadata" : dictRep as AnyObject], ["strings" : strArray as AnyObject] ]
			
			return [self.file.fileName : rep as AnyObject]
		}
	}
	
}











