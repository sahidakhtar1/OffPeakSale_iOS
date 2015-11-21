//
//  AAPushNotificationPopupView.h
//  AppWiz
//
//  Created by Shahid Akhtar Shaikh on 30/12/13.
//  Copyright (c) 2013 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AABasePopupView.h"
#import "UIImageView+WebCache.h"
#import "AAThemeGlossyButton.h"
#import <MediaPlayer/MediaPlayer.h>
#import "AAVideoPlayerView.h"
@interface AAPushNotificationPopupView : AABasePopupView
@property (nonatomic,strong) AAVoucher* voucher;
@property (nonatomic,strong) MPMoviePlayerController* moviePlayerController;
@property (nonatomic, strong) AAVideoPlayerView *videoPlayerView;
//Create and returns push notification popup view given a background frame and an image url from the push notification
+(AAPushNotificationPopupView*)createPushNotificationPopupViewWithBackgroundFrameRect : (CGRect)backgroundFrameRect withVoucher:(AAVoucher*)voucher;
@end
