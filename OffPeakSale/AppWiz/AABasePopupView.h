//
//  AABasePopupView.h
//  Swensens
//
//  Created by Shahid Akhtar Shaikh on 20/12/13.
//  Copyright (c) 2013 Shahid Akhtar Shaikh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AABasePopupViewDelegate.h"
@interface AABasePopupView : UIView
@property (nonatomic,weak) id<AABasePopupViewDelegate> delegate;

@property (nonatomic,strong) UIView* contentView;
@property (nonatomic,strong) UIView* backgroundView;
@property (nonatomic) NSInteger headerHeight;
@property (nonatomic,strong) NSString* headerTitle;
@property (nonatomic,strong)
    UIColor* headerColor;
@property (nonatomic,strong)  UILabel* lblTitle;
@property (nonatomic,strong) UIFont* headerFont;
@property (nonatomic,strong) UIColor* headerTitleColor;
@property (nonatomic,strong) UIView* headerView;


-(void)closePopup;

//Creates the background view and content view given their respective frames. To be called first from subclass initializer.
- (id)initWithBackgroundFrame:(CGRect)backgroundFrame andContentFrame:(CGRect)contentFrame
;

//Convenience method to use in sublass to centre the content view in the background frame
-(void)centreContentViewInSuperview;

//Convenience method to use in subclass to add a header view to the content view.
-(void)addHeaderView;
@end
