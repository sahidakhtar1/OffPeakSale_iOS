//
//  AACountriesHelper.h
//  Swensens
//
//  Created by Shahid Akhtar Shaikh on 20/12/13.
//  Copyright (c) 2013 Shahid Akhtar Shaikh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AACountriesHelper : NSObject
+(void)getCountriesFromServerWithCompletionBlock : (void(^)(NSMutableArray*))success andFailure : (void(^)(NSString*))failure;
+(void)getIndustriesFromServerWithCompletionBlock:(void (^)(NSMutableArray *))success andFailure:(void (^)(NSString *))failure;
@end
