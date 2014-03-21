//
//  Creator.h
//  StylightTestTask
//
//  Created by Eugene Pavluk on 3/21/14.
//  Copyright (c) 2014 Eugene Pavlyuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class RKObjectMapping;
@class PhotoPreview;

@interface Creator : NSManagedObject

@property (nonatomic, retain) NSNumber * creatorId;
@property (nonatomic, retain) NSString * picture;
@property (nonatomic, retain) NSString * firstname;
@property (nonatomic, retain) NSString * lastname;

@property (nonatomic, retain) PhotoPreview *photoPreview;

+ (RKObjectMapping*)mapping;

- (PhotoPreview*)preview;

@end
