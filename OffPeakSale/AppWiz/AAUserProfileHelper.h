//
//  AAUserProfileHelper.h
//  AppWiz
//
//  Created by Shahid Akhtar Shaikh on 5/9/15.
//  Copyright (c) 2015 Shahid Akhtar Shaikh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AAUserProfileHelper : NSObject
+(void)getUserProfilewithCompletionBlock:(void (^)(void))success
                        andFailure:(void (^)(NSString *))failure;
@end
