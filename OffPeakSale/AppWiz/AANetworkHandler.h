//
//  AANetworkHandler.h
//  Swensens
//
//  Created by Shahid Akhtar Shaikh on 15/12/13.
//  Copyright (c) 2013 Shahid Akhtar Shaikh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>

@interface AANetworkHandler : NSObject
-(void)sendJSONRequestToServerWithEndpoint :(NSString*)endpoint withParams : (NSDictionary*)params withSuccessBlock : (void(^)(id))success withFailureBlock :(void(^)(NSError*)) failure;


@end
