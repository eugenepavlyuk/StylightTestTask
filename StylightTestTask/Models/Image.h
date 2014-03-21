//
//  Image.h
//  StylightTestTask
//
//  Created by Eugene Pavluk on 3/21/14.
//  Copyright (c) 2014 Eugene Pavlyuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class RKObjectMapping;

@interface Image : NSManagedObject

@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSNumber * primary;

+ (RKObjectMapping*)mapping;

@end
