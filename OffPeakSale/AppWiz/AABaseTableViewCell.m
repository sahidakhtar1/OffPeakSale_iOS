//
//  AABaseTableViewCell.m
//  AppWiz
//
//  Created by Shahid Akhtar Shaikh on 30/12/13.
//  Copyright (c) 2013 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AABaseTableViewCell.h"

@implementation AABaseTableViewCell
static NSInteger const MAIN_VIEW_PADDING = 15.0;




- (void)setUpCell
{
    // Initialization code
    self.viewMainContent = [[UIView alloc] initWithFrame:CGRectMake(MAIN_VIEW_PADDING, 0, self.contentView.frame.size.width - MAIN_VIEW_PADDING*2, self.contentView.frame.size.height - MAIN_VIEW_PADDING)];
    [self.viewMainContent setBackgroundColor:[[AAColor sharedInstance] eShopCardBackgroundColor]];
//    self.viewMainContent.layer.masksToBounds = NO;
//    [self.viewMainContent.layer setShadowColor:[UIColor blackColor].CGColor];
//    [self.viewMainContent.layer setShadowOffset:CGSizeMake(0, 5) ];
//    [self.viewMainContent.layer setShadowOpacity:0.8];
//    [self.viewMainContent.layer setShadowRadius:5.0];
//    [self.viewMainContent.layer setMasksToBounds:NO];
    self.viewMainContent.layer.borderColor = BOARDER_COLOR.CGColor;
    self.viewMainContent.layer.borderWidth = 1.0f;
    [self.viewMainContent setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth ];
    [self.contentView addSubview:self.viewMainContent];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView.superview setClipsToBounds:NO];
        [self setUpCell];

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
