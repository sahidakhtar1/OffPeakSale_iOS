//
//  AAServerRequestRetryQueue.m
//  Swensens
//
//  Created by Shahid Akhtar Shaikh on 23/12/13.
//  Copyright (c) 2013 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AAServerRequestRetryQueue.h"

@implementation AAServerRequestRetryQueue
NSString* const FAILED_REQUEST_ENDPOINT = @"FAILED_REQUEST_ENDPOINT";
NSString* const FAILED_REQUEST_PARAMS = @"FAILED_REQUEST_PARAMS";
NSString* const USER_DEFAULTS_RETRY_QUEUE_KEY = @"retry_queue";
- (id)init
{
    self = [super init];
    if (self) {
        self.failedRequests = [[NSMutableArray alloc] init];
        self.indexesToRemove = [[NSMutableIndexSet alloc] init];
        self.queue = dispatch_queue_create("com.appsauthority.failedRequestQueue", NULL);
        [self loadRequestsFromUserDefaults];
    }
    return self;
}

-(void)addFailedRequest:(NSDictionary*)failedRequest
{
    dispatch_sync(self.queue, ^{
        [self.failedRequests addObject:failedRequest];
        NSData *dataRetryQueue = [NSKeyedArchiver archivedDataWithRootObject:self.failedRequests];
        
        [[NSUserDefaults standardUserDefaults] setObject:dataRetryQueue forKey:USER_DEFAULTS_RETRY_QUEUE_KEY];
        [[NSUserDefaults standardUserDefaults] synchronize];
    });
    
}

-(void)processFailedRequests
{
    __block  NSMutableArray* arrFailedRequests = nil;    dispatch_sync(self.queue, ^{
        
    
    [self.failedRequests removeObjectsAtIndexes:self.indexesToRemove];
    arrFailedRequests  = self.failedRequests.mutableCopy;
    });
    for(NSDictionary* failedRequest in arrFailedRequests)
    {
        [[AAAppGlobals sharedInstance].networkHandler sendJSONRequestToServerWithEndpoint:[failedRequest objectForKey:FAILED_REQUEST_ENDPOINT] withParams:[failedRequest objectForKey: FAILED_REQUEST_PARAMS] withSuccessBlock:^(id response) {
            [self.indexesToRemove addIndex:[arrFailedRequests indexOfObject:failedRequest] ];
        } withFailureBlock:^(NSError *error) {
            
        }];
    }
}


-(void)loadRequestsFromUserDefaults
{
    if([[NSUserDefaults standardUserDefaults] objectForKey:USER_DEFAULTS_RETRY_QUEUE_KEY])
    {
    NSData *dataRetryQueue = [[NSUserDefaults standardUserDefaults] objectForKey:USER_DEFAULTS_RETRY_QUEUE_KEY];
    self.failedRequests = [NSKeyedUnarchiver unarchiveObjectWithData:dataRetryQueue];
    }
}
@end
