//
//  XXH3-Bit128.swift
//  xxHash-Swift
//
//  Created by Daisuke T on 2019/05/06.
//  Copyright © 2019 xxHash-Swift. All rights reserved.
//

import Foundation

extension XXH3 {
    
    /// XXH3 128bit class
    final class Bit128 {
    }
    
}


// MARK: - Utility
extension XXH3.Bit128 {
    
    static private func len1To3(_ array: [UInt8], keySet: [UInt32], seed: UInt64) -> [UInt64] {
        let c1 = UInt32(array[0])
        let c2 = UInt32(array[array.count >> 1])
        let c3 = UInt32(array[array.count - 1])
        let l1 = UInt32(c1 &+ (c2 << 8))
        let l2 = UInt32(UInt32(array.count) &+ (c3 << 2))
        let ll11 = XXH3.Common.mult32To64(l1 &+ UInt32(seed) &+ keySet[0],
                                          y: l2 &+ keySet[1])
        let ll12 = XXH3.Common.mult32To64(l1 &+ keySet[2],
                                          y: l2 &- UInt32(seed) &+ keySet[3])
        
        let h128 = [
            XXH3.Common.avalanche(ll11),
            XXH3.Common.avalanche(ll12)
        ]
        
        return h128
    }
    
    static private func len4To8(_ array: [UInt8], keySet: [UInt32], seed: UInt64, endian: xxHash.Common.Endian) -> [UInt64] {
        let l1: UInt32 = xxHash.Common.UInt8ArrayToUInt(array, index: 0, endian: endian) &+ UInt32(seed) &+ keySet[0]
        let l2: UInt32 = xxHash.Common.UInt8ArrayToUInt(array, index: array.count - 4, endian: endian) &+ UInt32(seed >> 32) &+ keySet[1]
        let acc1: UInt64 = UInt64(array.count) &+ UInt64(l1) &+ (UInt64(l2) << 32) &+ XXH3.Common.mult32To64(l1, y: l2)
        let acc2: UInt64 = UInt64(array.count) &* XXH64.prime1 &+ UInt64(l1) &* XXH64.prime2 &+ UInt64(l2) &* XXH64.prime3
        
        let h128 = [
            XXH3.Common.avalanche(acc1),
            XXH3.Common.avalanche(acc2)
        ]
        
        return h128
    }
    
    static private func len9To16(_ array: [UInt8], keySet: [UInt32], seed: UInt64, endian: xxHash.Common.Endian) -> [UInt64] {
        var acc1: UInt64 = XXH64.prime1 &* (UInt64(array.count) &+ seed)
        var acc2: UInt64 = XXH64.prime2 &* (UInt64(array.count) &- seed)
        let ll1: UInt64 = xxHash.Common.UInt8ArrayToUInt(array, index: 0, endian: endian)
        let ll2: UInt64 = xxHash.Common.UInt8ArrayToUInt(array, index: array.count - 8, endian: endian)
        let key = xxHash.Common.UInt32ToUInt64(keySet[0], val2: keySet[1], endian: endian)
        let key2 = xxHash.Common.UInt32ToUInt64(keySet[2], val2: keySet[3], endian: endian)
        let key3 = xxHash.Common.UInt32ToUInt64(keySet[4], val2: keySet[5], endian: endian)
        let key4 = xxHash.Common.UInt32ToUInt64(keySet[6], val2: keySet[7], endian: endian)
        acc1 &+= XXH3.Common.mul128Fold64(ll1: ll1 &+ key, ll2: ll2 &+ key2)
        acc2 &+= XXH3.Common.mul128Fold64(ll1: ll1 &+ key3, ll2: ll2 &+ key4)
        
        let h128 = [
            XXH3.Common.avalanche(acc1),
            XXH3.Common.avalanche(acc2)
        ]
        
        return h128
    }
    
    static private func len0To16(_ array: [UInt8], seed: UInt64, endian: xxHash.Common.Endian) -> [UInt64] {
        if array.count > 8 {
            return len9To16(array, keySet: XXH3.Common.keySet, seed: seed, endian: endian)
        } else if array.count >= 4 {
            return len4To8(array, keySet: XXH3.Common.keySet, seed: seed, endian: endian)
        } else if array.count > 0 {
            return len1To3(array, keySet: XXH3.Common.keySet, seed: seed)
        }
        
        let h128: [UInt64] = [
            seed,
            0 &- seed
        ]
        
        return h128
    }
    
    static private func hashLong(_ array: [UInt8], seed: UInt64, endian: xxHash.Common.Endian) -> [UInt64] {
        var acc: [UInt64] = [
            seed,
            XXH64.prime1,
            XXH64.prime2,
            XXH64.prime3,
            XXH64.prime4,
            XXH64.prime5,
            UInt64(0 &- seed),
            0
        ]
        
        acc = XXH3.Common.hashLong(acc, array: array, endian: endian)
        
        
        // converge into final hash
        let low64: UInt64 = XXH3.Common.mergeAccs(acc,
                                                  keySet: XXH3.Common.keySet,
                                                  keySetIndex: 0,
                                                  start: UInt64(array.count) &* XXH64.prime1,
                                                  endian: endian)
        let high64: UInt64 = XXH3.Common.mergeAccs(acc,
                                                   keySet: XXH3.Common.keySet,
                                                   keySetIndex: 16,
                                                   start: UInt64(array.count + 1) &* XXH64.prime2,
                                                   endian: endian)
        
        let h128 = [low64, high64]
        
        return h128
    }
    
}


extension XXH3.Bit128 {
    
    static func digest(_ array: [UInt8], seed: UInt64, endian: xxHash.Common.Endian) -> [UInt64] {
        if array.count <= 16 {
            return len0To16(array, seed: seed, endian: endian)
        }
        
        var acc: UInt64 = XXH64.prime1 &* (UInt64(array.count) &+ seed)
        var acc2: UInt64 = 0
        
        if array.count > 32 {
            
            if array.count > 64 {
                
                if array.count > 96 {
                    
                    if array.count > 128 {
                        return hashLong(array, seed: seed, endian: endian)
                    }
                    
                    acc &+= XXH3.Common.mix16B(array,
                                               arrayIndex: 48,
                                               keySet: XXH3.Common.keySet,
                                               keySetIndex: 24,
                                               seed: seed,
                                               endian: endian)
                    
                    acc2 &+= XXH3.Common.mix16B(array,
                                                arrayIndex: array.count - 64,
                                                keySet: XXH3.Common.keySet,
                                                keySetIndex: 28,
                                                seed: seed,
                                                endian: endian)
                }
                
                acc &+= XXH3.Common.mix16B(array,
                                           arrayIndex: 32,
                                           keySet: XXH3.Common.keySet,
                                           keySetIndex: 16,
                                           seed: seed,
                                           endian: endian)
                
                acc2 &+= XXH3.Common.mix16B(array,
                                            arrayIndex: array.count - 48,
                                            keySet: XXH3.Common.keySet,
                                            keySetIndex: 20,
                                            seed: seed,
                                            endian: endian)
            }
            
            acc &+= XXH3.Common.mix16B(array,
                                       arrayIndex: 16,
                                       keySet: XXH3.Common.keySet,
                                       keySetIndex: 8,
                                       seed: seed,
                                       endian: endian)
            
            acc2 &+= XXH3.Common.mix16B(array,
                                        arrayIndex: array.count - 32,
                                        keySet: XXH3.Common.keySet,
                                        keySetIndex: 12,
                                        seed: seed,
                                        endian: endian)
        }
        
        acc &+= XXH3.Common.mix16B(array,
                                   arrayIndex: 0,
                                   keySet: XXH3.Common.keySet,
                                   keySetIndex: 0,
                                   seed: seed,
                                   endian: endian)
        
        acc2 &+= XXH3.Common.mix16B(array,
                                    arrayIndex: array.count - 16,
                                    keySet: XXH3.Common.keySet,
                                    keySetIndex: 4,
                                    seed: seed,
                                    endian: endian)
        
        let part1 = acc &+ acc2
        let part2 = (acc &* XXH64.prime3) &+ (acc2 &* XXH64.prime4) &+ (UInt64(UInt64(array.count) &- seed) &* XXH64.prime2)
        
        let h128 = [
            XXH3.Common.avalanche(part1),
            0 &- XXH3.Common.avalanche(part2)
        ]
        
        return h128
    }
    
}
