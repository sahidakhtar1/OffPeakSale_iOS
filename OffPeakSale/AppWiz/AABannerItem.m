//
//  AABannerItem.m
//  AppWiz
//
//  Created by Shaikh Shahid Akhtar on 27/11/14.
//  Copyright (c) 2014 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AABannerItem.h"
#import "AAMediaItem.h"
#import "AAHomePageHelper.h"

@implementation AABannerItem
@synthesize moviePlayerController;
@synthesize mediaItem,currentPlaybackTime;
@synthesize isYoutubePlayFinished,imgViewRetailerImage,delegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self = [self initialize];
        self.frame = frame;
        isYoutubePlayFinished = false;
        
        self.backgroundColor= [UIColor colorWithRed:0 green:0 blue:0 alpha:.3];
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (UIView*)initialize{
    UIView *childView= [[[NSBundle mainBundle] loadNibNamed:@"BannerItem" owner:self options:nil] objectAtIndex:0];
    
    return childView;
}
-(void) populateViewContents:(AAMediaItem*)item{
    //[self.webView removeFromSuperview];
    self.mediaItem = item;
    self.viewMediaContainer.frame= self.bounds;
    
    if([self.mediaItem.mediaType compare:RETAILER_FILE_TYPE_IMAGE options:NSCaseInsensitiveSearch] == NSOrderedSame/*[self.mediaItem.mediaType isEqualToString:RETAILER_FILE_TYPE_IMAGE]*/)
    {
       
        NSLog(@"image frame %@",NSStringFromCGRect(self.viewMediaContainer.frame));
        self.imgViewRetailerImage = (UIImageView*)[AAHomePageHelper getImageViewWithFrame:CGRectMake(0, 0, self.viewMediaContainer.frame.size.width, self.viewMediaContainer.frame.size.height) wtihImageUrl:[NSURL URLWithString:self.mediaItem.mediaUrl]];
        [self.imgViewRetailerImage setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth ];
        self.imgViewRetailerImage.contentMode = UIViewContentModeScaleToFill;
        [self.viewMediaContainer addSubview:self.imgViewRetailerImage];
        [self.ytPlayerView removeFromSuperview];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:self.imgViewRetailerImage.bounds];
        [btn addTarget:self action:@selector(imageTapped) forControlEvents:UIControlEventTouchUpInside];
        [self.viewMediaContainer addSubview:btn];
        
        
    }
    else if( [self.mediaItem.mediaType compare:RETAILER_FILE_TYPE_VIDEO options:NSCaseInsensitiveSearch] == NSOrderedSame)
    {
        
        
        NSURL *url = [NSURL URLWithString:self.mediaItem.mediaUrl];//path for vid
        
        self.moviePlayerController = [[MPMoviePlayerController alloc] initWithContentURL:url];
        //[self.moviePlayerController setScalingMode:MPMovieScalingModeAspectFill];
        self.moviePlayerController.scalingMode = MPMovieScalingModeAspectFill;
        self.moviePlayerController.movieSourceType = MPMovieSourceTypeFile;
        self.moviePlayerController.contentURL = url;
        [self.moviePlayerController.view setFrame:self.viewMediaContainer.bounds];
        self.moviePlayerController.shouldAutoplay = NO;
        self.moviePlayerController.fullscreen = YES;
        [self.moviePlayerController prepareToPlay];
        [self.moviePlayerController setControlStyle:MPMovieControlStyleNone];
        [self.viewMediaContainer addSubview:self.moviePlayerController.view];
        //[AAStyleHelper addLightShadowToView:self.moviePlayerController.view];
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideControl)
                                                     name:MPMoviePlayerLoadStateDidChangeNotification
                                                   object:self.moviePlayerController];
        [self.ytPlayerView removeFromSuperview];
        
//        [self.videoPlayerView setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth ];
//        self.videoPlayerView = [[AAVideoPlayerView alloc] initWithFrame:self.self.viewMediaContainer.bounds];
//        [self.videoPlayerView setVideoUrl:self.mediaItem.mediaUrl];
//        [self.viewMediaContainer  addSubview:self.videoPlayerView];
        
    }else if( [self.mediaItem.mediaType compare:RETAILER_FILE_TYPE_YOUTUBE_VIDEO options:NSCaseInsensitiveSearch] == NSOrderedSame){
        NSString *ytVideoId = nil;
        if ([self.mediaItem.mediaUrl containsString:@"www.youtube.com"]) {
            
            ytVideoId  = [self.mediaItem.mediaUrl lastPathComponent];
        }
        else{
            ytVideoId  = self.mediaItem.mediaUrl;
        }
        [self.ytPlayerView loadWithVideoId:ytVideoId];
        self.ytPlayerView.frame = self.viewMediaContainer.bounds;
    }
}

-(void)pauseVideo{
    if ( [self.mediaItem.mediaType isEqualToString:RETAILER_FILE_TYPE_VIDEO]) {
       self.currentPlaybackTime =   self.moviePlayerController.currentPlaybackTime;
        [self.moviePlayerController pause];
    }else if( [self.mediaItem.mediaType isEqualToString:RETAILER_FILE_TYPE_YOUTUBE_VIDEO]){
        //s[self.webView removeFromSuperview];
        [self.ytPlayerView pauseVideo];
    }
    
    
}
-(void)resumeVideo{
    if ( [self.mediaItem.mediaType isEqualToString:RETAILER_FILE_TYPE_VIDEO]) {
        self.moviePlayerController.currentPlaybackTime = self.currentPlaybackTime;
         //[self.moviePlayerController play];
    }else if( [self.mediaItem.mediaType isEqualToString:RETAILER_FILE_TYPE_YOUTUBE_VIDEO]){
        //[self playVideo];
        [self.ytPlayerView playVideo];
    }
   
}
-(void)hideControl
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self     name:MPMoviePlayerNowPlayingMovieDidChangeNotification object:self.moviePlayerController];
    [self.moviePlayerController setControlStyle:MPMovieControlStyleEmbedded];
    
}
-(void)playVideo{
    
    NSString *htmlString = @"<html><head>"
    "<meta name = \"viewport\" content = \"initial-scale = 1.0, user-scalable = no, width = 100%\"/></head>"
    "<body style=\"background:#000;margin-top:0px;margin-left:0px\">"
    "<div><object width=\"100%\" height=\"100%\">"
    " <param name=\"movie\" value=\"https://www.youtube.com/watch?v=C5pYRoGP520\"></param>"
    "<param name=\"wmode\" value=\"transparent\"></param>"
    " <embed src=\"https://www.youtube.com/watch?v=C5pYRoGP520\""
    "type=\"application/x-shockwave-flash\" wmode=\"transparent\" width=\"100%\" height=\"100%\"></embed>"
    " </object></div></body></html>";
    self.webView.frame = self.viewMediaContainer.bounds;
    
    [self.webView loadHTMLString:htmlString baseURL:nil];
    [self.viewMediaContainer addSubview:self.webView];
}
- (void)playerView:(YTPlayerView *)playerView didChangeToState:(YTPlayerState)state {
    switch (state) {
        case kYTPlayerStatePlaying:
            NSLog(@"Started playback");
            break;
        case kYTPlayerStatePaused:
            NSLog(@"Paused playback");
            break;
        case kYTPlayerStateEnded:
            isYoutubePlayFinished = true;
            break;
        default:
            break;
    }
}
-(void)imageTapped{
    if (self.imgViewRetailerImage.image == nil || self.delegate == nil ) {
        return;
    }
    if ([self.delegate respondsToSelector:@selector(presentZoomViewWithImage:)]) {
        [self.delegate presentZoomViewWithImage:self.imgViewRetailerImage.image];
    }
}
@end
