//
//  Product.m
//  StylightTestTask
//
//  Created by Eugene Pavluk on 3/21/14.
//  Copyright (c) 2014 Eugene Pavlyuk. All rights reserved.
//

#import "Product.h"
#import <RestKit/Network.h>
#import <RestKit/CoreData.h>
#import "Constants.h"
#import "PhotoPreview.h"
#import "Image.h"
#import <MagicalRecord/NSManagedObject+MagicalRecord.h>

static NSString * kProductIdKey         =   @"productId";
static NSString * kDescriptionKey       =   @"desc";
static NSString * kNameKey              =   @"name";
static NSString * kImagesKey            =   @"images";

@implementation Product

@dynamic productId;
@dynamic desc;
@dynamic name;
@dynamic images;
@dynamic photoPreview;

+ (RKObjectMapping*)mapping
{
    RKObjectManager *manager = [RKObjectManager sharedManager];
    
    RKEntityMapping *mapping = [RKEntityMapping mappingForEntityForName:NSStringFromClass(self) inManagedObjectStore:manager.managedObjectStore];
    
    NSMutableIndexSet *statusCodes = [[NSMutableIndexSet alloc] init];
    [statusCodes addIndexes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    [mapping addAttributeMappingsFromArray:@[[RKAttributeMapping attributeMappingFromKeyPath:kIdKey toKeyPath:kProductIdKey],
                                             kDescriptionKey, kNameKey]];
    
    RKEntityMapping *imageMapping = (RKEntityMapping*)[Image mapping];
    
    RKRelationshipMapping *imageRelationshipMapping = [RKRelationshipMapping relationshipMappingFromKeyPath:kImagesKey toKeyPath:kImagesKey withMapping:imageMapping];
    
    [mapping addPropertyMapping:imageRelationshipMapping];
    
    mapping.identificationAttributes = @[kProductIdKey];
    
    return mapping;
}

- (PhotoPreview*)preview
{
    if ([self.images count])
    {
        if (!self.photoPreview)
        {
            self.photoPreview = [PhotoPreview MR_createEntity];
            
            Image *image = self.images[0];
            
            self.photoPreview.path = image.url;
        }
    }
    else
    {
        self.photoPreview = nil;
    }
    
    return self.photoPreview;
}

@end
