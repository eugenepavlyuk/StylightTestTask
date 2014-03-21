//
//  PhotoPreview.m
//  StylightTestTask
//
//  Created by Eugene Pavluk on 12/8/13.
//  Copyright (c) 2013 Eugene Pavlyuk. All rights reserved.
//

#import "PhotoPreview.h"
#import "FICUtilities.h"

@interface PhotoPreview ()
{
    NSString *_UUID;
}

@end


@implementation PhotoPreview

@dynamic path;

#pragma mark - FICImageCacheEntity

- (NSString *)UUID
{
    if (_UUID == nil)
    {
        // MD5 hashing is expensive enough that we only want to do it once
        CFUUIDBytes UUIDBytes = FICUUIDBytesFromMD5HashOfString(self.path);
        _UUID = FICStringWithUUIDBytes(UUIDBytes);
    }
    
    return _UUID;
}

- (NSString *)sourceImageUUID {
    return [self UUID];
}

- (NSURL *)sourceImageURLWithFormatName:(NSString *)formatName {
    return [NSURL URLWithString:self.path];
}

- (FICEntityImageDrawingBlock)drawingBlockForImage:(UIImage *)image withFormatName:(NSString *)formatName {
    FICEntityImageDrawingBlock drawingBlock = ^(CGContextRef contextRef, CGSize contextSize) {
        CGRect contextBounds = CGRectZero;
        contextBounds.size = contextSize;
        CGContextClearRect(contextRef, contextBounds);
        UIGraphicsPushContext(contextRef);
        [image drawInRect:contextBounds];
        UIGraphicsPopContext();
    };
    
    return drawingBlock;
}

@end
