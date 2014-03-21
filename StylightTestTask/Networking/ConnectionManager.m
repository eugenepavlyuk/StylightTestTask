//
//  ConnectionManager.m
//  StylightTestTask
//
//  Created by Eugene Pavluk on 2/12/14.
//  Copyright (c) 2014 Eugene Pavlyuk. All rights reserved.
//

#import "ConnectionManager.h"
#import "ConnectionManager+CoreData.h"

#import "RKErrorMessage+MappingDescriptor.h"
#import <RestKit/Network.h>
#import <RestKit/ObjectMapping.h>
#import <RestKit/Support.h>

static NSString *const kEndPointPath       =   @"http://api.stylight.com/api";
static NSString *const kXApiHeaderKey      =   @"X-apiKey";
static NSString *const kXAPIHeader         =   @"D13A5A5A0A3602477A513E02691A8458";

static NSString *const kGenderKey                   =   @"gender";
static NSString *const kWomen                       =   @"women";
static NSString *const kInitializeBoardsKey         =   @"initializeBoards";
static NSString *const kTrue                        =   @"true";
static NSString *const kInitializeRowsKey           =   @"initializeRows";
static NSString *const kNumberRows                  =   @"1024000";
static NSString *const kPageItemsKey                =   @"pageItems";
static NSString *const kPageKey                     =   @"page";
static NSString *const kFetchLimit                  =   @"10";

static ConnectionManager *connectionManager = nil;

@interface ConnectionManager()


@end


@implementation ConnectionManager
{
    RKObjectManager *objectManager;
}

+ (ConnectionManager*)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        connectionManager = [[ConnectionManager alloc] init];
    });
    
    return connectionManager;
}

- (id)init
{
    self = [super init];
    
    if (self)
    {
#ifdef DEBUG
        
        RKLogConfigureByName("RestKit/Network", RKLogLevelTrace);
#else
        
        RKLogConfigureByName("RestKit/Network", RKLogLevelOff);
        
#endif
        
        [self setupObjectManager];
        [self setupCoreData];
        [self setupMappings];
        
        [objectManager.operationQueue addObserver:self
                                       forKeyPath:@"operationCount"
                                          options: NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld
                                          context:NULL];
    }
    
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	if( object == objectManager.operationQueue && [keyPath isEqual:@"operationCount"])
    {
        NSNumber* newVal = [change objectForKey:NSKeyValueChangeNewKey];
        NSNumber* oldVal = [change objectForKey:NSKeyValueChangeOldKey];
        
        if ([newVal integerValue] >= 1 && [oldVal integerValue] == 0)
        {
            // the first request is added to queue
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
                
            });
        }
        
        if([newVal integerValue] == 0 && [oldVal integerValue] >= 1)
        {
            // last request was removed from queue
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

            });
        }
    }
}

- (void)setupMappings
{
    [RKErrorMessage setupMapping];
}

- (void)setupObjectManager
{
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:kEndPointPath]];
    
    [httpClient setDefaultHeader:kXApiHeaderKey value:kXAPIHeader];
    
    RKObjectManager *manager = [[RKObjectManager alloc] initWithHTTPClient:httpClient];
    
    [RKMIMETypeSerialization registerClass:[RKNSJSONSerialization class] forMIMEType:@"text/plain"];
    
    [manager.HTTPClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    
    [manager setAcceptHeaderWithMIMEType:RKMIMETypeJSON];
    
    manager.requestSerializationMIMEType = RKMIMETypeJSON;
    
    [RKObjectManager setSharedManager:manager];
    
    objectManager = manager;
}

- (void)sendRequestWithLink:(NSString*)link
                     object:(id)object
                   withInfo:(NSDictionary*)info
                     method:(RKRequestMethod)method
               onCompletion:(completionBlock)success
                  onFailure:(failureBlock)failure
{
    NSMutableDictionary *parameters = [info mutableCopy];
    
    [parameters setObject:kWomen forKey:kGenderKey];
    [parameters setObject:kTrue forKey:kInitializeBoardsKey];
    [parameters setObject:kNumberRows forKey:kInitializeRowsKey];
    [parameters setObject:kFetchLimit forKey:kPageItemsKey];
    
    RKObjectRequestOperation *operation = [objectManager appropriateObjectRequestOperationWithObject:object
                                                                                              method:method
                                                                                                path:link
                                                                                          parameters:parameters];
    
    [operation setCompletionBlockWithSuccess:success failure:failure];
    
    [objectManager enqueueObjectRequestOperation:operation];
}

@end
