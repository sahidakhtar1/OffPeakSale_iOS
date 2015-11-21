//
//  AABannerItem.h
//  AppWiz
//
//  Created by Shaikh Shahid Akhtar on 27/11/14.
//  Copyright (c) 2014 Shahid Akhtar Shaikh. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AAMediaItem;
#import <MediaPlayer/MediaPlayer.h>
#import "AAVideoPlayerView.h"
#import "YTPlayerView.h";

@protocol ProductImageZoomeDelegate <NSObject>

-(void)presentZoomViewWithImage:(UIImage*)image;

@end

@interface AABannerItem : UIView<YTPlayerViewDelegate>

@property Boolean isYoutubePlayFinished;
@property (weak, nonatomic) IBOutlet UIView *viewMediaContainer;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet YTPlayerView *ytPlayerView;
@property (strong, nonatomic) AAMediaItem *mediaItem;
@property (strong, nonatomic) MPMoviePlayerController *moviePlayerController;
@property (nonatomic) NSTimeInterval currentPlaybackTime;
@property (nonatomic,strong) AAVideoPlayerView* videoPlayerView;
@property (nonatomic, strong) UIImageView* imgViewRetailerImage;
-(void) populateViewContents:(AAMediaItem*)item;
@property (nonatomic, unsafe_unretained) id <ProductImageZoomeDelegate> delegate;

-(void)pauseVideo;
-(void)resumeVideo;
@end
