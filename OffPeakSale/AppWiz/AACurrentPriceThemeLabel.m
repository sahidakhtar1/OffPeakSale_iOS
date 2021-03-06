//
//  AACurrentPriceThemeLabel.m
//  AppWiz
//
//  Created by Shahid Akhtar Shaikh on 30/12/13.
//  Copyright (c) 2013 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AACurrentPriceThemeLabel.h"

@implementation AACurrentPriceThemeLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}



-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        [self initValues];
    }
    
    return self;
}

-(void)initValues
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeTheme) name:NOTIFICATION_THEME_CHANGED object:nil];
    [self updateTheme];
    
}

-(void)updateTheme
{
    [self setTextColor:[AAColor sharedInstance].retailerThemeBackgroundColor];
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
