//
//  AAPaymentSelectorView.h
//  Swensens
//
//  Created by Shahid Akhtar Shaikh on 18/12/13.
//  Copyright (c) 2013 Shahid Akhtar Shaikh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AAPaymentSelectorView : UIView
@property (nonatomic,strong) UIView* viewHeader;
@property (nonatomic,strong) UITextField* cardNumber;
@property (nonatomic,strong) UITextField* tfCardNumber;
@property (nonatomic,strong) UITextField* tfExpiryDate;
@property (nonatomic,strong) UIView* contentView;
@end
