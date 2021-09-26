//
//  XXH3-Common.swift
//  xxHash-Swift
//
//  Created by Daisuke T on 2019/05/05.
//  Copyright © 2019 xxHash-Swift. All rights reserved.
//

import Foundation

extension XXH3 {
    
    /// XXH3 Common class
    final class Common {
    }
    
}


extension XXH3.Common {
    
    // MARK: - Enum, Const
    static let keySetDefaultSize = 48 // minimum 32
    
    // swiftlint:disable comma
    static let keySet: [UInt32] = [
        0xb8fe6c39, 0x23a44bbe, 0x7c01812c, 0xf721ad1c,
        0xded46de9, 0x839097db, 0x7240a4a4, 0xb7b3671f,
        0xcb79e64e, 0xccc0e578, 0x825ad07d, 0xccff7221,
        0xb8084674, 0xf743248e, 0xe03590e6, 0x813a264c,
        0x3c2852bb, 0x91c300cb, 0x88d0658b, 0x1b532ea3,
        0x71644897, 0xa20df94e, 0x3819ef46, 0xa9deacd8,
        0xa8fa763f, 0xe39c343f, 0xf9dcbbc7, 0xc70b4f1d,
        0x8a51e04b, 0xcdb45931, 0xc89f7ec9, 0xd9787364,
        
        0xeac5ac83, 0x34d3ebc3, 0xc581a0ff, 0xfa1363eb,
        0x170ddd51, 0xb7f0da49, 0xd3165526, 0x29d4689e,
        0x2b16be58, 0x7d47a1fc, 0x8ff8b8d1, 0x7ad031ce,
        0x45cb3a8f, 0x95160428, 0xafd7fbca ,0xbb4b407e,
    ]
    // swiftlint:enable comma
    
    private static let stripeLen = 64
    private static let stripeElts = stripeLen / MemoryLayout<UInt32>.size
    private static let accNB = stripeLen / MemoryLayout<UInt64>.size
    
}


// MARK: - Utility
extension XXH3.Common {
    
    static func avalanche(_ h: UInt64) -> UInt64 {
        var h2 = h
        h2 ^= h2 >> 37
        h2 &*= XXH64.prime3
        h2 ^= h2 >> 32
        
        return h2
    }
    
    static func mult32To64(_ x: UInt32, y: UInt32) -> UInt64 {
        return UInt64(x) * UInt64(y)
    }
    
    static func mul128Fold64(ll1: UInt64, ll2: UInt64) -> UInt64 {
        let h1 = UInt32(ll1 >> 32)
        let h2 = UInt32(ll2 >> 32)
        let l1 = UInt32(ll1 & 0x00000000FFFFFFFF)
        let l2 = UInt32(ll2 & 0x00000000FFFFFFFF)
        
        let llh: UInt64 = mult32To64(h1, y: h2)
        let llm1: UInt64 = mult32To64(l1, y: h2)
        let llm2: UInt64 = mult32To64(h1, y: l2)
        let lll: UInt64 = mult32To64(l1, y: l2)
        
        let t = UInt64(lll &+ (llm1 << 32))
        let carry1 = UInt64((t < lll) ? 1 : 0)
        
        let lllow = UInt64(t &+ (llm2 << 32))
        let carry2 = UInt64((lllow < t) ? 1 : 0)
        
        let llm1l = UInt64(llm1 >> 32)
        let llm2l = UInt64(llm2 >> 32)
        
        let llhigh = UInt64(llh &+ (llm1l + llm2l + carry1 + carry2))
        
        return llhigh ^ lllow
    }
    
    // swiftlint:disable function_parameter_count
    static private func accumulate512(_ acc: inout [UInt64],
                                      array: [UInt8],
                                      arrayIndex: Int,
                                      keySet: [UInt32],
                                      keySetIndex: Int,
                                      endian: xxHash.Common.Endian) {
        // swiftlint:enable function_parameter_count
        for i in 0..<accNB {
            let dataVal: UInt64 = xxHash.Common.UInt8ArrayToUInt(array,
                                                                 index: arrayIndex + (i * 8),
                                                                 endian: endian)
            let keyVal = xxHash.Common.UInt32ToUInt64(keySet[keySetIndex + (i * 2)],
                                                      val2: keySet[keySetIndex + (i * 2) + 1],
                                                      endian: endian)
            let dataKey = UInt64(keyVal ^ dataVal)
            let mul = mult32To64(UInt32(dataKey & 0x00000000FFFFFFFF),
                                 y: UInt32(dataKey >> 32))
            acc[i] &+= mul
            acc[i] &+= dataVal
        }
    }
    
    // swiftlint:disable function_parameter_count
    static private func accumulate(_ acc: inout [UInt64],
                                   array: [UInt8],
                                   arrayIndex: Int,
                                   keySet: [UInt32],
                                   keySetIndex: Int,
                                   nbStripes: Int,
                                   endian: xxHash.Common.Endian) {
        // swiftlint:enable function_parameter_count
        for i in 0..<nbStripes {
            accumulate512(&acc,
                          array: array,
                          arrayIndex: arrayIndex + (i * stripeLen),
                          keySet: keySet,
                          keySetIndex: keySetIndex + (i * 2),
                          endian: endian)
        }
    }
    
    static private func scrambleAcc(_ acc: inout [UInt64],
                                    keySet: [UInt32],
                                    keySetIndex: Int,
                                    endian: xxHash.Common.Endian) {
        for i in 0..<accNB {
            let key64 = xxHash.Common.UInt32ToUInt64(keySet[keySetIndex + (i * 2)],
                                                     val2: keySet[keySetIndex + (i * 2) + 1],
                                                     endian: endian)
            var acc64 = acc[i]
            acc64 ^= acc64 >> 47
            acc64 ^= key64
            acc64 &*= UInt64(XXH32.prime1)
            acc[i] = acc64
        }
    }
    
    static func hashLong(_ acc: [UInt64], array: [UInt8], endian: xxHash.Common.Endian) -> [UInt64] {
        let nbKeys = (keySetDefaultSize - stripeElts) / 2
        let blockLen = stripeLen * nbKeys
        let nbBlocks = array.count / blockLen
        var acc = acc
        
        for i in 0..<nbBlocks {
            accumulate(&acc,
                       array: array,
                       arrayIndex: i * blockLen,
                       keySet: keySet,
                       keySetIndex: 0,
                       nbStripes: nbKeys,
                       endian: endian)
            
            scrambleAcc(&acc,
                        keySet: keySet,
                        keySetIndex: keySetDefaultSize - stripeElts,
                        endian: endian)
        }
        
        
        // last partial block
        let nbStripes = (array.count % blockLen) / stripeLen
        accumulate(&acc,
                   array: array,
                   arrayIndex: nbBlocks * blockLen,
                   keySet: keySet,
                   keySetIndex: 0,
                   nbStripes: nbStripes,
                   endian: endian)
        
        // last stripe
        if (array.count & (stripeLen - 1)) > 0 {
            accumulate512(&acc,
                          array: array,
                          arrayIndex: array.count - stripeLen,
                          keySet: keySet,
                          keySetIndex: nbStripes * 2,
                          endian: endian)
        }
        
        return acc
    }
    
    static private func mix2Accs(_ acc: [UInt64],
                                 accIndex: Int,
                                 keySet: [UInt32],
                                 keySetIndex: Int,
                                 endian: xxHash.Common.Endian) -> UInt64 {
        let key = xxHash.Common.UInt32ToUInt64(keySet[keySetIndex + 0],
                                               val2: keySet[keySetIndex + 1],
                                               endian: endian)
        let key2 = xxHash.Common.UInt32ToUInt64(keySet[keySetIndex + 2],
                                                val2: keySet[keySetIndex + 3],
                                                endian: endian)
        
        return mul128Fold64(ll1: acc[accIndex + 0] ^ key, ll2: acc[accIndex + 1] ^ key2)
    }
    
    static func mergeAccs(_ acc: [UInt64],
                          keySet: [UInt32],
                          keySetIndex: Int,
                          start: UInt64,
                          endian: xxHash.Common.Endian) -> UInt64 {
        var result: UInt64 = start
        
        result &+= mix2Accs(acc,
                            accIndex: 0,
                            keySet: keySet,
                            keySetIndex: keySetIndex,
                            endian: endian)
        result &+= mix2Accs(acc,
                            accIndex: 2,
                            keySet: keySet,
                            keySetIndex: keySetIndex + 4,
                            endian: endian)
        result &+= mix2Accs(acc,
                            accIndex: 4,
                            keySet: keySet,
                            keySetIndex: keySetIndex + 8,
                            endian: endian)
        result &+= mix2Accs(acc,
                            accIndex: 6,
                            keySet: keySet,
                            keySetIndex: keySetIndex + 12,
                            endian: endian)
        
        return avalanche(result)
    }
    
    // swiftlint:disable function_parameter_count
    static func mix16B(_ array: [UInt8],
                       arrayIndex: Int,
                       keySet: [UInt32],
                       keySetIndex: Int,
                       seed: UInt64,
                       endian: xxHash.Common.Endian) -> UInt64 {
        // swiftlint:enable function_parameter_count
        let ll1: UInt64 = xxHash.Common.UInt8ArrayToUInt(array,
                                                         index: arrayIndex + 0,
                                                         endian: endian)
        let ll2: UInt64 = xxHash.Common.UInt8ArrayToUInt(array,
                                                         index: arrayIndex + 8,
                                                         endian: endian)
        let key = xxHash.Common.UInt32ToUInt64(keySet[keySetIndex + 0],
                                               val2: keySet[keySetIndex + 1],
                                               endian: endian)
        let key2 = xxHash.Common.UInt32ToUInt64(keySet[keySetIndex + 2],
                                                val2: keySet[keySetIndex + 3],
                                                endian: endian)
        
        return mul128Fold64(ll1: ll1 ^ (key &+ seed), ll2: ll2 ^ (key2 &- seed))
    }
    
}
