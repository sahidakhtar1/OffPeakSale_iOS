//
//  AAVideoPlayerView.h
//  AppWiz
//
//  Created by Shahid Akhtar Shaikh on 22/2/14.
//  Copyright (c) 2014 Shahid Akhtar Shaikh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface AAVideoPlayerView : UIView <UIGestureRecognizerDelegate>
{
    UIView* controlView;
    UIButton* btnPlayPause;
    UIButton* btnToggleFullScreen;
}
@property (nonatomic,strong) AVPlayer *player;
@property (nonatomic,strong) AVPlayerItem *playerItem;


@property (nonatomic,strong) NSString* videoUrl;

@end
