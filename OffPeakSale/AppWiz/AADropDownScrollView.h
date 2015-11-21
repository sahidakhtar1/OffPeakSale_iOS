//
//  AADropDownScrollView.h
//  Swensens
//
//  Created by Shahid Akhtar Shaikh on 19/12/13.
//  Copyright (c) 2013 Shahid Akhtar Shaikh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AADropDownScrollView.h"
#import "AADropDownScrollItemView.h"
#import "AADropDownScrollViewDelegate.h"
@interface AADropDownScrollView : UIScrollView
@property (nonatomic,strong) NSMutableArray* items;
@property (nonatomic,strong) NSMutableArray* itemViews;
@property (nonatomic) Class dropDownMenuClass;
@property (nonatomic) NSInteger itemHeight;
@property (nonatomic,weak) id<AADropDownScrollViewDelegate> dropDownDelegate;
@property (nonatomic,strong) UIColor* itemBackgroundColor;
@property (nonatomic,strong) UIColor* itemBorderColor;
@property (nonatomic,strong) UIFont* itemLabelFont;
@property (nonatomic,strong) UIColor* itemLabelTextColor;
@property (nonatomic) BOOL showBottomBorder;
@property (nonatomic) BOOL showTopBorder;
@property (nonatomic) BOOL isProductOptions;
@property (nonatomic) BOOL isLeftAlign;

// Initializer that subclasses can optionally override but must call super implementation.
-(void)initValues __attribute__((objc_requires_super)) ;

//Call after adding items to the scroll view or changing properties of the scroll view to refresh content.
-(void)refreshScrollView;
-(void)refreshScrollView:(BOOL)isProductOption;
@end
