//
//  AAThemeDropDownScrollItemView.m
//  AppWiz
//
//  Created by Shahid Akhtar Shaikh on 8/1/14.
//  Copyright (c) 2014 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AAThemeDropDownScrollItemView.h"

@implementation AAThemeDropDownScrollItemView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void)initValues
{
    [super initValues];
    
    [self.lblItemName setTextAlignment:NSTextAlignmentCenter];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeTheme) name:NOTIFICATION_THEME_CHANGED object:nil];
    [self updateTheme];
}

-(void)updateTheme
{
    [self setBackgroundColor:[AAColor sharedInstance].retailerThemeBackgroundColor];
    
    [self.lblItemName setTextColor :[AAColor sharedInstance].retailerThemeTextColor];
    
     self.topBorder.backgroundColor = [AAColor sharedInstance].retailerThemeDarkColor.CGColor;
    self.bottomBorder.backgroundColor = [AAColor sharedInstance].retailerThemeDarkColor.CGColor;
}

-(void)changeTheme
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateTheme];
    });
    
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_THEME_CHANGED object:nil];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
