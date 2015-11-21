//
//  AABannerView.h
//  AppWiz
//
//  Created by Shaikh Shahid Akhtar on 27/11/14.
//  Copyright (c) 2014 Shahid Akhtar Shaikh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AABannerItem.h"
@interface AABannerView : UIView<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *mScrollView;

@property (nonatomic, strong) NSArray *bannerItems;
@property (nonatomic, strong) NSMutableArray *bannerItemViews;
@property (weak, nonatomic) IBOutlet UIPageControl *pageIndicatorView;
@property (nonatomic, strong) NSTimer *mTimer;
@property NSInteger currentPage;
@property (nonatomic, unsafe_unretained) id <ProductImageZoomeDelegate> delegate;
-(void) populateItems;
-(void)startTimer;
-(void)stopTime;
@end
