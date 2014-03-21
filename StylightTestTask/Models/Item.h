//
//  Item.h
//  StylightTestTask
//
//  Created by Eugene Pavluk on 3/21/14.
//  Copyright (c) 2014 Eugene Pavlyuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class RKObjectMapping;
@class Page;
@class Board;
@class Product;

@interface Item : NSManagedObject

@property (nonatomic, retain) NSDate * datecreated;
@property (nonatomic, retain) NSNumber * itemId;
@property (nonatomic, retain) NSNumber * order;
@property (nonatomic, retain) Page *page;
@property (nonatomic, retain) Board *board;
@property (nonatomic, retain) Product *product;

+ (RKObjectMapping*)mapping;

+ (NSArray*)findAllSortedByOrder;

- (NSString*)anyName;
- (NSString*)anyDescription;

@end

