//
//  AAThemePopupView.m
//  AppWiz
//
//  Created by Shahid Akhtar Shaikh on 31/12/13.
//  Copyright (c) 2013 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AAThemePopupView.h"

@implementation AAThemePopupView
static NSInteger const BUTTON_WIDTH = 100;
static NSInteger const BUTTON_HEIGHT = 40;
NSInteger const BUTTON_PADDING = 10;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeTheme) name:NOTIFICATION_THEME_CHANGED object:nil];
        self.headerColor = [AAColor sharedInstance].retailerThemeBackgroundColor;
        self.headerTitleColor = [AAColor sharedInstance].retailerThemeTextColor;
        self.headerFont = [AAFont defaultBoldFontWithSize:16.0];
        self.headerHeight = 40;
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
-(CGFloat)addDismissButton:(CGFloat)currentY
{
    
    CGFloat xCoord = ceilf(self.contentView.frame.size.width - BUTTON_WIDTH)/2;
  self.btnDismissPopup = [[AAThemeGlossyButton alloc] initWithFrame:CGRectMake(xCoord, currentY, BUTTON_WIDTH, BUTTON_HEIGHT)];
    
    [self.btnDismissPopup setTitle:@"Dismiss" forState:UIControlStateNormal];
    [self.btnDismissPopup.titleLabel setFont:[AAFont defaultBoldFontWithSize:14.0]];
    
    [self.btnDismissPopup addTarget:self action:@selector(btnDismissTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.btnDismissPopup];
    
    currentY = currentY + BUTTON_HEIGHT + 3;
    return currentY;
}
-(void)btnDismissTapped
{
    [self closePopup];
}
-(void)changeTheme
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateTheme];
    });
    
}
-(void)updateTheme
{
    self.lblTitle.textColor = [AAColor sharedInstance].retailerThemeTextColor;
    self.headerView.backgroundColor = [AAColor sharedInstance].retailerThemeBackgroundColor;
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_THEME_CHANGED object:nil];
}
@end
