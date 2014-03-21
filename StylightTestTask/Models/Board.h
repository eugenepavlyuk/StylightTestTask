//
//  Board.h
//  StylightTestTask
//
//  Created by Eugene Pavluk on 3/21/14.
//  Copyright (c) 2014 Eugene Pavlyuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Creator, Item;

@class RKObjectMapping;

@interface Board : NSManagedObject

@property (nonatomic, retain) NSNumber * boardId;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) Creator *creator;
@property (nonatomic, retain) Item *item;

+ (RKObjectMapping*)mapping;

@end
