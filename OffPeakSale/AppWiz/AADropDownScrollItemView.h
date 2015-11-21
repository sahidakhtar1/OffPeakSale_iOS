//
//  AADropDownScrollItemView.h
//  Swensens
//
//  Created by Shahid Akhtar Shaikh on 19/12/13.
//  Copyright (c) 2013 Shahid Akhtar Shaikh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AADropDownScrollItemView : UIView
@property (nonatomic,strong) CALayer *bottomBorder;
@property (nonatomic,strong) CALayer *topBorder;
@property (nonatomic,strong) UILabel* lblItemName;
@property (nonatomic,strong) UIColor* bottomBorderColor;
@property (nonatomic,strong) UIColor* topBorderColor;
//Optionally add bottom border to view
-(void)addBottomBorder;
//Optionally add top border to view
-(void)addTopBorder;
//Initially which can be optionally overidden in subclass. Super implmentation must be called.
-(void)initValues __attribute__((objc_requires_super));
@end
