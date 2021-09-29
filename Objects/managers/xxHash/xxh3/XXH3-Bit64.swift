//
//  XXH3-Bit64.swift
//  xxHash-Swift
//
//  Created by Daisuke T on 2019/05/06.
//  Copyright © 2019 xxHash-Swift. All rights reserved.
//

import Foundation

extension XXH3 {
    
    /// XXH3 64bit class
    final class Bit64 {
    }
    
}


// MARK: - Utility
extension XXH3.Bit64 {
    
    static private func initKey(seed: UInt64, endian: xxHash.Common.Endian) -> [UInt32] {
        var keySet2 = [UInt32](repeating: 0, count: XXH3.Common.keySet.count)
        let seed1 = UInt32(seed & 0x00000000FFFFFFFF)
        let seed2 = UInt32(seed >> 32)
        
        for i in stride(from: 0, to: XXH3.Common.keySetDefaultSize, by: 4) {
            keySet2[i + 0] = XXH3.Common.keySet[i + 0] &+ seed1
            keySet2[i + 1] = XXH3.Common.keySet[i + 1] &- seed2
            keySet2[i + 2] = XXH3.Common.keySet[i + 2] &+ seed2
            keySet2[i + 3] = XXH3.Common.keySet[i + 3] &- seed1
        }
        
        return keySet2
    }
    
    static private func len1To3(_ array: [UInt8], keySet: [UInt32], seed: UInt64) -> UInt64 {
        let c1 = UInt32(array[0])
        let c2 = UInt32(array[array.count >> 1])
        let c3 = UInt32(array[array.count - 1])
        let l1 = UInt32(c1 &+ (c2 << 8))
        let l2 = UInt32(UInt32(array.count) &+ (c3 << 2))
        let ll11: UInt64 =  XXH3.Common.mult32To64(l1 &+ UInt32(seed) &+ keySet[0],
                                                   y: l2 &+ UInt32(seed >> 32) &+ keySet[1])
        
        return  XXH3.Common.avalanche(ll11)
    }
    
    static private func len4To8(_ array: [UInt8], keySet: [UInt32], seed: UInt64, endian: xxHash.Common.Endian) -> UInt64 {
        let in1: UInt32 = xxHash.Common.UInt8ArrayToUInt(array, index: 0, endian: endian)
        let in2: UInt32 = xxHash.Common.UInt8ArrayToUInt(array, index: array.count - 4, endian: endian)
        let in64: UInt64 = UInt64(UInt64(in1) &+ (UInt64(in2) << 32))
        let key = xxHash.Common.UInt32ToUInt64(keySet[0], val2: keySet[1], endian: endian)
        let keyed: UInt64 = in64 ^ (key &+ seed)
        let mix64: UInt64 = UInt64(array.count) &+ XXH3.Common.mul128Fold64(ll1: keyed, ll2: XXH64.prime1)
        
        return XXH3.Common.avalanche(mix64)
    }
    
    static private func len9To16(_ array: [UInt8], keySet: [UInt32], seed: UInt64, endian: xxHash.Common.Endian) -> UInt64 {
        let key = xxHash.Common.UInt32ToUInt64(keySet[0], val2: keySet[1], endian: endian)
        let key2 = xxHash.Common.UInt32ToUInt64(keySet[2], val2: keySet[3], endian: endian)
        let ll1: UInt64 = xxHash.Common.UInt8ArrayToUInt(array, index: 0, endian: endian) ^ (key &+ seed)
        let ll2: UInt64 = xxHash.Common.UInt8ArrayToUInt(array, index: array.count - 8, endian: endian) ^ (key2 &- seed)
        let acc: UInt64 = UInt64(array.count) &+ (ll1 &+ ll2) &+ XXH3.Common.mul128Fold64(ll1: ll1, ll2: ll2)
        
        return XXH3.Common.avalanche(acc)
    }
    
    static private func len0To16(_ array: [UInt8], seed: UInt64, endian: xxHash.Common.Endian) -> UInt64 {
        if array.count > 8 {
            return len9To16(array, keySet: XXH3.Common.keySet, seed: seed, endian: endian)
        } else if array.count >= 4 {
            return len4To8(array, keySet: XXH3.Common.keySet, seed: seed, endian: endian)
        } else if array.count > 0 {
            return len1To3(array, keySet: XXH3.Common.keySet, seed: seed)
        }
        
        return seed
    }
    
    static private func hashLong(_ array: [UInt8], seed: UInt64, endian: xxHash.Common.Endian) -> UInt64 {
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
        
        let keySet: [UInt32] = initKey(seed: seed, endian: endian)
        acc = XXH3.Common.hashLong(acc, array: array, endian: endian)
        
        // converge into final hash
        return XXH3.Common.mergeAccs(acc,
                                     keySet: keySet,
                                     keySetIndex: 0,
                                     start: UInt64(array.count) &* XXH64.prime1,
                                     endian: endian)
    }
    
}


extension XXH3.Bit64 {
    
    static func digest(_ array: [UInt8], seed: UInt64, endian: xxHash.Common.Endian) -> UInt64 {
        if array.count <= 16 {
            return len0To16(array, seed: seed, endian: endian)
        }
        
        var acc = UInt64(UInt64(array.count) &* XXH64.prime1)
        
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
                    
                    acc &+= XXH3.Common.mix16B(array,
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
                
                acc &+= XXH3.Common.mix16B(array,
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
            
            acc &+= XXH3.Common.mix16B(array,
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
        
        acc &+= XXH3.Common.mix16B(array,
                                   arrayIndex: array.count - 16,
                                   keySet: XXH3.Common.keySet,
                                   keySetIndex: 4,
                                   seed: seed,
                                   endian: endian)
        
        return XXH3.Common.avalanche(acc)
    }
    
}
