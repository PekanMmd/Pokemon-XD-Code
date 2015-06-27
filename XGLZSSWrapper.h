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

// by Luigi Auriemma
// partially derived from the original code of Okumura


int EI = 12;    /* typically 10..13 */
int EJ = 4;     /* typically 4..5 */
int P  = 2;     /* If match length <= P then output one character */


int unlzss(unsigned char *src, int srclen, unsigned char *dst, int dstlen) {
	
	int N;
	int F;
	int rless = P;  // in some rare implementations it could be 0
	int init_chr = 0x0;
	
	static int slide_winsz = 0;
	static unsigned char *slide_win = NULL;
	unsigned char *dststart = dst;
	unsigned char *srcend = src + srclen;
	unsigned char *dstend = dst + dstlen;
	int  i, j, k, r, c;
	unsigned flags;
	
	N = 1 << EI;
	F = 1 << EJ;
	
	if(N > slide_winsz) {
		slide_win   = realloc(slide_win, N);
		if(!slide_win) return(-1);
		slide_winsz = N;
	}
	memset(slide_win, init_chr, N);
	
	dst = dststart;
	srcend = src + srclen;
	r = (N - F) - rless;
	N--;
	F--;
	
	for(flags = 0;; flags >>= 1) {
		if(!(flags & 0x100)) {
			if(src >= srcend) break;
			flags = *src++;
			flags |= 0xff00;
		}
		if(flags & 1) {
			if(src >= srcend) break;
			c = *src++;
			if(dst >= dstend) goto quit; //return(-1); better?
			*dst++ = c;
			slide_win[r] = c;
			r = (r + 1) & N;
		} else {
			if(src >= srcend) break;
			i = *src++;
			if(src >= srcend) break;
			j = *src++;
			i |= ((j >> EJ) << 8);
			j  = (j & F) + P;
			for(k = 0; k <= j; k++) {
				c = slide_win[(i + k) & N];
				if(dst >= dstend) goto quit; //return(-1); better?
				*dst++ = c;
				slide_win[r] = c;
				r = (r + 1) & N;
			}
		}
	}
quit:
	return(dst - dststart);
}



@interface XGLZSSWrapper : NSObject

@property (nonatomic) int outLength;

- (UInt8 *)compressFile: (UInt8[])bytes ofSize:(size_t) size;

@end

























