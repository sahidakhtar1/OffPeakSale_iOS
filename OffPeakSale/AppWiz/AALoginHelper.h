//
//  AALoginHelper.h
//  AppWiz
//
//  Created by Shaikh Shahid Akhtar on 24/04/14.
//  Copyright (c) 2014 Shahid Akhtar Shaikh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AALoginHelper : NSObject
+(void)processForgotPaswordWithCompletionBlock : (void(^)(NSString*))success andFailure : (void(^)(NSString*)) failure withParams:(NSDictionary*)params;
+(void)processLoginWithCompletionBlock : (void(^)(void))success andFailure : (void(^)(NSString*)) failure withParams:(NSDictionary*)params;
@end
