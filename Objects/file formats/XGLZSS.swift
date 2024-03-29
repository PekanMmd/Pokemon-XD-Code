//
//  XGLZSS.swift
//  XG Tool
//
//  Created by StarsMmd on 02/06/2015.
//  Copyright (c) 2015 StarsMmd. All rights reserved.
//


import Foundation

class XGLZSS {

	// ported code from QuickBMS by Luigi Auriemma
	// https://aluigi.altervista.org/quickbms.htm

	static let EI = 12
	static let EJ = 4
	static let P  = 2

	static func decode(data: XGMutableData) -> XGMutableData {
		var N = 1 << EI
		var F = 1 << EJ
		let rless = 2

		let slidingWindowSize = N
		var slidingWindow = [UInt8](repeating: 0x00, count: slidingWindowSize)

		var inputPosition = 0
		let inputBytes = data.charStream
		var outputBytes = [UInt8]()

		func readChar() -> UInt8 {
			let char = inputBytes[inputPosition]
			inputPosition += 1
			return char
		}

		var r = (N - F) - rless
		var flags: UInt = 0

		N -= 1
		F -= 1

		while inputPosition < inputBytes.count {
			if (flags & 0x100) == 0 {
				flags = UInt(readChar())
				flags |= 0xff00
			}
			if((flags & 1) != 0) {
				let c = readChar()
				outputBytes.append(c)
				slidingWindow[r] = c
				r = (r + 1) & N
			} else {
				var i = Int(readChar())
				var j = Int(readChar())

				i |= ((j >> EJ) << 8)
				j  = (j & F) + P
				for k in 0 ... j {
					let c = slidingWindow[(i + k) & N]
					outputBytes.append(c)
					slidingWindow[r] = c
					r = (r + 1) & N
				}
			}

			flags >>= 1
		}

		return XGMutableData(byteStream: outputBytes)
	}

	static func encode(data: XGMutableData) -> XGMutableData {

		if (EI < 0) || (EI >= 0xffff)
		|| (EJ < 0) || (EJ >= 31)
		|| (P  < 0) || (P  >= 0xffff) {
			return XGMutableData()
		}

		let THRESHOLD 	= 2    // encode string into position and length if match_length is greater than this
		let N 			= EI >= 16 ? EI : 1 << EI // size of ring buffer
		let F 			= (1 << EJ) + THRESHOLD   // upper limit for match_length
		let NIL         = N // index for root of binary search trees 

		let initChar: UInt8 = 0x0 // An arbitrary character that appears often

		var textBuffer = [UInt8](repeating: initChar, count: N + F - 1)	// ring buffer of size N, with extra F-1 bytes to facilitate string comparison

		// Postion of longest match.  These are set by insert(node:)
		var matchPosition = 0
		var matchLength = 0

		// left & right children & parents -- These constitute binary search trees.
		var leftChildren = [Int](repeating: 0, count: N + 1)
		var rightChildren = [Int](repeating: 0, count: N + 257)
		var parents = [Int](repeating: 0, count: N + 1)

		for i in (N + 1) ... (N + 256) {
			rightChildren[i] = NIL
		}
		for i in 0 ..< N {
			parents[i] = NIL
		}

		var inputPosition = 0
		let inputBytes = data.charStream
		var outputBytes = [UInt8]()

		func readChar() -> UInt8 {
			guard inputPosition < inputBytes.count else {
				assertionFailure("Ran out of input bytes")
				return 0
			}
			let char = inputBytes[inputPosition]
			inputPosition += 1
			return char
		}

		func insert(node: Int) {
			/* Inserts string of length F, text_buf[r..r+F-1], into one of the
			trees (text_buf[node]'th tree) and returns the longest-match position
			and length via the global variables match_position and match_length.
			If match_length = F, then removes the old node in favor of the new
			one, because the old one will be deleted sooner.
			Note 'node' plays double role, as tree node and position in buffer. */

			var cmp = 1
			let key = Array(textBuffer.suffix(from: node))
			var parent = N + 1 + Int(key[0])

			rightChildren[node] = NIL
			leftChildren[node] = NIL
			matchLength = 0

			while true {
				if (cmp >= 0) {
					if rightChildren[parent] != NIL {
						parent = rightChildren[parent]
					} else {
						rightChildren[parent] = node
						parents[node] = parent
						return
					}
				} else {
					if leftChildren[parent] != NIL {
						parent = leftChildren[parent]
					} else {
						leftChildren[parent] = node
						parents[node] = parent
						return
					}
				}

				var i = 1
				while i < F {
					cmp = Int(key[i]) - Int(textBuffer[parent + i])
					if cmp != 0 {
						break
					}
					i += 1
				}
				if i > matchLength {
					matchPosition = parent
					matchLength = i
					if matchLength >= F {
						break
					}
				}
			}

			parents[node] = parents[parent]
			leftChildren[node] = leftChildren[parent]
			rightChildren[node] = rightChildren[parent]

			parents[leftChildren[parent]] = node
			parents[rightChildren[parent]] = node

			if rightChildren[parents[parent]] == parent {
				rightChildren[parents[parent]] = node
			} else {
				leftChildren[parents[parent]] = node
			}

			parents[parent] = NIL
		}

		func delete(node: Int) {
			var newChild = 0

			guard parents[node] != NIL else {
				// node isn't in tree
				return
			}

			if rightChildren[node] == NIL {
				newChild = leftChildren[node]
			} else if leftChildren[node] == NIL {
				newChild = rightChildren[node]
			} else {
				newChild = leftChildren[node]
				if rightChildren[newChild] != NIL {
					repeat {
						newChild = rightChildren[newChild]
					} while rightChildren[newChild] != NIL

					rightChildren[parents[newChild]] = leftChildren[newChild]
					parents[leftChildren[newChild]] = parents[newChild]
					leftChildren[newChild] = leftChildren[node]
					parents[leftChildren[node]] = newChild
				}
				rightChildren[newChild] = rightChildren[node]
				parents[rightChildren[node]] = newChild
			}
			parents[newChild] = parents[node]

			if rightChildren[parents[node]] == node {
				rightChildren[parents[node]] = newChild
			} else {
				leftChildren[parents[node]] = newChild
			}

			parents[node] = NIL
		}


		/* codeBuffer[1..16] stores eight units of code, and
		 * code_buf[0] works as eight flags, "1" representing that the unit
		 * is an unencoded letter (1 byte), "0" a position-and-length pair
		 * (2 bytes).  Thus, eight units require at most 16 bytes of code.
		 */
		var codeBuffer: [UInt8] = [0]
		var mask: UInt8 = 1

		var length = min(F, inputBytes.count)
		if length == 0 { return XGMutableData() }
		
		var r = N - F
		var s = 0
		var lastMatchLength = 0

		// Read F bytes into the last F bytes of the buffer
		for i in 0 ..< length {
			textBuffer[r + i] = readChar()
		}

		for i in 1 ... F {
			/* Insert the F strings,
			 * each of which begins with one or more 'space' characters.  Note
			 * the order in which these strings are inserted.  This way,
			 * degenerate trees will be less likely to occur.
			 */
			insert(node: r - i)
		}

		// Finally, insert the whole string just read. The global variables match_length and match_position are set.
		insert(node: r)

		repeat {
			if matchLength > length {
				matchLength = length // match_length may be spuriously long near the end of text. */
			}

			if matchLength <= THRESHOLD {
				// Not long enough match.  Send one byte.
				matchLength = 1
				codeBuffer[0] |= mask  // 'send one byte' flag
				codeBuffer.append(textBuffer[r])  // Send uncoded.
			} else {
				// Send position and length pair. Note match_length > THRESHOLD.
				codeBuffer.append(UInt8(matchPosition & 0xFF))
				codeBuffer.append(UInt8(((matchPosition >> 4) & 0xf0) | (matchLength - (THRESHOLD + 1))))
			}


			if mask == 0x80 {
				outputBytes += codeBuffer
				codeBuffer = [0]
				mask = 1
			} else {
				mask <<= 1
			}
			lastMatchLength = matchLength

			var lastMatchCutOff = 0
			for _ in 0 ..< lastMatchLength {
				guard inputPosition < inputBytes.count else { break }
				let c = readChar()
				delete(node: s) // delete old strings
				textBuffer[s] = c // read new bytes

				// If the position is near the end of buffer, extend the buffer to make string comparison easier.
				if s < F - 1 {
					textBuffer[s + N] = c
				}

				// Since this is a ring buffer, increment the position modulo N.
				s = (s + 1) % N
				r = (r + 1) % N
				insert(node: r) // Register the string in text_buf[r..r+F-1]
				lastMatchCutOff += 1
			}

			// After the end of text no need to read, but buffer may not be empty.
			while lastMatchCutOff < lastMatchLength {
				delete(node: s)
				s = (s + 1) % N
				r = (r + 1) % N

				length -= 1
				if length != 0 {
					insert(node: r)
				}
				lastMatchCutOff += 1
			}
		} while length > 0	// until length of string to be processed is zero

		// Send remaining code.
		if (codeBuffer.count > 1) {
			outputBytes += codeBuffer
		}

		let header = kLZSSbytes.charArray + inputBytes.count.charArray + (outputBytes.count + 0x10).charArray + 0.charArray
		return XGMutableData(byteStream: header + outputBytes)
	}
}



