//
//  Product.h
//  StylightTestTask
//
//  Created by Eugene Pavluk on 3/21/14.
//  Copyright (c) 2014 Eugene Pavlyuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class RKObjectMapping;
@class PhotoPreview;

@interface Product : NSManagedObject

@property (nonatomic, retain) NSNumber * productId;
@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSOrderedSet * images;

@property (nonatomic, retain) PhotoPreview *photoPreview;

+ (RKObjectMapping*)mapping;

- (PhotoPreview*)preview;

@end
