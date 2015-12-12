//
//  AAContactHelper.h
//  AppWiz
//
//  Created by Shahid Akhtar Shaikh on 12/12/15.
//  Copyright © 2015 Shaikh Shahid Akhtar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AAContactHelper : NSObject
+(void)sendContactMailWithName:(NSString*)name
                       emailId:(NSString*)emailId
                       subject:(NSString*)subject
                    andMessage:(NSString*)msg
          withCompletionBlock : (void(^)(NSString *))success
                   andFailure : (void(^)(NSString*)) failure;
@end
