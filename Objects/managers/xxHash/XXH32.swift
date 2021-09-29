//
//  XXH32.swift
//  xxHash-Swift
//
//  Created by Daisuke T on 2019/02/12.
//  Copyright © 2019 xxHash-Swift. All rights reserved.
//

import Foundation

/// XXH32 class
public typealias xxHash32 = XXH32
public class XXH32 {
    
    // MARK: - Enum, Const
    static let prime1: UInt32 = 2654435761	// 0b10011110001101110111100110110001
    static let prime2: UInt32 = 2246822519	// 0b10000101111010111100101001110111
    static let prime3: UInt32 = 3266489917	// 0b11000010101100101010111000111101
    static let prime4: UInt32 =  668265263	// 0b00100111110101001110101100101111
    static let prime5: UInt32 =  374761393	// 0b00010110010101100110011110110001
    
    
    
    // MARK: - Property
    private let endian = xxHash.Common.endian()
    private var state = xxHash.Common.State<UInt32>()
    
    /// A seed for generate digest. Default is 0.
    public var seed: UInt32 {
        didSet {
            reset()
        }
    }
    
    
    
    // MARK: - Life cycle
    
    /// Creates a new instance with the seed.
    ///
    /// - Parameter seed: A seed for generate digest. Default is 0.
    public init(_ seed: UInt32 = 0) {
        self.seed = seed
        reset()
    }
    
}



// MARK: - Utility
extension XXH32 {
    
    static private func round(_ seed: UInt32, input: UInt32) -> UInt32 {
        var seed2 = seed
        seed2 &+= input &* prime2
        seed2 = xxHash.Common.rotl(seed2, r: 13)
        seed2 &*= prime1
        
        return seed2
    }
    
    static private func avalanche(_ h: UInt32) -> UInt32 {
        var h2 = h
        h2 ^= h2 >> 15
        h2 &*= prime2
        h2 ^= h2 >> 13
        h2 &*= prime3
        h2 ^= h2 >> 16
        
        return h2
    }
    
}



// MARK: - Finalize
extension XXH32 {
    
    static private func finalize(_ h: UInt32, array: [UInt8], len: Int, endian: xxHash.Common.Endian) -> UInt32 {
        var index = 0
        var h2 = h
        
        func process1() {
            h2 &+= UInt32(array[index]) &* prime5
            index += 1
            h2 = xxHash.Common.rotl(h2, r: 11) &* prime1
        }
        
        func process4() {
            h2 &+= xxHash.Common.UInt8ArrayToUInt(array, index: index, endian: endian) &* prime3
            index += 4
            h2 = xxHash.Common.rotl(h2, r: 17) &* prime4
        }
        
        
        switch len & 15 {
        case 12:
            process4()
            fallthrough
            
        case 8:
            process4()
            fallthrough
            
        case 4:
            process4()
            return avalanche(h2)
            
            
        case 13:
            process4()
            fallthrough
            
        case 9:
            process4()
            fallthrough
            
        case 5:
            process4()
            process1()
            return avalanche(h2)
            
            
        case 14:
            process4()
            fallthrough
            
        case 10:
            process4()
            fallthrough
            
        case 6:
            process4()
            process1()
            process1()
            return avalanche(h2)
            
            
        case 15:
            process4()
            fallthrough
            
        case 11:
            process4()
            fallthrough
            
        case 7:
            process4()
            fallthrough
            
        case 3:
            process1()
            fallthrough
            
        case 2:
            process1()
            fallthrough
            
        case 1:
            process1()
            fallthrough
            
        case 0:
            return avalanche(h2)
            
        default:
            break
        }
        
        return h2	// reaching this point is deemed impossible
    }
    
}



// MARK: - Digest(One-shot)
extension XXH32 {
    
    static private func digest(_ array: [UInt8], seed: UInt32, endian: xxHash.Common.Endian) -> UInt32 {
        let len = array.count
        var h: UInt32
        var index = 0
        
        if len >= 16 {
            let limit = len - 15
            var v1: UInt32 = seed &+ prime1 &+ prime2
            var v2: UInt32 = seed &+ prime2
            var v3: UInt32 = seed + 0
            var v4: UInt32 = seed &- prime1
            
            repeat {
                
                v1 = round(v1, input: xxHash.Common.UInt8ArrayToUInt(array, index: index))
                index += 4
                
                v2 = round(v2, input: xxHash.Common.UInt8ArrayToUInt(array, index: index))
                index += 4
                
                v3 = round(v3, input: xxHash.Common.UInt8ArrayToUInt(array, index: index))
                index += 4
                
                v4 = round(v4, input: xxHash.Common.UInt8ArrayToUInt(array, index: index))
                index += 4
                
            } while(index < limit)
            
            h = xxHash.Common.rotl(v1, r: 1)  &+
                xxHash.Common.rotl(v2, r: 7)  &+
                xxHash.Common.rotl(v3, r: 12) &+
                xxHash.Common.rotl(v4, r: 18)
        } else {
            h = seed &+ prime5
        }
        
        h &+= UInt32(len)
        
        let array2 = Array(array[index...])
        h = finalize(h, array: array2, len: len & 15, endian: endian)
        
        return h
    }
    
    
    /// Generate digest(One-shot)
    ///
    /// - Parameters:
    ///   - array: A source data for hash.
    ///   - seed: A seed for generate digest. Default is 0.
    /// - Returns: A generated digest.
    static public func digest(_ array: [UInt8], seed: UInt32 = 0) -> UInt32 {
        return digest(array, seed: seed, endian: xxHash.Common.endian())
    }
    
    /// Overload func for "digest(_ array: [UInt8], seed: UInt32 = 0)".
    static public func digest(_ string: String, seed: UInt32 = 0) -> UInt32 {
        return digest(Array(string.utf8), seed: seed, endian: xxHash.Common.endian())
    }
    
    /// Overload func for "digest(_ array: [UInt8], seed: UInt32 = 0)".
    static public func digest(_ data: Data, seed: UInt32 = 0) -> UInt32 {
        return digest([UInt8](data), seed: seed, endian: xxHash.Common.endian())
    }
    
    
    /// Generate digest's hex string(One-shot)
    ///
    /// - Parameters:
    ///   - array: A source data for hash.
    ///   - seed: A seed for generate digest. Default is 0.
    /// - Returns: A generated digest's hex string.
    static public func digestHex(_ array: [UInt8], seed: UInt32 = 0) -> String {
        let h = digest(array, seed: seed)
        return xxHash.Common.UInt32ToHex(h)
    }
    
    /// Overload func for "digestHex(_ array: [UInt8], seed: UInt32 = 0)".
    static public func digestHex(_ string: String, seed: UInt32 = 0) -> String {
        let h = digest(string, seed: seed)
        return xxHash.Common.UInt32ToHex(h)
    }
    
    /// Overload func for "digestHex(_ array: [UInt8], seed: UInt32 = 0)".
    static public func digestHex(_ data: Data, seed: UInt32 = 0) -> String {
        let h = digest(data, seed: seed)
        return xxHash.Common.UInt32ToHex(h)
    }
}



// MARK: - Digest(Streaming)
extension XXH32 {
    
    /// Reset current streaming state to initial.
    public func reset() {
        state = xxHash.Common.State()
        
        state.v1 = seed &+ XXH32.prime1 &+ XXH32.prime2
        state.v2 = seed &+ XXH32.prime2
        state.v3 = seed + 0
        state.v4 = seed &- XXH32.prime1
    }
    
    
    /// Update streaming state.
    ///
    /// - Parameter array: A source data for hash.
    public func update(_ array: [UInt8]) {
        let len = array.count
        var index = 0
        
        state.totalLen += UInt32(len)
        state.largeLen = (len >= 16) || (state.totalLen >= 16)
        
        if state.memSize + len < 16 {
            
            // fill in tmp buffer
            state.mem.replaceSubrange(state.memSize..<state.memSize + len, with: array)
            state.memSize += len
            
            return
        }
        
        
        if state.memSize > 0 {
            // some data left from previous update
            state.mem.replaceSubrange(state.memSize..<state.memSize + (16 - state.memSize),
                                      with: array)
            
            state.v1 = XXH32.round(state.v1, input: xxHash.Common.UInt8ArrayToUInt(state.mem, index: 0, endian: endian))
            state.v2 = XXH32.round(state.v2, input: xxHash.Common.UInt8ArrayToUInt(state.mem, index: 4, endian: endian))
            state.v3 = XXH32.round(state.v3, input: xxHash.Common.UInt8ArrayToUInt(state.mem, index: 8, endian: endian))
            state.v4 = XXH32.round(state.v4, input: xxHash.Common.UInt8ArrayToUInt(state.mem, index: 12, endian: endian))
            
            index += 16 - state.memSize
            state.memSize = 0
        }
        
        if index <= len - 16 {
            
            let limit = len - 16
            
            repeat {
                
                state.v1 = XXH32.round(state.v1, input: xxHash.Common.UInt8ArrayToUInt(array, index: index, endian: endian))
                index += 4
                
                state.v2 = XXH32.round(state.v2, input: xxHash.Common.UInt8ArrayToUInt(array, index: index, endian: endian))
                index += 4
                
                state.v3 = XXH32.round(state.v3, input: xxHash.Common.UInt8ArrayToUInt(array, index: index, endian: endian))
                index += 4
                
                state.v4 = XXH32.round(state.v4, input: xxHash.Common.UInt8ArrayToUInt(array, index: index, endian: endian))
                index += 4
                
            } while (index <= limit)
            
        }
        
        
        if index < len {
            state.mem.replaceSubrange(0..<len - index,
                                      with: array[index..<index + (len - index)])
            
            state.memSize = len - index
        }
        
    }
    
    /// Overload func for "update(_ array: [UInt8])".
    public func update(_ string: String) {
        return update(Array(string.utf8))
    }
    
    /// Overload func for "update(_ array: [UInt8])".
    public func update(_ data: Data) {
        return update([UInt8](data))
    }
    
    
    /// Generate digest(Streaming)
    ///
    /// - Returns: A generated digest from current streaming state.
    public func digest() -> UInt32 {
        var h: UInt32
        
        if state.largeLen {
            h = xxHash.Common.rotl(state.v1, r: 1)  &+
                xxHash.Common.rotl(state.v2, r: 7)  &+
                xxHash.Common.rotl(state.v3, r: 12) &+
                xxHash.Common.rotl(state.v4, r: 18)
            
        } else {
            h = state.v3 /* == seed */ &+ XXH32.prime5
        }
        
        h &+= state.totalLen
        
        h = XXH32.finalize(h, array: state.mem, len: state.memSize, endian: endian)
        
        return h
    }
    
    
    /// Generate digest's hex string(Streaming)
    ///
    /// - Returns: A generated digest's hex string from current streaming state.
    public func digestHex() -> String {
        let h = digest()
        return xxHash.Common.UInt32ToHex(h)
    }
    
}



// MARK: - Canonical
extension XXH32 {
    
    static private func canonicalFromHash(_ hash: UInt32, endian: xxHash.Common.Endian) -> [UInt8] {
        var hash2 = hash
        if endian == xxHash.Common.Endian.little {
            hash2 = xxHash.Common.swap(hash2)
        }
        
        return xxHash.Common.UIntToUInt8Array(hash2, endian: endian)
    }
    
    /// Get canonical from hash value.
    ///
    /// - Parameter hash: A target hash value.
    /// - Returns: An array of canonical.
    static public func canonicalFromHash(_ hash: UInt32) -> [UInt8] {
        return canonicalFromHash(hash, endian: xxHash.Common.endian())
    }
    
    
    static private func hashFromCanonical(_ canonical: [UInt8], endian: xxHash.Common.Endian) -> UInt32 {
        var hash: UInt32 = xxHash.Common.UInt8ArrayToUInt(canonical, index: 0, endian: endian)
        if endian == xxHash.Common.Endian.little {
            hash = xxHash.Common.swap(hash)
        }
        
        return hash
    }
    
    /// Get hash value from canonical.
    ///
    /// - Parameter canonical: A target canonical.
    /// - Returns: A hash value.
    static public func hashFromCanonical(_ canonical: [UInt8]) -> UInt32 {
        return hashFromCanonical(canonical, endian: xxHash.Common.endian())
    }
    
}
