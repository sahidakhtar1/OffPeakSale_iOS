//
//  AAAddHelper.h
//  AppWiz
//
//  Created by Shahid Akhtar Shaikh on 30/1/14.
//  Copyright (c) 2014 Shahid Akhtar Shaikh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AAAddHelper : NSObject
+(void)getPublisherIdFromServerWithCompletionBlock : (void(^)(void))success andFailure : (void(^)(NSString*))failure;
@end
