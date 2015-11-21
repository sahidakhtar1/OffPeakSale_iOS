//
//  AAFilterDropDownScrollView.h
//  AppWiz
//
//  Created by Shahid Akhtar Shaikh on 13/1/14.
//  Copyright (c) 2014 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AADropDownScrollView.h"

@interface AAFilterDropDownScrollView : AADropDownScrollView <UITextFieldDelegate>
@property (nonatomic,strong) UITextField* hiddenTexfield;
@end
