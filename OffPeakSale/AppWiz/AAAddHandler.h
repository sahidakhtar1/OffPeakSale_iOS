//
//  AAAddHelper.h
//  AppWiz
//
//  Created by Shahid Akhtar Shaikh on 17/1/14.
//  Copyright (c) 2014 Shahid Akhtar Shaikh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AAAddHandlerDelegate.h"
#import "GADBannerView.h"

@interface AAAddHandler : NSObject <GADBannerViewDelegate>

@property (nonatomic,weak) UIViewController<AAAddHandlerDelegate>* delegate;
@property (nonatomic,strong) GADBannerView* bannerView;
@property (nonatomic,copy) NSString* publisherId;
@property (nonatomic) CGFloat bannerHeight;
@property (nonatomic,strong) UIView* containerView;
@property (nonatomic) BOOL bannerAdded;
//Creates and adds the ad banner to the bottom of the containerView.
-(void)addAdBannerWithContainerView : (UIView*)containerView;

- (id)initWithPublisherId:(NSString*)publisherId;
@end
