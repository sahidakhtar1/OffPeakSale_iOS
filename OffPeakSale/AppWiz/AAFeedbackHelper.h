//
//  AAFeedbackHelper.h
//  AppWiz
//
//  Created by Shahid Akhtar Shaikh on 1/1/14.
//  Copyright (c) 2014 Shahid Akhtar Shaikh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AAFeedbackHelper : NSObject
extern NSString* const JSON_FRIEND_NAME_KEY;
extern NSString* const JSON_FRIEND_EMAIL_KEY;
extern NSString* const JSON_FRIEND_MOBILE_KEY;
extern NSString* const JSON_FEEDBACK_CONSUMER_EMAIL_KEY;
extern NSString* const JSON_FEEDBACK_SUB_KEY;
extern NSString* const JSON_FEEDBACK_MSG_KEY;
+(void)getFeedbackGiftFromServerWithCompletionBlock : (void(^)(void))success andFailure:(void(^)(void))failure;
+(void)sendFeedbackInformationToServer:(NSDictionary*)dictFeedbackInformation withCompletionBlock : (void(^)(NSString*))success andFailure:(void(^)(NSString*))failure;
+(void)sendReferFriendToServer:(NSDictionary*)dictReferFriendInformation withCompletionBlock : (void(^)(NSString*))success andFailure:(void(^)(NSString*))failure;
@end
