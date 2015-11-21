//
//  AARedeemRewardsHelper.h
//  AppWiz
//
//  Created by Shahid Akhtar Shaikh on 5/10/15.
//  Copyright (c) 2015 Shahid Akhtar Shaikh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AARedeemRewardsHelper : NSObject
+(void)redeemReward:(NSString*)rewards
withCompletionBlock:(void (^)(NSString *))success
                              andFailure:(void (^)(NSString *))failure;
@end
