//
//  AAVoucherTableViewCell.m
//  AppWiz
//
//  Created by Shahid Akhtar Shaikh on 30/12/13.
//  Copyright (c) 2013 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AAVoucherTableViewCell.h"

@implementation AAVoucherTableViewCell
static NSInteger BUTTON_WIDTH = 40;
static NSInteger BUTTON_HEIGHT = 40;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        //[self addVoucherInformation];
        self.btnDeleteVoucher = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.btnDeleteVoucher setFrame:CGRectMake(self.viewMainContent.frame.size.width - BUTTON_WIDTH, 0, BUTTON_WIDTH, BUTTON_HEIGHT)];
        [self.btnDeleteVoucher setBackgroundImage:[UIImage imageNamed:@"delete_voucher_button"] forState:UIControlStateNormal];
        [self.btnDeleteVoucher addTarget:self action:@selector(btnDeleteVoucherTap:) forControlEvents:UIControlEventTouchUpInside];
        [self.btnDeleteVoucher setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin ];
        [self.viewMainContent addSubview:self.btnDeleteVoucher];

    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)addVoucherInformation
{
    
    for(UIView* view in self.viewMainContent.subviews)
    {
        if(view!=self.btnDeleteVoucher)
        {
            [view removeFromSuperview];
        }
    }
   
    if([self.voucher.voucherFileType isEqualToString:VOUCHER_FILE_TYPE_IMAGE])
    {
        [self addVoucherImageView];
    }
    else if([self.voucher.voucherFileType isEqualToString:VOUCHER_FILE_TYPE_VIDEO])
    {
        [self addVoucherVideoView];
    }
        
}

-(void)setVoucher:(AAVoucher *)voucher
{
    _voucher = voucher;
    [self addVoucherInformation
     ];
}

-(void)addVoucherImageView
{
    
    self.ivVoucher = [[UIImageView alloc] initWithFrame:self.viewMainContent.bounds];
    [self.ivVoucher setImageWithURL:[NSURL URLWithString:self.voucher.voucherFileUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        
    }];
    [self.ivVoucher setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth ];
    [self.ivVoucher setClipsToBounds:YES];
    //[self.ivVoucher setContentMode:UIViewContentModeScaleAspectFill];
    [self.viewMainContent insertSubview:self.ivVoucher belowSubview:self.btnDeleteVoucher];
    
    }
-(void)addVoucherVideoView
{
    
    /*

    self.moviePlayerController = [[MPMoviePlayerController alloc] initWithContentURL:[ NSURL URLWithString:self.voucher.voucherFileUrl]];
    //[self.moviePlayerController setScalingMode:MPMovieScalingModeAspectFill];
    self.moviePlayerController.scalingMode = MPMovieScalingModeAspectFill;
    self.moviePlayerController.movieSourceType = MPMovieSourceTypeFile;
    self.moviePlayerController.contentURL = [ NSURL URLWithString:self.voucher.voucherFileUrl];
    [self.moviePlayerController.view setFrame:self.viewMainContent.bounds];
    self.moviePlayerController.shouldAutoplay = NO;
    //self.moviePlayerController.fullscreen = YES;
    [self.moviePlayerController prepareToPlay];
    [self.moviePlayerController setControlStyle:MPMovieControlStyleEmbedded];
     [self.viewMainContent insertSubview:self.moviePlayerController.view belowSubview:self.btnDeleteVoucher];*/
    
    self.videoPlayerView = [[AAVideoPlayerView alloc] initWithFrame:self.viewMainContent.bounds];
    [self.videoPlayerView setVideoUrl:self.voucher.voucherFileUrl];
    [self.viewMainContent  insertSubview:self.videoPlayerView belowSubview:self.btnDeleteVoucher];
    [self.videoPlayerView setAutoresizingMask:UIViewAutoresizingFlexibleWidth ];
    self.videoPlayerView.backgroundColor = [UIColor whiteColor];
    self.viewMainContent.backgroundColor = [UIColor whiteColor];
    
}



-(void)btnDeleteVoucherTap : (id)sender
{
    if (self.moviePlayerController) {
        [self.moviePlayerController stop];
    }
    int tag = [(UIButton*)sender tag];
    [self.delegate onVoucherDeleteTap:tag];
}
@end
