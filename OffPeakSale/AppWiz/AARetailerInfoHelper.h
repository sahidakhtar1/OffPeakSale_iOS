//
//  AARetailerInfoHelper.h
//  Swensens
//
//  Created by Shahid Akhtar Shaikh on 17/12/13.
//  Copyright (c) 2013 Shahid Akhtar Shaikh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AARetailerInfoHelper : NSObject

+(void)processRetailerInformationWithCompletionBlock : (void(^)(void))success andFailure : (void(^)(NSString*)) failure;

@end
