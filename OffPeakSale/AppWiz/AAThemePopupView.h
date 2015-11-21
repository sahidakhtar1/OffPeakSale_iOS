//
//  AAThemePopupView.h
//  AppWiz
//
//  Created by Shahid Akhtar Shaikh on 31/12/13.
//  Copyright (c) 2013 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AABasePopupView.h"
#import "AAThemeGlossyButton.h"
@interface AAThemePopupView : AABasePopupView
@property (nonatomic,strong)  AAThemeGlossyButton* btnDismissPopup ;

//optionally overriden by subclasses when needing to update theme. Must call super in implementation.
-(void)updateTheme __attribute__((objc_requires_super));
//Optionally add dismiss button to the popup view
-(CGFloat)addDismissButton:(CGFloat)currentY;
-(void)btnDismissTapped;
@end
