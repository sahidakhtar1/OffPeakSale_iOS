//
//  AAValidationTextField.m
//  Swensens
//
//  Created by Shahid Akhtar Shaikh on 19/12/13.
//  Copyright (c) 2013 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AAValidationTextField.h"

@implementation AAValidationTextField
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initValues];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
    [self initValues];
    }
    return self;
}


-(void)initValues
{
    self.delegate = self;
    self.allowOnlyNumbers = NO;
    self.maxNumberOfCharacters = 200;
    self.isMandatory = YES;
    self.text = @"";
    
    [self addTarget:self action:@selector(onTextFieldFocussed:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    BOOL shouldAllowText = YES;
    if(self.allowOnlyNumbers)
    {
    NSCharacterSet *nonNumberSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    shouldAllowText = ([string stringByTrimmingCharactersInSet:nonNumberSet].length > 0)|| [string isEqualToString:@""];
        if(!shouldAllowText)
            return shouldAllowText;
    }
   
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        shouldAllowText = (newLength > self.maxNumberOfCharacters) ? NO : YES;
        
    return shouldAllowText;
}


-(NSDictionary *)isValid
{
    NSMutableDictionary* dictValidity = [[NSMutableDictionary alloc] init];
     [dictValidity setObject:[NSNumber numberWithBool:YES] forKey:IS_VALID_KEY];
    if(self.isMandatory)
    {
        if([self.text isEqualToString:@""])
        {
            [dictValidity setObject:[NSNumber numberWithBool:NO] forKey:IS_VALID_KEY];
            [dictValidity setObject:[NSString stringWithFormat:@"%@ %@",self.placeholder,MANDATORY_MESSAGE] forKey:ERROR_MESSAGE_KEY];
        }
    }
    return dictValidity;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(self.validationDelegate)
    {
        if([self.validationDelegate respondsToSelector:@selector(validationTextFieldDidBeginEditing:)])
        {
            [self.validationDelegate validationTextFieldDidBeginEditing:textField];
        }
    }
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if(self.validationDelegate)
    {
        if([self.validationDelegate respondsToSelector:@selector(validationTextFieldShouldBeginEditing:)])
        {
          return  [self.validationDelegate validationTextFieldShouldBeginEditing:textField];
        }
    }
    return YES;
}

-(void)onTextFieldFocussed : (id)sender
{
    if(self.validationDelegate)
    {
        if([self.validationDelegate respondsToSelector:@selector(validationTextFieldFocus:)])
        {
            return  [self.validationDelegate validationTextFieldFocus:self];
        }
    }
   
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
