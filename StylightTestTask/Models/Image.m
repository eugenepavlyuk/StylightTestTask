//
//  Image.m
//  StylightTestTask
//
//  Created by Eugene Pavluk on 3/21/14.
//  Copyright (c) 2014 Eugene Pavlyuk. All rights reserved.
//

#import "Image.h"
#import <RestKit/Network.h>
#import <RestKit/CoreData.h>

static NSString * kPrimaryKey           =   @"primary";
static NSString * kUrlKey               =   @"url";

@implementation Image

@dynamic url;
@dynamic primary;

+ (RKObjectMapping*)mapping
{
    RKObjectManager *manager = [RKObjectManager sharedManager];
    
    RKEntityMapping *mapping = [RKEntityMapping mappingForEntityForName:NSStringFromClass(self) inManagedObjectStore:manager.managedObjectStore];
    
    NSMutableIndexSet *statusCodes = [[NSMutableIndexSet alloc] init];
    [statusCodes addIndexes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    [mapping addAttributeMappingsFromArray:@[kPrimaryKey, kUrlKey]];
    
    mapping.identificationAttributes = @[kUrlKey];
    
    return mapping;
}

@end
