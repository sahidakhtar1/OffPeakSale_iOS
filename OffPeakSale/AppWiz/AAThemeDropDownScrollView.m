//
//  AAThemeDropDownScrollView.m
//  AppWiz
//
//  Created by Shahid Akhtar Shaikh on 8/1/14.
//  Copyright (c) 2014 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AAThemeDropDownScrollView.h"

@implementation AAThemeDropDownScrollView

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
    self.showTopBorder = YES;
    self.showBottomBorder = NO;
    self.itemBackgroundColor = [AAColor sharedInstance].retailerThemeBackgroundColor;
    self.itemLabelTextColor = [AAColor sharedInstance].retailerThemeTextColor;
    self.itemBorderColor = [AAColor sharedInstance].retailerThemeDarkColor;
    self.itemLabelFont = [AAFont defaultBoldFontWithSize:14.0];
    self.dropDownMenuClass = [AAThemeDropDownScrollItemView class];
   
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
