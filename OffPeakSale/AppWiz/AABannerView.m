//
//  AABannerView.m
//  AppWiz
//
//  Created by Shaikh Shahid Akhtar on 27/11/14.
//  Copyright (c) 2014 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AABannerView.h"
#import "AAMediaItem.h"
#import "AABannerItem.h"
@implementation AABannerView
@synthesize bannerItems;
@synthesize bannerItemViews;
@synthesize mTimer;
@synthesize currentPage;
@synthesize delegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self = [self initialize];
        self.frame = frame;
        
        //self.backgroundColor= [UIColor colorWithRed:0 green:0 blue:0 alpha:.3];
    }
    return self;
}
-(void)awakeFromNib{
    //self = [self initialize];
    [super awakeFromNib];
    
    // commenters report the next line causes infinite recursion, so removing it
     //[[NSBundle mainBundle] loadNibNamed:@"BannerView" owner:self options:nil];
    //[self addSubview:self.mScrollView];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (UIView*)initialize{
    UIView *childView= [[[NSBundle mainBundle] loadNibNamed:@"BannerView" owner:self options:nil] objectAtIndex:0];
    
    return childView;
}

-(void) populateItems{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(startTimer)
                                                 name:START_TIMER
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(stopTime)
                                                 name:STOP_TIMER
                                               object:nil];
    self.currentPage = 0;
    CGRect frame = self.frame;
    [self.mScrollView setContentSize:CGSizeMake(frame.size.width * self.bannerItems.count, frame.size.height)];
    self.mScrollView.frame = self.bounds;
    [self startTimer];
    if (self.mScrollView == nil) {
        NSLog(@"scroll view is nil");
    }
    self.bannerItemViews = nil;
    self.bannerItemViews = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.bannerItems.count; i++) {
        AAMediaItem *item = [self.bannerItems objectAtIndex:i];
        AABannerItem *banner = [[AABannerItem alloc] initWithFrame:CGRectMake(self.mScrollView.frame.size.width*i,
                                                                              0,
                                                                              self.mScrollView.frame.size.width,
                                                                              self.mScrollView.frame.size.height)];
        if (self.delegate != nil) {
            banner.delegate = self.delegate;
        }
        [self.mScrollView addSubview:banner];
        
        //banner.mediaItem = item;
        [banner populateViewContents:item];
        [self.bannerItemViews addObject:banner];
        
    }
    [self.pageIndicatorView setNumberOfPages:self.bannerItemViews.count];
    [self.pageIndicatorView setCurrentPage:0];
    [self bringSubviewToFront:self.pageIndicatorView];
    
    
}
-(void)startTimer{
    if (self.bannerItems.count>1) {
        [self stopTime];
        mTimer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(changeBanner) userInfo:nil repeats:YES];
        for (int i = 0; i< self.bannerItemViews.count; i++) {
            AABannerItem *banner = [self.bannerItemViews objectAtIndex:i];
            if (i == currentPage) {
                [banner resumeVideo];
            }else{
                [banner pauseVideo];
            }
        }
    }
     NSLog(@"startTimer");
}
-(void)stopTime{
    if (self.mTimer != nil) {
        [self.mTimer invalidate];
        self.mTimer = nil;
    }
    for (int i = 0; i< self.bannerItemViews.count; i++) {
        AABannerItem *banner = [self.bannerItemViews objectAtIndex:i];
        [banner pauseVideo];
    }
    NSLog(@"stopTime");
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGPoint offset = scrollView.contentOffset;
    int page = offset.x/scrollView.frame.size.width;
    if (page == currentPage) {
        return;
    }
    for (int i = 0; i< self.bannerItemViews.count; i++) {
        AABannerItem *banner = [self.bannerItemViews objectAtIndex:i];
        if (i == page) {
            [banner resumeVideo];
        }else{
            [banner pauseVideo];
        }
    }
    currentPage = page;
    [self.pageIndicatorView setCurrentPage:currentPage];
    [self startTimer];
}
-(void)changeBanner{
    CGPoint offset = self.mScrollView.contentOffset;
    int page = offset.x/self.mScrollView.frame.size.width;
   
    if (page<self.bannerItems.count-1) {
        page ++;
    }else if(page == self.bannerItems.count-1){
        page = 0;
    }
    currentPage= page;
    [self.mScrollView setContentOffset:CGPointMake(page*self.mScrollView.frame.size.width , 0) animated:YES];
    for (int i = 0; i< self.bannerItemViews.count; i++) {
        AABannerItem *banner = [self.bannerItemViews objectAtIndex:i];
        if (i == page) {
            [banner resumeVideo];
        }else{
            [banner pauseVideo];
        }
    }
    [self.pageIndicatorView setCurrentPage:currentPage];
}
@end
