//
//  AALookBookHelper.h
//  AppWiz
//
//  Created by Shahid Akhtar Shaikh on 10/16/15.
//  Copyright (c) 2015 Shahid Akhtar Shaikh. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AALookBookResponseObject;
@interface AALookBookHelper : NSObject
+(void)getLookBookDataWithCompletionBlock : (void(^)(AALookBookResponseObject*))success andFailure : (void(^)(NSString*)) failure;
@end
