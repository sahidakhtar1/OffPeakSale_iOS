//
//  AATourSlideView.m
//  AppWiz
//
//  Created by Shahid Akhtar Shaikh on 12/5/15.
//  Copyright © 2015 Shaikh Shahid Akhtar. All rights reserved.
//

#import "AATourSlideView.h"
#import "UIImageView+WebCache.h"
@implementation AATourSlideView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self = [self initialize];
        [self setUp];
        self.frame = frame;
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
- (UIView*)initialize{
    UIView *childView= [[[NSBundle mainBundle] loadNibNamed:@"TourSlideView" owner:self options:nil] objectAtIndex:0];
    
    return childView;
}
-(void)setUp{
    self.lblDecription.text = @"";
    self.lblTitle.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].boldFont size:TOUR_TITLE_FONT_SIZE];
    self.lblDecription.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:TOUR_DESC_FONT_SIZE];
    self.lblTitle.textColor = [AAColor sharedInstance].retailerThemeTextColor;
    self.lblDecription.textColor = [AAColor sharedInstance].retailerThemeTextColor;

}
-(void)setTourItem:(AATourItem *)tourItem{
    _tourItem = tourItem;
    [self populate];
}
-(void)populate{
    self.lblTitle.text = self.tourItem.headerTitle;
    self.lblDecription.text = self.tourItem.desc;
    NSURL* imageUrl = [NSURL URLWithString: self.tourItem.imageUrl];
    [self.imgBg setImageWithURL:imageUrl completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        
    }];

}
@end
