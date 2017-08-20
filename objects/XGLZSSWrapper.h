//
//  XGLZSSWrapper.h
//  XG Tool
//
//  Created by The Steez on 02/06/2015.
//  Copyright (c) 2015 Ovation International. All rights reserved.
//

#import <Foundation/Foundation.h>

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

@interface XGLZSSWrapper : NSObject

@property (nonatomic) int outLength;

- (UInt8 *)compressFile: (UInt8[])bytes ofSize:(int) size;

- (UInt8 *)decompressFile: (UInt8[])bytes ofSize:(int) inSize decompressedSize: (int) outSize;

@end

























