//
//  AABasePopupView.m
//  Swensens
//
//  Created by Shahid Akhtar Shaikh on 20/12/13.
//  Copyright (c) 2013 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AABasePopupView.h"
#import "AAThemeView.h"
@implementation AABasePopupView

- (id)initWithBackgroundFrame:(CGRect)backgroundFrame andContentFrame:(CGRect)contentFrame
{
    self = [self initWithFrame:backgroundFrame];
    if (self)
    {
        // Initialization code
        self.backgroundView = [[UIView alloc]initWithFrame:backgroundFrame];
        [self.backgroundView setBackgroundColor:[UIColor blackColor]];
        [self.backgroundView setAlpha:0.5];
        [self addSubview:self.backgroundView];
        
        UITapGestureRecognizer *backgroundTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closePopup)];
        [self.backgroundView addGestureRecognizer:backgroundTapGestureRecognizer];
        
        // set to a default size
        self.contentView = [[UIView alloc] initWithFrame:contentFrame];
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.contentView.layer.cornerRadius = 3.0;
        self.contentView.layer.shadowOffset = CGSizeMake(0,3) ;
        self.contentView.layer.shadowColor = [UIColor blackColor].CGColor;
        self.contentView.layer.shadowOpacity = 0.9;
        self.contentView.layer.shadowRadius = 4.0;
        [self.contentView.layer setMasksToBounds:NO];
        [self addSubview:self.contentView];
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

-(void)addHeaderView
{
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, self.headerHeight)];
    CGRect frame = self.headerView.frame;
    frame.origin.x -= 0;
    frame.origin.y -= 0;
    frame.size.width +=0;
    frame.size.height += 0;
    AAThemeView *btn = [[AAThemeView alloc] initWithFrame:frame];
    [self.headerView addSubview:btn];
    
   self.lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.headerView.frame.size.width, self.headerHeight)];
    [self.lblTitle setTextColor:self.headerTitleColor];
    [self.lblTitle setText:self.headerTitle];
    [self.lblTitle setTextAlignment:NSTextAlignmentCenter];
    [self.lblTitle setFont:self.headerFont];
    [self.lblTitle setBackgroundColor:[UIColor clearColor]];
    [ self.headerView addSubview:self.lblTitle];
    [ self.headerView setBackgroundColor:self.headerColor];
    [self.contentView addSubview: self.headerView];
}


-(void)centreContentViewInSuperview
{
    self.contentView.center = self.contentView.superview.center;
}

-(void)closePopup
{
    [self.delegate popupViewClosed:self];
    [self removeFromSuperview];
}


@end
