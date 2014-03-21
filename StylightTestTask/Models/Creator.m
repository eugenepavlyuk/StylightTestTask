//
//  Creator.m
//  StylightTestTask
//
//  Created by Eugene Pavluk on 3/21/14.
//  Copyright (c) 2014 Eugene Pavlyuk. All rights reserved.
//

#import "Creator.h"
#import <RestKit/Network.h>
#import <RestKit/CoreData.h>
#import "Constants.h"
#import "PhotoPreview.h"
#import <MagicalRecord/NSManagedObject+MagicalRecord.h>

static NSString * kCreatorIdKey         =   @"creatorId";
static NSString * kLastNameKey          =   @"lastname";
static NSString * kFirstNameKey         =   @"firstname";
static NSString * kPictureKey           =   @"picture";

@implementation Creator

@dynamic creatorId;
@dynamic picture;
@dynamic firstname;
@dynamic lastname;
@dynamic photoPreview;

+ (RKObjectMapping*)mapping
{
    RKObjectManager *manager = [RKObjectManager sharedManager];
    
    RKEntityMapping *mapping = [RKEntityMapping mappingForEntityForName:NSStringFromClass(self) inManagedObjectStore:manager.managedObjectStore];
    
    NSMutableIndexSet *statusCodes = [[NSMutableIndexSet alloc] init];
    [statusCodes addIndexes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    [mapping addAttributeMappingsFromArray:@[[RKAttributeMapping attributeMappingFromKeyPath:kIdKey toKeyPath:kCreatorIdKey],
                                             kLastNameKey, kFirstNameKey, kPictureKey]];
    
    mapping.identificationAttributes = @[kCreatorIdKey];
    
    return mapping;
}

- (PhotoPreview*)preview
{
    if ([self.picture length])
    {
        if (!self.photoPreview)
        {
            self.photoPreview = [PhotoPreview MR_createEntity];
            
            NSString *link = [@"http:" stringByAppendingString:self.picture];
            
            self.photoPreview.path = link;
        }
    }
    else
    {
        self.photoPreview = nil;
    }
    
    return self.photoPreview;
}

@end
