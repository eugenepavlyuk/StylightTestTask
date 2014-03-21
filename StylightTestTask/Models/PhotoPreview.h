//
//  PhotoPreview.h
//  StylightTestTask
//
//  Created by Eugene Pavluk on 12/8/13.
//  Copyright (c) 2013 Eugene Pavlyuk. All rights reserved.
//

#import <CoreData/NSManagedObject.h>
#import "FICEntity.h"

@interface PhotoPreview : NSManagedObject <FICEntity>

@property (nonatomic, retain) NSString *path;

@end
