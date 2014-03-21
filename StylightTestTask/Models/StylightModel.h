//
//  StylightModel.h
//  StylightTestTask
//
//  Created by Eugene Pavluk on 2/26/14.
//  Copyright (c) 2014 Eugene Pavlyuk. All rights reserved.
//

#import "ConnectionManager.h"

typedef void (^completionModelBlock) ();

typedef void (^failureModelBlock) (NSError *error);

@interface StylightModel : NSObject

@property (nonatomic, strong, readonly) NSMutableOrderedSet *items;

- (void)reset;

- (void)loadNextPageWithSuccessBlock:(completionModelBlock)success
                           onFailure:(failureModelBlock)failure;

@end
