//
//  AAProfileUpdatePopupView.m
//  AppWiz
//
//  Created by Shahid Akhtar Shaikh on 31/12/13.
//  Copyright (c) 2013 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AAProfileUpdatePopupView.h"

@implementation AAProfileUpdatePopupView
static NSInteger const PADDING = 10;
static NSString* const PROFILE_UPDATE_TEXT = @"Please fill in your Personal Details on the\nProfile Page\n\nTHANK YOU";
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


+(AAProfileUpdatePopupView*)createProfileUpdatePopupViewWithBackgroundFrameRect : (CGRect)backgroundFrameRect
{
    AAProfileUpdatePopupView* profileUpdatePopupView = [[AAProfileUpdatePopupView alloc] initWithBackgroundFrame:backgroundFrameRect andContentFrame:CGRectMake(0, 0, backgroundFrameRect.size.width- 2*MARGIN, backgroundFrameRect.size.height)];
    
    [profileUpdatePopupView.contentView setBackgroundColor:[UIColor whiteColor]];
    [profileUpdatePopupView.backgroundView setBackgroundColor:[UIColor whiteColor]];
    [profileUpdatePopupView.backgroundView setAlpha:0.8];
    [profileUpdatePopupView setHeaderTitle:@"PROFILE UPDATE"];
   
    [profileUpdatePopupView addHeaderView];
   
    CGFloat currentY = profileUpdatePopupView.headerHeight + PADDING;
    
    
    currentY = [profileUpdatePopupView addMessage:currentY];
      
    currentY = [profileUpdatePopupView addDismissButton:currentY];
     [profileUpdatePopupView.btnDismissPopup setTitle:@"Profile" forState:UIControlStateNormal];
    
    
    
    CGRect contentViewframe = profileUpdatePopupView.contentView.frame;
    contentViewframe.size.height = currentY;
    profileUpdatePopupView.contentView.frame = contentViewframe;
    [profileUpdatePopupView centreContentViewInSuperview];
    return profileUpdatePopupView;
}

-(CGFloat)addMessage : (CGFloat)currentY
{
    
    CGSize lblSize = [AAUtils getTextSizeWithFont:[AAFont defaultBoldFontWithSize:12.0] andText:PROFILE_UPDATE_TEXT andMaxWidth:self.contentView.frame.size.width-2*PADDING];
    
    UILabel* lblMessage = [[UILabel alloc] initWithFrame:CGRectMake(PADDING, currentY , self.contentView.frame.size.width-2*PADDING, lblSize.height)];
    [lblMessage setNumberOfLines:0];
    [lblMessage setTextAlignment:NSTextAlignmentCenter];
    [lblMessage setFont:[AAFont defaultBoldFontWithSize:12.0]];
   [lblMessage setText:PROFILE_UPDATE_TEXT];
    
    [self.contentView addSubview:lblMessage];
    currentY = currentY + PADDING + lblSize.height;
    return currentY;
}

-(void)btnDismissTapped
{
    
    [super btnDismissTapped];
    [self.profilePopupViewDelegate showProfileUpdateScreen];
}
@end
