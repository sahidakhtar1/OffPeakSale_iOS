//
//  AAHowItWorksView.h
//  AppWiz
//
//  Created by Shahid Akhtar Shaikh on 5/6/15.
//  Copyright (c) 2015 Shahid Akhtar Shaikh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AAThemeView.h"
@interface AAHowItWorksView : UIView
@property (weak, nonatomic) IBOutlet UILabel *lblHowItWorksHeading;
@property (weak, nonatomic) IBOutlet UILabel *lblHowItWorksDetail;
@property (weak, nonatomic) IBOutlet UIScrollView *mScrollView;
@property (weak, nonatomic) IBOutlet AAThemeView *vwUnderLine;
-(void)setHowItWorks:(NSString*)text;
@end
