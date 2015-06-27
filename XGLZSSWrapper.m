//
//  XGLZSSWrapper.m
//  XG Tool
//
//  Created by The Steez on 02/06/2015.
//  Copyright (c) 2015 Ovation International. All rights reserved.
//

#import "XGLZSSWrapper.h"

// modified by Luigi Auriemma
/**************************************************************
	LZSS.C -- A Data Compression Program
	(tab = 4 spaces)
 ***************************************************************
	4/6/1989 Haruhiko Okumura
	Use, distribute, and modify this program freely.
	Please send me your improved versions.
 PC-VAN		SCIENCE
 NIFTY-Serve	PAF01022
 CompuServe	74050,1022
 **************************************************************/

int N =		 4096;	/* size of ring buffer */
int F =		   18;	/* upper limit for match_length */
int THRESHOLD =	2;   /* encode string into position and length
					  if match_length is greater than this */
int NIL;//			N;	/* index for root of binary search trees */
int init_chr = 0x0;

unsigned int
textsize = 0,	/* text size counter */
codesize = 0;	/* code size counter */
static unsigned char *text_buf = NULL;	/* ring buffer of size N,
										 with extra F-1 bytes to facilitate string comparison */
int		match_position, match_length;  /* of longest match.  These are
										set by the InsertNode() procedure. */
static int  *lson = NULL,
*rson = NULL,
*dad  = NULL;
/* left & right children &
 parents -- These constitute binary search trees. */

static
unsigned char   *infile   = NULL,
*infilel  = NULL,
*outfile  = NULL,
*outfilel = NULL;

int lzss_xgetc(void *skip) {
	if(infile >= infilel) return(-1);
	return(*infile++);
}
int lzss_xputc(int chr, void *skip) {
//	if(outfile >= outfilel) return(-1);
	*outfile++ = chr;
	return(chr);
}

void InitTree(void)  /* initialize trees */
{
	int  i;
	
	/* For i = 0 to N - 1, rson[i] and lson[i] will be the right and
	 left children of node i.  These nodes need not be initialized.
	 Also, dad[i] is the parent of node i.  These are initialized to
	 NIL (= N), which stands for 'not used.'
	 For i = 0 to 255, rson[N + i + 1] is the root of the tree
	 for strings that begin with character i.  These are initialized
	 to NIL.  Note there are 256 trees. */
	
	for (i = N + 1; i <= N + 256; i++) rson[i] = NIL;
	for (i = 0; i < N; i++) dad[i] = NIL;
}

void InsertNode(int r)
/* Inserts string of length F, text_buf[r..r+F-1], into one of the
 trees (text_buf[r]'th tree) and returns the longest-match position
 and length via the global variables match_position and match_length.
 If match_length = F, then removes the old node in favor of the new
 one, because the old one will be deleted sooner.
 Note r plays double role, as tree node and position in buffer. */
{
	int  i, p, cmp;
	unsigned char  *key;
	
	cmp = 1;  key = &text_buf[r];  p = N + 1 + key[0];
	rson[r] = lson[r] = NIL;  match_length = 0;
	for ( ; ; ) {
		if (cmp >= 0) {
			if (rson[p] != NIL) p = rson[p];
			else {  rson[p] = r;  dad[r] = p;  return;  }
		} else {
			if (lson[p] != NIL) p = lson[p];
			else {  lson[p] = r;  dad[r] = p;  return;  }
		}
		for (i = 1; i < F; i++)
		if ((cmp = key[i] - text_buf[p + i]) != 0)  break;
		if (i > match_length) {
			match_position = p;
			if ((match_length = i) >= F)  break;
		}
	}
	dad[r] = dad[p];  lson[r] = lson[p];  rson[r] = rson[p];
	dad[lson[p]] = r;  dad[rson[p]] = r;
	if (rson[dad[p]] == p) rson[dad[p]] = r;
	else                   lson[dad[p]] = r;
	dad[p] = NIL;  /* remove p */
}

void DeleteNode(int p)  /* deletes node p from tree */
{
	int  q;
	
	if (dad[p] == NIL) return;  /* not in tree */
	if (rson[p] == NIL) q = lson[p];
	else if (lson[p] == NIL) q = rson[p];
	else {
		q = lson[p];
		if (rson[q] != NIL) {
			do {  q = rson[q];  } while (rson[q] != NIL);
			rson[dad[q]] = lson[q];  dad[lson[q]] = dad[q];
			lson[q] = lson[p];  dad[lson[p]] = q;
		}
		rson[q] = rson[p];  dad[rson[p]] = q;
	}
	dad[q] = dad[p];
	if (rson[dad[p]] == p) rson[dad[p]] = q;  else lson[dad[p]] = q;
	dad[p] = NIL;
}

void Encode(void)
{
	int  i, c, len, r, s, last_match_length, code_buf_ptr;
	unsigned char  code_buf[17], mask;
	
	InitTree();  /* initialize trees */
	code_buf[0] = 0;  /* code_buf[1..16] saves eight units of code, and
					   code_buf[0] works as eight flags, "1" representing that the unit
					   is an unencoded letter (1 byte), "0" a position-and-length pair
					   (2 bytes).  Thus, eight units require at most 16 bytes of code. */
	code_buf_ptr = mask = 1;
	s = 0;  r = N - F;
	for (i = s; i < r; i++) text_buf[i] = init_chr;  /* Clear the buffer with
													  any character that will appear often. */
	for (len = 0; len < F && (c = lzss_xgetc(infile)) != EOF; len++)
	text_buf[r + len] = c;  /* Read F bytes into the last F bytes of
							 the buffer */
	if ((textsize = len) == 0) return;  /* text of size zero */
	for (i = 1; i <= F; i++) InsertNode(r - i);  /* Insert the F strings,
												  each of which begins with one or more 'space' characters.  Note
												  the order in which these strings are inserted.  This way,
												  degenerate trees will be less likely to occur. */
	InsertNode(r);  /* Finally, insert the whole string just read.  The
					 global variables match_length and match_position are set. */
	do {
		if (match_length > len) match_length = len;  /* match_length
													  may be spuriously long near the end of text. */
		if (match_length <= THRESHOLD) {
			match_length = 1;  /* Not long enough match.  Send one byte. */
			code_buf[0] |= mask;  /* 'send one byte' flag */
			code_buf[code_buf_ptr++] = text_buf[r];  /* Send uncoded. */
		} else {
			code_buf[code_buf_ptr++] = (unsigned char) match_position;
			code_buf[code_buf_ptr++] = (unsigned char)
			(((match_position >> 4) & 0xf0)
			 | (match_length - (THRESHOLD + 1)));  /* Send position and
													length pair. Note match_length > THRESHOLD. */
		}
		if ((mask <<= 1) == 0) {  /* Shift mask left one bit. */
			for (i = 0; i < code_buf_ptr; i++)  /* Send at most 8 units of */
			lzss_xputc(code_buf[i], outfile);     /* code together */
			codesize += code_buf_ptr;
			code_buf[0] = 0;  code_buf_ptr = mask = 1;
		}
		last_match_length = match_length;
		for (i = 0; i < last_match_length &&
			 (c = lzss_xgetc(infile)) != EOF; i++) {
			DeleteNode(s);		/* Delete old strings and */
			text_buf[s] = c;	/* read new bytes */
			if (s < F - 1) text_buf[s + N] = c;  /* If the position is
												  near the end of buffer, extend the buffer to make
												  string comparison easier. */
			s = (s + 1) & (N - 1);  r = (r + 1) & (N - 1);
			/* Since this is a ring buffer, increment the position
			 modulo N. */
			InsertNode(r);	/* Register the string in text_buf[r..r+F-1] */
		}
		while (i++ < last_match_length) {	/* After the end of text, */
			DeleteNode(s);					/* no need to read, but */
			s = (s + 1) & (N - 1);  r = (r + 1) & (N - 1);
			if (--len) InsertNode(r);		/* buffer may not be empty. */
		}
	} while (len > 0);	/* until length of string to be processed is zero */
	if (code_buf_ptr > 1) {		/* Send remaining code. */
		for (i = 0; i < code_buf_ptr; i++) lzss_xputc(code_buf[i], outfile);
		codesize += code_buf_ptr;
	}
}

int lzss_compress(unsigned char *inf, int insz, unsigned char *outf, int outsz) {
	
	infile   = inf;
	infilel  = inf + insz;
	outfile  = outf;
	outfilel = outf + outsz;
	
	if((EI < 0) || (EI >= 0xffff)) return(-1);
	if((EJ < 0) || (EJ >= 31))     return(-1);
	if((P  < 0) || (P  >= 0xffff)) return(-1);
	
	if(EI >= 16) N = EI;
	else         N = 1 << EI;
	THRESHOLD = P;
	F = (1 << EJ) + THRESHOLD;
	// rless unused
	
	NIL = N;
	text_buf = realloc(text_buf, N + F - 1);
	lson     = realloc(lson, sizeof(int) * (N + 1));
	rson     = realloc(rson, sizeof(int) * (N + 257));
	dad      = realloc(dad,  sizeof(int) * (N + 1));
	
	Encode();
	return(outfile - outf);
	
}


@implementation XGLZSSWrapper

- (UInt8 *)compressFile: (UInt8[])bytes ofSize:(size_t) size {
	
	int count = size;
	
	unsigned char *inFile = (unsigned char *)calloc(count, sizeof(unsigned char));
	
	for (int i = 0; i < count; i++) {
		UInt8 byte = (UInt8)bytes[i];
		inFile[i] = byte;
	}
	
	unsigned char *outFile = (unsigned char *)calloc(count, sizeof(unsigned char));
	
	_outLength = lzss_compress(inFile, count, outFile, count);
	
//	NSMutableArray *compressedFile = [[NSMutableArray alloc] init];
//	
//	int outSize = sizeof(outFile)/sizeof(unsigned char);
//	for (int i = 0; i < outSize ; i++) {
//		[compressedFile setObject: @(outFile[i]) atIndexedSubscript:i];
//	}
	
	
	free(inFile);
	return outFile;
	
}

@end































