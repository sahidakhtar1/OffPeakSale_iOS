//
//  AAOrderHistoryHelper.h
//  AppWiz
//
//  Created by Shahid Akhtar Shaikh on 11/12/15.
//  Copyright © 2015 Shaikh Shahid Akhtar. All rights reserved.
//

#import <Foundation/Foundation.h>
@class  AAOrderHistoryObject;
@interface AAOrderHistoryHelper : NSObject
+(void)getOrderHostory:(NSString*)emailID
  withCompletionBlock : (void(^)(NSArray *))success
           andFailure : (void(^)(NSString*)) failure;
@end
