//
//  AAMenuDropDownScrollView.m
//  AppWiz
//
//  Created by Shahid Akhtar Shaikh on 8/1/14.
//  Copyright (c) 2014 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AAMenuDropDownScrollView.h"

@implementation AAMenuDropDownScrollView
NSString* const MENU_PROFILE = @"PROFILE";
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
    self.items = [[NSMutableArray alloc] initWithObjects:@"PROFILE", nil];
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
