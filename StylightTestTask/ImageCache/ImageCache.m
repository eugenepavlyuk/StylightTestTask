//
//  ImageCache.m
//  StylightTestTask
//
//  Created by Eugene Pavluk on 12/8/13.
//  Copyright (c) 2013 Eugene Pavlyuk. All rights reserved.
//

#import "ImageCache.h"

NSString *const FICDPhotoImage32BitBGRFormatName = @"FICDPhotoImage32BitBGRFormatName";
NSString *const FICDPhotoImageFormatFamily = @"FICDPhotoImageFormatFamily";

@implementation ImageCache

- (void)setupFormats
{
    FICImageFormat *photoPreviewImageFormat = [[FICImageFormat alloc] init];
    photoPreviewImageFormat.name = FICDPhotoImage32BitBGRFormatName;
    photoPreviewImageFormat.family = FICDPhotoImageFormatFamily;
    photoPreviewImageFormat.style = FICImageFormatStyle32BitBGR;
    photoPreviewImageFormat.imageSize = CGSizeMake(64, 64);
    photoPreviewImageFormat.maximumCount = 250;
    photoPreviewImageFormat.devices = FICImageFormatDevicePhone | FICImageFormatDevicePad;
    
    NSArray *imageFormats = @[photoPreviewImageFormat];
    
    self.formats = imageFormats;
    self.delegate = self;
}

#pragma mark - FICImageCacheDelegate

- (void)imageCache:(FICImageCache *)imageCache wantsSourceImageForEntity:(id<FICEntity>)entity withFormatName:(NSString *)formatName completionBlock:(FICImageRequestCompletionBlock)completionBlock {

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:[entity sourceImageURLWithFormatName:formatName]];
        UIImage *sourceImage = [UIImage imageWithData:data];
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(sourceImage);
        });
    });
}

@end
