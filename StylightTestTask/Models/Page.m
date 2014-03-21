//
//  Page.m
//  StylightTestTask
//
//  Created by Eugene Pavluk on 3/21/14.
//  Copyright (c) 2014 Eugene Pavlyuk. All rights reserved.
//

#import "Page.h"
#import "Item.h"
#import <MagicalRecord/NSManagedObject+MagicalRecord.h>
#import <MagicalRecord/NSManagedObject+MagicalFinders.h>
#import <MagicalRecord/NSManagedObjectContext+MagicalSaves.h>
#import <RestKit/Network.h>
#import <RestKit/CoreData.h>
#import "Constants.h"

static NSString * kPageIdKey            =   @"pageId";

@implementation Page

@dynamic pageId;
@dynamic lastUpdated;
@dynamic items;

+ (NSArray*)findAllSortedById
{
    return [self MR_findAllSortedBy:kPageIdKey ascending:YES];
}

+ (Page*)page
{
    Page *page = [self MR_createEntity];
    
    [page.managedObjectContext MR_saveToPersistentStoreAndWait];
    
    return page;
}

- (Page*)nextPage
{
    NSNumber *nextPageId = @([self.pageId integerValue] + 1);
    
    Page *page = [Page MR_findFirstByAttribute:kPageIdKey withValue:nextPageId];
    
    if (!page)
    {
        page = [Page MR_createEntity];
        page.pageId = nextPageId;
        
        [self.managedObjectContext MR_saveToPersistentStoreAndWait];
    }
    
    return page;
}

- (BOOL)isOlderThan15Minutes
{
    NSTimeInterval lastUpdate = [self.lastUpdated timeIntervalSince1970];
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    
    return (!self.lastUpdated || (now - lastUpdate > 15 * 60));
}

+ (RKObjectMapping*)mapping
{
    RKObjectManager *manager = [RKObjectManager sharedManager];
    
    RKEntityMapping *mapping = [RKEntityMapping mappingForEntityForName:NSStringFromClass(self) inManagedObjectStore:manager.managedObjectStore];
    
    NSMutableIndexSet *statusCodes = [[NSMutableIndexSet alloc] init];
    [statusCodes addIndexes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    RKEntityMapping *itemMapping = (RKEntityMapping*)[Item mapping];
    
    RKRelationshipMapping *relationshipMapping = [RKRelationshipMapping relationshipMappingFromKeyPath:kItemsKey toKeyPath:kItemsKey withMapping:itemMapping];
    
    [mapping addPropertyMapping:relationshipMapping];
    
    mapping.identificationAttributes = @[kPageIdKey];
    
    return mapping;
}

@end
