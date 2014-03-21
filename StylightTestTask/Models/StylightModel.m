//
//  StylightModel.m
//  StylightTestTask
//
//  Created by Eugene Pavluk on 2/26/14.
//  Copyright (c) 2014 Eugene Pavlyuk. All rights reserved.
//

#import "StylightModel.h"
#import "Item.h"
#import "Page.h"
#import <RestKit/Network.h>
#import <RestKit/ObjectMapping.h>
#import "Constants.h"
#import <MagicalRecord/NSManagedObjectContext+MagicalSaves.h>

static NSString *const kPageKey                     =   @"page";

static NSString *const kNewPath                     =   @"new";

@interface StylightModel()

@property (nonatomic, strong, readwrite) NSMutableOrderedSet *items;

@end

@implementation StylightModel
{
    Page *currentPage;
}

- (id)init
{
    self = [super init];
    
    if (self)
    {
        [self setupMapping];
        
        _items = [NSMutableOrderedSet orderedSet];
        NSArray *pages = [Page findAllSortedById];
        
        if ([pages count])
        {
            currentPage = [pages firstObject];
        }
        else
        {
            currentPage = [Page page];
        }
        
        [self.items unionOrderedSet:currentPage.items];
    }
    
    return self;
}

- (void)loadNextPageWithSuccessBlock:(completionModelBlock)success
                           onFailure:(failureModelBlock)failure
{
    if (![currentPage isOlderThan15Minutes])
    {
        [self.items unionOrderedSet:currentPage.items];
        currentPage = [currentPage nextPage];
        success();
        return ;
    }
    
    [[ConnectionManager sharedInstance] sendRequestWithLink:kNewPath
                                                     object:currentPage
                                                   withInfo:@{kPageKey : currentPage.pageId}
                                                     method:RKRequestMethodGET
                                               onCompletion:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                   
                                                   [self.items unionOrderedSet:currentPage.items];
                                                   
                                                   currentPage.lastUpdated = [NSDate date];
                                                   
                                                   [currentPage.managedObjectContext MR_saveToPersistentStoreAndWait];
                                                   
                                                   currentPage = [currentPage nextPage];
                                                   
                                                   success();
                                                   
                                               } onFailure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                   
                                                   failure(error);
                                               }];
}

- (void)setupMapping
{
    RKObjectManager *manager = [RKObjectManager sharedManager];
    
    RKObjectMapping *pageMapping = [Page mapping];
    
    NSMutableIndexSet *statusCodes = [[NSMutableIndexSet alloc] init];
    [statusCodes addIndexes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:pageMapping
                                                                                            method:RKRequestMethodGET
                                                                                       pathPattern:kNewPath
                                                                                           keyPath:nil
                                                                                       statusCodes:statusCodes];
    [manager addResponseDescriptor:responseDescriptor];
}

- (void)reset
{
    [self.items removeAllObjects];
    
    NSArray *pages = [Page findAllSortedById];
    
    if ([pages count])
    {
        currentPage = [pages firstObject];
    }
    else
    {
        currentPage = [Page page];
    }
}

@end
