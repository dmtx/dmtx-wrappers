/*
Cocoa wrapper for libdmtx

Copyright (C) 2008 CocoaHeads Aachen. All rights reserved.
Copyright (C) 2009 Romain Goyet

Created by Stefan Hafeneger on 28.05.08.

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License, or (at your option) any later version.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
*/

/* $Id$ */

#import "SHDataMatrixReader.h"

#import "dmtx.h"

@interface SHDataMatrixReader ()
#if TARGET_OS_IPHONE
- (NSData *)_ARGB8DataForImage:(UIImage *)image;
#else
- (NSData *)_ARGB8DataForImage:(NSImage *)image;
#endif
@end

@implementation SHDataMatrixReader

#pragma mark Allocation

+ (id)sharedDataMatrixReader {
	static SHDataMatrixReader *dataMatrixReader = nil;
	if(dataMatrixReader == nil)
		dataMatrixReader = [[self alloc] init];
	return dataMatrixReader;
}

- (id)init {
	self = [super init];
	if(self != nil) {

	}
	return self;
}

#pragma mark Instance
#if TARGET_OS_IPHONE
- (NSString *)decodeBarcodeFromImage:(UIImage *)image {
#else
- (NSString *)decodeBarcodeFromImage:(NSImage *)image {
#endif

	NSMutableArray *messages = [NSMutableArray array];

    NSData * imageData = [self _ARGB8DataForImage:image];
	// Create dmtx image.
	DmtxImage *dmtxImage = dmtxImageCreate((unsigned char*)[imageData bytes], 500, 500, DmtxPack32bppXRGB);
	if(dmtxImage == NULL)
    {
#if ! __has_feature(objc_arc)
        [imageData release];
#endif
		return nil;
    }

	// Initialize dmtx decode struct for image.
	DmtxDecode *dmtxDecode = dmtxDecodeCreate(dmtxImage, 1);

	DmtxRegion *dmtxRegion;
	DmtxMessage *dmtxMessage;

	// Loop once for each detected barcode region.
	NSUInteger count;
	for(count = 0; count < 1; count++) {

		// Find next barcode region within image.
		dmtxRegion = dmtxRegionFindNext(dmtxDecode, NULL);
		if(dmtxRegion == NULL)
			break;

		// Decode region based on requested scan mode.
		dmtxMessage = dmtxDecodeMatrixRegion(dmtxDecode, dmtxRegion, DmtxUndefined);

		if(dmtxMessage != NULL) {
			// Convert C string to NSString.
            NSString *message = [[NSString alloc] initWithBytes:dmtxMessage->output length:(NSUInteger)dmtxMessage->outputIdx encoding:NSASCIIStringEncoding];
			[messages addObject:message];

			// Free dmtx message memory.
			dmtxMessageDestroy(&dmtxMessage);
		}

		dmtxRegionDestroy(&dmtxRegion);

		break;
	}

	// Free dmtx decode memory.
	dmtxDecodeDestroy(&dmtxDecode);

	// Free dmtx image memory.
	dmtxImageDestroy(&dmtxImage);

	if([messages count] > 0)
		return [messages objectAtIndex:0];
	else
		return nil;
}

#if TARGET_OS_IPHONE
- (NSData *)_ARGB8DataForImage:(UIImage *)image {
#else
- (NSData *)_ARGB8DataForImage:(NSImage *)image {
#endif

#if TARGET_OS_IPHONE
	// We have to deal with a CGImage.
	CGImageRef imageRef = image.CGImage;
#else
	CGImageRef imageRef = [[[NSBitmapImageRep alloc] initWithData:[image TIFFRepresentation]] CGImage];
#endif

	// Calculate image dimensions (500 pixel should be enough for decoding).
	NSUInteger aspectRatio = CGImageGetWidth(imageRef) / CGImageGetHeight(imageRef);
	NSUInteger width = 500;
	NSUInteger height = 500 / aspectRatio;
	NSUInteger bytesPerRow = width * 4;

	// Create color space object.
	CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
	if(colorSpaceRef == NULL)
		return NULL;

	// Create context memory.
	void *memory = malloc(bytesPerRow * height);
	if(memory == NULL) {
		CGColorSpaceRelease(colorSpaceRef);
		return NULL;
	}

	// Create bitmap context.
	CGContextRef contextRef = CGBitmapContextCreate(memory, width, height, 8,
			bytesPerRow, colorSpaceRef, kCGImageAlphaPremultipliedFirst);
	if(contextRef == NULL) {
		CGColorSpaceRelease(colorSpaceRef);
		free(memory);
		return NULL;
	}

	// Release color space object.
	CGColorSpaceRelease(colorSpaceRef);

	// Scale image to desired size.
	CGContextDrawImage(contextRef, CGRectMake(0.0f, 0.0f, (CGFloat)width,
			(CGFloat)height), imageRef);

	// Get context data.
	unsigned char *data = (unsigned char *)CGBitmapContextGetData(contextRef);
	if(data == NULL) {
		CGContextRelease(contextRef);
		free(memory);
		return NULL;
	}

    NSData * imageData = [NSData dataWithBytes:data length:width*height*4];

	// Release bitmap context.
	CGContextRelease(contextRef);

	// Free context memory.
	free(memory);

	return imageData;
}

#if ! __has_feature(objc_arc)
- (void)dealloc {
    [super dealloc];
}
#endif

@end
