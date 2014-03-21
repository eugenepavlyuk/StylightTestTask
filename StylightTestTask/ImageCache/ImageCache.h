//
//  ImageCache.h
//  StylightTestTask
//
//  Created by Eugene Pavluk on 12/8/13.
//  Copyright (c) 2013 Eugene Pavlyuk. All rights reserved.
//

#import "FICImageCache.h"

extern NSString *const FICDPhotoImage32BitBGRFormatName;

@interface ImageCache : FICImageCache <FICImageCacheDelegate>

- (void)setupFormats;

@end
