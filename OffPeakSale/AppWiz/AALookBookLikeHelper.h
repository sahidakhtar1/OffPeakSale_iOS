//
//  AALookBookLikeHelper.h
//  AppWiz
//
//  Created by Shahid Akhtar Shaikh on 10/17/15.
//  Copyright (c) 2015 Vignesh Badrinath Krishna. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AALookBookLikeHelper : NSObject
+(void)lookBookLikeItem:(NSString*)itemId withCompletionBlock : (void(^)( NSString*,NSString*))success andFailure : (void(^)(NSString*)) failure;
@end
