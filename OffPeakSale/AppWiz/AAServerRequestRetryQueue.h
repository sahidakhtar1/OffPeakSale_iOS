//
//  AAServerRequestRetryQueue.h
//  Swensens
//
//  Created by Shahid Akhtar Shaikh on 23/12/13.
//  Copyright (c) 2013 Shahid Akhtar Shaikh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AANetworkHandler.h"
@interface AAServerRequestRetryQueue : NSObject
extern NSString* const FAILED_REQUEST_ENDPOINT;
extern NSString* const FAILED_REQUEST_PARAMS;
@property (nonatomic,strong) NSMutableArray* failedRequests;
@property (nonatomic,strong) NSMutableIndexSet* indexesToRemove;
@property (nonatomic,strong) dispatch_queue_t queue;
-(void)processFailedRequests;
-(void)addFailedRequest:(NSDictionary*)failedRequest;
@end
