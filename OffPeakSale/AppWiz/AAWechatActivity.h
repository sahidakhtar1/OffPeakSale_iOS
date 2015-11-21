//
//  AAWechatActivity.h
//  AppWiz
//
//  Created by Shaikh Shahid Akhtar on 14/12/14.
//  Copyright (c) 2014 Shahid Akhtar Shaikh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXApi.h"
@interface AAWechatActivity : UIActivity
@property (nonatomic, strong) UIImage *shareImage;
@property (nonatomic, strong) NSString *shareString;
//@property (nonatomic, strong) SendMessageToWXReq* req;
@end
