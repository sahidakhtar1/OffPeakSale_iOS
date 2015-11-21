//
//  AAValidationTextView.h
//  Swensens
//
//  Created by Shahid Akhtar Shaikh on 23/12/13.
//  Copyright (c) 2013 Shahid Akhtar Shaikh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AAValidationTextViewDelegate.h"
#import "AAValidationProtocol.h"
#import "AAValidationConstants.h"
@interface AAValidationTextView : UITextView <UITextViewDelegate>

@property (nonatomic,strong) NSString* placeHolderText;
@property (nonatomic,strong) UIColor* placeHolderTextColor;
@property (nonatomic,strong) UIColor* defaultTextColor;
@property (nonatomic,strong) NSString* fieldName;
@property (nonatomic) BOOL allowOnlyNumbers;
@property (nonatomic) NSInteger maxNumberOfCharacters;
@property (nonatomic) NSInteger minNumberOfCharacters;
@property (nonatomic) BOOL isMandatory;
@property (nonatomic,weak) id<AAValidationTextViewDelegate> validationDelegate;
@property (nonatomic,strong) UILabel* lblPlaceholderTextView;
@property (nonatomic) IBInspectable NSInteger maxLimit;
-(void)initValues;
-(NSDictionary*)isValid;
@end
