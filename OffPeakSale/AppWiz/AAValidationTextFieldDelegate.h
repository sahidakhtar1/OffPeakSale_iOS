//
//  AAValidationTextFieldDelegate.h
//  Swensens
//
//  Created by Shahid Akhtar Shaikh on 19/12/13.
//  Copyright (c) 2013 Shahid Akhtar Shaikh. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AAValidationTextFieldDelegate <NSObject>
-(void)validationTextFieldDidBeginEditing:(UITextField*)validatoinTextField;
-(BOOL)validationTextFieldShouldBeginEditing:(UITextField *)validatoinTextField;
-(void)validationTextFieldFocus:(UITextField*)validatoinTextField;

@end
