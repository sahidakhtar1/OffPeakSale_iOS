//
//  AAThemeView.m
//  AppWiz
//
//  Created by Shahid Akhtar Shaikh on 29/12/13.
//  Copyright (c) 2013 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AAThemeView.h"

@implementation AAThemeView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initValues];
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

-(void)updateTheme
{
    
     [self setBackgroundColor:[AAColor sharedInstance].retailerThemeBackgroundColor];
}

-(void)initValues
{
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeTheme) name:NOTIFICATION_THEME_CHANGED object:nil];
    [self updateTheme];
   
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
@end
