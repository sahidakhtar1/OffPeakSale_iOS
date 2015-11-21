//
//  AACategoryHelper.h
//  AppWiz
//
//  Created by Shahid Akhtar Shaikh on 5/11/15.
//  Copyright (c) 2015 Shahid Akhtar Shaikh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AACategoryHelper : NSObject
+(void)refreshEshopCategoryWithCompletionBlock : (void(^)(void))success;
@end
