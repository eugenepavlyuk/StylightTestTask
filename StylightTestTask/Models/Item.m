//
//  Item.m
//  StylightTestTask
//
//  Created by Eugene Pavluk on 3/21/14.
//  Copyright (c) 2014 Eugene Pavlyuk. All rights reserved.
//

#import "Item.h"
#import <MagicalRecord/NSManagedObject+MagicalRecord.h>
#import <MagicalRecord/NSManagedObject+MagicalFinders.h>
#import <RestKit/Network.h>
#import <RestKit/CoreData.h>
#import "Constants.h"
#import "Board.h"
#import "Creator.h"
#import "Product.h"

static NSString * kItemIdKey            =   @"itemId";
static NSString * kOrderKey             =   @"order";
static NSString * kDatecreatedKey       =   @"datecreated";
static NSString * kBoardKey             =   @"board";
static NSString * kProductKey           =   @"product";

@implementation Item

@dynamic datecreated;
@dynamic itemId;
@dynamic order;
@dynamic page;
@dynamic board;
@dynamic product;

+ (RKObjectMapping*)mapping
{
    RKObjectManager *manager = [RKObjectManager sharedManager];

    RKEntityMapping *mapping = [RKEntityMapping mappingForEntityForName:NSStringFromClass(self) inManagedObjectStore:manager.managedObjectStore];

    NSMutableIndexSet *statusCodes = [[NSMutableIndexSet alloc] init];
    [statusCodes addIndexes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];

    [mapping addAttributeMappingsFromArray:@[[RKAttributeMapping attributeMappingFromKeyPath:kIdKey toKeyPath:kItemIdKey],
                                             kDatecreatedKey, kOrderKey]];

    RKEntityMapping *boardMapping = (RKEntityMapping*)[Board mapping];
    
    RKRelationshipMapping *relationshipMapping = [RKRelationshipMapping relationshipMappingFromKeyPath:kBoardKey toKeyPath:kBoardKey withMapping:boardMapping];
    
    [mapping addPropertyMapping:relationshipMapping];
    
    RKEntityMapping *productMapping = (RKEntityMapping*)[Product mapping];
    
    RKRelationshipMapping *productRelationshipMapping = [RKRelationshipMapping relationshipMappingFromKeyPath:kProductKey toKeyPath:kProductKey withMapping:productMapping];
    
    [mapping addPropertyMapping:productRelationshipMapping];
    
    mapping.identificationAttributes = @[kItemIdKey];
    
    return mapping;
}

+ (NSArray*)findAllSortedByOrder
{
    return [self MR_findAllSortedBy:kOrderKey ascending:YES];
}

- (NSString*)anyName
{
    if (self.board && [[self.board title] length])
    {
        return [self.board title];
    }
    else if (self.board.creator && ([self.board.creator.firstname length] || [self.board.creator.lastname length]))
    {
        if ([self.board.creator.firstname length])
        {
            return self.board.creator.firstname;
        }
        else
        {
            return self.board.creator.lastname;
        }
    }
    
    return @"name";
}

- (NSString*)anyDescription
{
    if (self.product && [self.product.desc length])
    {
        return self.product.desc;
    }
    
    return @"description";
}

- (NSString*)anyPictureLink
{
    return @"fdsfasdfa";
}

@end
