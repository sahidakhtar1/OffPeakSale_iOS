//
//  AAConsumerProfileHelper.h
//  Swensens
//
//  Created by Shahid Akhtar Shaikh on 20/12/13.
//  Copyright (c) 2013 Shahid Akhtar Shaikh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AAConsumerProfileHelper : NSObject
+(void)saveConsumerProfileWithDictionary: (NSDictionary*)dictConsumerProfileJSON withCompletionBlock : (void(^)(void))success andFailure : (void(^)(NSString*))failure;
+(void)saveCommercialProfileWithDictionary: (NSDictionary*)dictConsumerProfileJSON isNewUser:(BOOL)isNewUser withCompletionBlock : (void(^)(void))success andFailure : (void(^)(NSString*))failure;
@end
