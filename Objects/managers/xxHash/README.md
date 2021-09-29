<img src="https://raw.githubusercontent.com/daisuke-t-jp/xxHash-Swift/master/images/header.png" width="700"></br>
------
![Platform](https://img.shields.io/badge/Platform-iOS%20%7C%20macOS%20%7C%20tvOS%20%7C%20Linux-blue.svg)
[![Language Swift%205.0](https://img.shields.io/badge/Language-Swift%205.0-orange.svg)](https://developer.apple.com/swift)
[![CocoaPods](https://img.shields.io/cocoapods/v/xxHash-Swift.svg)](https://cocoapods.org/pods/xxHash-Swift)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-green.svg)](https://github.com/Carthage/Carthage)
[![SwiftPM compatible](https://img.shields.io/badge/SwiftPM-compatible-green.svg)](https://github.com/apple/swift-package-manager)
[![Build Status](https://travis-ci.org/daisuke-t-jp/xxHash-Swift.svg?branch=master)](https://travis-ci.org/daisuke-t-jp/xxHash-Swift)


# Introduction

[**xxHash**](https://cyan4973.github.io/xxHash/) framework in Swift.  
A framework includes XXH32/XXH64/XXH3-64/XXH3-128 functions.  
  
Original xxHash algorithm created by [Yann Collet](https://github.com/Cyan4973).


# Requirements
- Platforms
  - iOS 10.0+
  - macOS 10.12+
  - tvOS 12.0+
  - Linux
- Swift 5.0


# Installation
## Carthage
`github "daisuke-t-jp/xxHash-Swift"`

## CocoaPods
```
use_frameworks!

target 'target' do
pod 'xxHash-Swift'
end
```


# Usage
## Import framework

```swift
import xxHash_Swift
```


## XXH32
### Generate digest(One-shot)
```swift
let digest = XXH32.digest("123456789ABCDEF")
// digest -> 0x576e3cf9

// Using seed.
let digest = XXH32.digest("123456789ABCDEF", seed: 0x7fffffff)
// digest -> 0xa7f06f9d
```

### Generate digest(Streaming)
```swift
// Create xxHash instance
let xxh = XXH32() // if using seed, e.g. "XXH32(0x7fffffff)"

// Get data from file
let bundle = Bundle(for: type(of: self))
let path = bundle.path(forResource: "alice29", ofType: "txt")!
let data = NSData(contentsOfFile: path)! as Data

let bufSize = 1024
var index = 0

repeat {
    var lastIndex = index + bufSize
    if lastIndex > data.count {
        lastIndex = index + data.count - index
    }

    let data2 = data[index..<lastIndex]
    xxh.update(data2) // xxHash update

    index += data2.count
    if index >= data.count {
        break
    }
} while(true)

let digest = xxh.digest()
// digest -> 0xafc8e0c2
```


## XXH64
### Generate digest(One-shot)
```swift
let digest = XXH64.digest("123456789ABCDEF")
// digest -> 0xa66df83f00e9202d

// Using seed.
let digest = XXH64.digest("123456789ABCDEF", seed: 0x000000007fffffff)
// digest -> 0xe8d84202a16e482f
```

### Generate digest(Streaming)
```swift
// Create xxHash instance
let xxh = XXH64() // if using seed, e.g. "XXH64(0x000000007fffffff)"

// Get data from file
let bundle = Bundle(for: type(of: self))
let path = bundle.path(forResource: "alice29", ofType: "txt")!
let data = NSData(contentsOfFile: path)! as Data

let bufSize = 1024
var index = 0

repeat {
    var lastIndex = index + bufSize
    if lastIndex > data.count {
        lastIndex = index + data.count - index
    }

    let data2 = data[index..<lastIndex]
    xxh.update(data2) // xxHash update

    index += data2.count
    if index >= data.count {
        break
    }
} while(true)

let digest = xxh.digest()
// digest -> 0x843c2c4ccfbfb749
```


## XXH3-64
### Generate digest(One-shot)
```swift
let digest = XXH3.digest64("123456789ABCDEF")
// digest -> 0xfb28db77f56706e8

// Using seed.
let digest = XXH3.digest64("123456789ABCDEF", seed: 0x000000007fffffff)
// digest -> 0xced1ef1da8aa95ae
```

## XXH3-128
### Generate digest(One-shot)
```swift
let digest = XXH3.digest128("123456789ABCDEF")
// digest[0] -> 0x208cfe2ef00d2aaa
// digest[1] -> 0x9b72015eec4abbf3

// Using seed.
let digest = XXH3.digest128("123456789ABCDEF", seed: 0x000000007fffffff)
// digest[0] -> 0x50554db504518e64
// digest[1] -> 0xc8fb00b18f99658c
```


# Demo

There are demos.

- [iOS](https://github.com/daisuke-t-jp/xxHash-Swift/tree/master/demo/xxHashDemo-iOS) 
- [macOS](https://github.com/daisuke-t-jp/xxHash-Swift/tree/master/demo/xxHashDemo-macOS) 
- [tvOS](https://github.com/daisuke-t-jp/xxHash-Swift/tree/master/demo/xxHashDemo-tvOS) 

