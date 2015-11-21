//
//  AASplashPageHelper.h
//  Swensens
//
//  Created by Shahid Akhtar Shaikh on 22/12/13.
//  Copyright (c) 2013 Shahid Akhtar Shaikh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AASplashPageHelper : NSObject
+(void)getSplashScreenImageWithCompletionBlock : (void(^)(void))success andFailure:(void(^)(NSString*))failure;
@end
