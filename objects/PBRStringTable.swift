//
//  PBRStringTable.swift
//  XGCommandLineTools
//
//  Created by StarsMmd on 05/03/2016.
//  Copyright © 2016 StarsMmd. All rights reserved.
//

import Foundation

class PBRStringTable: NSObject {

	var file = XGFiles.nameAndFolder("", .Documents)
	var startOffset = 0x0
	var stringTable = XGMutableData()
	var stringOffsets = [Int : Int]()
	
	var numberOfEntries : Int {
		get {
			return Int(stringTable.getWordAtOffset(kNumberOfStringsOffset))
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
	
	class func common() -> PBRStringTable {
		return PBRStringTable(file: XGFiles.msg("common"), startOffset: 0, fileSize: 0xb605e)
	}
	
	init(file: XGFiles, startOffset: Int, fileSize: Int) {
		super.init()
		
		self.file = file
		self.startOffset = startOffset
		self.stringTable = file.data!
		
		stringTable.deleteBytesInRange(NSMakeRange(0, startOffset))
		stringTable.deleteBytesInRange(NSMakeRange(fileSize, stringTable.length - fileSize))
		
		getOffsets()
	}
	
	func save() {
		
		let data = file.data!
		
		data.replaceBytesFromOffset(self.startOffset, withByteStream: stringTable.byteStream)
		
		data.save()
		
	}
	
	func getOffsets() {
		
		var currentOffset = kEndOfHeader
		
		for i in 0 ..< numberOfEntries {
			
			let id = i + 1
			
			let offset = stringTable.getWordAtOffset(currentOffset)
			
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
			
			stringTable.replaceWordAtOffset(currentOffset, withBytes: UInt32(sid))
			
			currentOffset += 4
			
			stringTable.replaceWordAtOffset(currentOffset, withBytes: UInt32(stringOffsets[sid]!))
			
			currentOffset += 4
			
		}
		
	}
	
	func replaceString(_ string: XGString, alert: Bool) -> Bool {
		
		let copyStream = self.stringTable.getCharStreamFromOffset(0, length: self.stringOffsets[string.id]!)
		
		let dataCopy = XGMutableData(byteStream: copyStream, file: self.file)
		
		let oldText = self.stringWithID(string.id)!
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
			
			self.stringTable = dataCopy
			
			self.updateOffsets()
			self.save()
			
			if alert {
				//				XGAlertView(title: "String Replacement", message: "The string replacement was successful.", doneButtonTitle: "Sweet", otherButtonTitles: nil, buttonAction: nil).show()
			}
			
			return true
			
		} else {
			if alert {
				//				XGAlertView(title: "String Replacement", message: "The new string was too long. String replacement was aborted.", doneButtonTitle: "Cool", otherButtonTitles: nil, buttonAction: nil).show()
			}
		}
		
		return false
	}
	
	
	fileprivate func decreaseOffsetsAfter(_ offset: Int, byCharacters characters: Int) {
		
		for (sid, off) in self.stringOffsets {
			
			if off > offset {
				stringOffsets[sid] = off - characters
			}
		}
		
	}
	
	fileprivate func increaseOffsetsAfter(_ offset: Int, byCharacters characters: Int) {
		
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
		
		var string = XGString(string: "", file: self.file, sid: 0)
		
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
				
				let sp = stringTable.get2BytesAtOffset(currentOffset)
				
				if sp == 0xFFFF {
					return string
				}
				
				if sp == 0xFFFE {
					string = XGString(string: (string.string + "{newline}"), file: self.file, sid: 0)
				} else {
					string = XGString(string: (string.string + String(format: "{%x}", sp)), file: self.file, sid: 0)
				}
				
				currentOffset += 2
//				let sp = XGSpecialCharacters(rawValue: stringTable.getByteAtOffset(currentOffset))!
//				currentOffset++
//				
//				let extra = sp.extraBytes
//				
//				let stream = stringTable.getByteStreamFromOffset(currentOffset, length: extra)
//				currentOffset += extra
//				
//				string.append(.Special(sp, stream))
				
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
		
		print("Purged Table")
		
		
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
	
//	class func trainerNamesFromJSON() {
//
//		do {
//			let data : [ [String] ] = try JSONSerialization.jsonObject( with: Data(contentsOf: URL(fileURLWithPath: XGFiles.nameAndFolder("Trainers.json", .JSON).path)), options: []) as! [[String]]
//			print("\(data)")
//
//			for d in data {
//				XGStringTable.common_rel().replaceString(XGString(string: d[0], file: .common_rel, sid: Int(d[1]) ), alert: false, save: true)
//			}
//
//		} catch {
//
//		}
//
//	}
	
}
