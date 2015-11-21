//
//  AAValidationTextField.h
//  Swensens
//
//  Created by Shahid Akhtar Shaikh on 19/12/13.
//  Copyright (c) 2013 Shahid Akhtar Shaikh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AAValidationTextFieldDelegate.h"
#import "AAValidationProtocol.h"
#import "AAValidationConstants.h"
@interface AAValidationTextField : UITextField <UITextFieldDelegate>
@property (nonatomic) BOOL allowOnlyNumbers;
@property (nonatomic) NSInteger maxNumberOfCharacters;
@property (nonatomic) NSInteger minNumberOfCharacters;
@property (nonatomic) BOOL isMandatory;
@property (nonatomic,weak) id<AAValidationTextFieldDelegate> validationDelegate;

-(void)initValues __attribute__((objc_requires_super));
//Validates the text field based on the properties and returns a dictionary which indicates success or failure and an error message
-(NSDictionary*)isValid;
@end
