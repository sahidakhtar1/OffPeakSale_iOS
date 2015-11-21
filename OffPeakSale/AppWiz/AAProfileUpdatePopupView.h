//
//  AAProfileUpdatePopupView.h
//  AppWiz
//
//  Created by Shahid Akhtar Shaikh on 31/12/13.
//  Copyright (c) 2013 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AAThemePopupView.h"
#import "AAProfileUpdatePopupViewDelegate.h"
@interface AAProfileUpdatePopupView : AAThemePopupView
@property (nonatomic,strong) NSString* text;
@property (nonatomic,weak) id<AAProfileUpdatePopupViewDelegate> profilePopupViewDelegate;
//Creates and returns the profile update popupview given the background frame of the popup view
+(AAProfileUpdatePopupView*)createProfileUpdatePopupViewWithBackgroundFrameRect : (CGRect)backgroundFrameRect;
@end
