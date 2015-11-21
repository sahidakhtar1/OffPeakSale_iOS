//
//  AAVideoPlayerView.m
//  AppWiz
//
//  Created by Shahid Akhtar Shaikh on 22/2/14.
//  Copyright (c) 2014 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AAVideoPlayerView.h"

@implementation AAVideoPlayerView
NSInteger const CONTROL_HEIGHT = 44;
static const NSString *ItemStatusContext = @"PlayerStatusContext";
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Register with the notification center after creating the player item.
        
        // Initialization code
        UITapGestureRecognizer* tgrGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleShowControls:)];
        tgrGestureRecognizer.delegate = self;
        [self addGestureRecognizer:tgrGestureRecognizer];
        
    }
    return self;
}



+ (Class)layerClass {
    return [AVPlayerLayer class];
}
- (AVPlayer*)player {
    return [(AVPlayerLayer *)[self layer] player];
}

- (void)setVideoFillMode:(NSString *)fillMode {
	AVPlayerLayer *playerLayer = (AVPlayerLayer*)[self layer];
	playerLayer.videoGravity = fillMode;
}
- (void)setPlayer:(AVPlayer *)player {
    [(AVPlayerLayer *)[self layer] setPlayer:player];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (void)syncUI {
    if ((self.player.currentItem != nil) &&
        ([self.player.currentItem status] == AVPlayerItemStatusReadyToPlay)) {
        btnPlayPause.enabled = YES;
    }
    else {
        btnPlayPause.enabled = NO;
    }
}

-(void)addControlView
{
   controlView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - CONTROL_HEIGHT,self.frame.size.width,CONTROL_HEIGHT )];
    UIView* backgroundView = [[UIView alloc] initWithFrame:controlView.bounds];
    [backgroundView setBackgroundColor:UIColorFromRGB(0xDEDEDE)];
    [backgroundView setAlpha:0.9];
    [controlView addSubview:backgroundView];
    [controlView setBackgroundColor:[UIColor clearColor]];
    btnPlayPause = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnPlayPause setFrame:CGRectMake(0, 0, 44, 44)];
    [controlView addSubview:btnPlayPause];
    //[btnPlayPause setTitle:@"Play" forState:UIControlStateNormal];
    [btnPlayPause setImage:[UIImage imageNamed:@"btn_play"] forState:UIControlStateNormal];
    [btnPlayPause addTarget:self action:@selector(btnPlayPauseTap:) forControlEvents:UIControlEventTouchUpInside];
    btnToggleFullScreen = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnToggleFullScreen setFrame:CGRectMake(self.frame.size.width-44.0, 0, 44, 44)];
   // [controlView addSubview:btnToggleFullScreen];
    [btnToggleFullScreen setTitle:@"Fullscreen" forState:UIControlStateNormal];
    [btnToggleFullScreen addTarget:self action:@selector(btnToggleFullscreenTap:) forControlEvents:UIControlEventTouchUpInside];
    [controlView setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];

    [self addSubview:controlView];
}

-(void)setVideoUrl:(NSString *)videoUrl
{
    
    
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:[NSURL URLWithString:videoUrl] options:nil];
    NSString *tracksKey = @"tracks";
    
    [asset loadValuesAsynchronouslyForKeys:@[tracksKey] completionHandler:
     ^{
         dispatch_async(dispatch_get_main_queue(),
                        ^{
                            NSError *error;
                            AVKeyValueStatus status = [asset statusOfValueForKey:tracksKey error:&error];
                            
                            if (status == AVKeyValueStatusLoaded) {
                                self.playerItem = [AVPlayerItem playerItemWithAsset:asset];
                                [self.playerItem addObserver:self forKeyPath:@"status"
                                                     options:0 context:&ItemStatusContext];
                                [[NSNotificationCenter defaultCenter] addObserver:self
                                                                         selector:@selector(playerItemDidReachEnd:)
                                                                             name:AVPlayerItemDidPlayToEndTimeNotification
                                                                           object:self.playerItem];
                                self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
                                [self setVideoFillMode:AVLayerVideoGravityResizeAspect];
                                [self setPlayer:self.player];
                                [self addControlView];
                                [self syncUI];
                            }
                            else {
                                // You should deal with the error appropriately.
                                NSLog(@"The asset's tracks were not loaded:\n%@", [error localizedDescription]);
                            }
                        });

     }];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                        change:(NSDictionary *)change context:(void *)context {
    
    if (context == &ItemStatusContext) {
        dispatch_async(dispatch_get_main_queue(),
                       ^{
                           [self syncUI];
                       });
        return;
    }
    [super observeValueForKeyPath:keyPath ofObject:object
                           change:change context:context];
    return;
}


-(void)btnPlayPauseTap : (id)sender
{
    if([self isPlaying])
    {
        [btnPlayPause setImage:[UIImage imageNamed:@"btn_play"] forState:UIControlStateNormal];
        [self.player pause];
    }
    else
    {
        [btnPlayPause setImage:[UIImage imageNamed:@"btn_pause"] forState:UIControlStateNormal];
        [controlView setHidden:YES];
    [self.player play];
    }
    
}
-(void)btnToggleFullscreenTap:(id)sender
{
   
}

-(BOOL)isPlaying
{
    if ([self.player rate] != 0.0)
    {
        return YES;
    }
    return NO;
}


-(void)playerItemDidReachEnd : (id)sender

{
     [self.player seekToTime:kCMTimeZero];
}

-(void)dealloc
{
    [[NSNotificationCenter  defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:[self.player currentItem]];
    [self.playerItem removeObserver:self forKeyPath:@"status"
                            context:&ItemStatusContext];
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if([touch.view isKindOfClass:[UIControl class]])
    {
        return NO;
    }
    return YES;
}

-(void)toggleShowControls : (id)sender
{
    controlView.hidden = !controlView.hidden;
}
@end
