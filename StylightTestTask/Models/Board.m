//
//  Board.m
//  StylightTestTask
//
//  Created by Eugene Pavluk on 3/21/14.
//  Copyright (c) 2014 Eugene Pavlyuk. All rights reserved.
//

#import "Board.h"
#import "Creator.h"
#import "Item.h"
#import <RestKit/Network.h>
#import <RestKit/CoreData.h>
#import "Constants.h"


static NSString * kBoardIdKey           =   @"boardId";
static NSString * kTitleKey             =   @"title";
static NSString * kCreatorKey           =   @"creator";
static NSString * kItemKey              =   @"item";

@implementation Board

@dynamic boardId;
@dynamic title;
@dynamic creator;
@dynamic item;

+ (RKObjectMapping*)mapping
{
    RKObjectManager *manager = [RKObjectManager sharedManager];
    
    RKEntityMapping *mapping = [RKEntityMapping mappingForEntityForName:NSStringFromClass(self) inManagedObjectStore:manager.managedObjectStore];
    
    NSMutableIndexSet *statusCodes = [[NSMutableIndexSet alloc] init];
    [statusCodes addIndexes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    [mapping addAttributeMappingsFromArray:@[[RKAttributeMapping attributeMappingFromKeyPath:kIdKey toKeyPath:kBoardIdKey],
                                             kTitleKey]];
    
    RKEntityMapping *creatorMapping = (RKEntityMapping*)[Creator mapping];
    
    RKRelationshipMapping *creatorRelationshipMapping = [RKRelationshipMapping relationshipMappingFromKeyPath:kCreatorKey toKeyPath:kCreatorKey withMapping:creatorMapping];
    
    [mapping addPropertyMapping:creatorRelationshipMapping];
    
    mapping.identificationAttributes = @[kBoardIdKey];
    
    return mapping;
}

@end
