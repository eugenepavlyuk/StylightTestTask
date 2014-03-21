//
//  Page.h
//  StylightTestTask
//
//  Created by Eugene Pavluk on 3/21/14.
//  Copyright (c) 2014 Eugene Pavlyuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class RKObjectMapping;

@interface Page : NSManagedObject

@property (nonatomic, retain) NSNumber * pageId;
@property (nonatomic, retain) NSDate * lastUpdated;
@property (nonatomic, retain) NSOrderedSet *items;

+ (NSArray*)findAllSortedById;
+ (Page*)page;
- (Page*)nextPage;

- (BOOL)isOlderThan15Minutes;

+ (RKObjectMapping*)mapping;

@end
