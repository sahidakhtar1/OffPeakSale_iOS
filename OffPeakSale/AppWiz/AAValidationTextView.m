//
//  AAValidationTextView.m
//  Swensens
//
//  Created by Shahid Akhtar Shaikh on 23/12/13.
//  Copyright (c) 2013 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AAValidationTextView.h"

@implementation AAValidationTextView

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
    if (self) {
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
    [self.layer setCornerRadius:3.0];
    [self.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [self.layer setBorderWidth:1.0];
    self.placeHolderText = @"";
    self.placeHolderTextColor = [UIColor lightGrayColor];
    self.textColor = self.placeHolderTextColor;
    self.text = @"";
    
  
    [self addPlaceholderLabel];
   // [self addTarget:self action:@selector(onTextViewFocussed:) forControlEvents:UIControlEventTouchUpInside];
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(NSDictionary *)isValid
{
    NSMutableDictionary* dictValidity = [[NSMutableDictionary alloc] init];
    [dictValidity setObject:[NSNumber numberWithBool:YES] forKey:IS_VALID_KEY];
    if(self.isMandatory)
    {
        if([self.text isEqualToString:@""])
        {
            [dictValidity setObject:[NSNumber numberWithBool:NO] forKey:IS_VALID_KEY];
            [dictValidity setObject:[NSString stringWithFormat:@"%@ %@",self.fieldName,MANDATORY_MESSAGE] forKey:ERROR_MESSAGE_KEY];
        }
    }
    return dictValidity;
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    [self.lblPlaceholderTextView setHidden:YES];
   
    if(self.validationDelegate)
    {
        if([self.validationDelegate respondsToSelector:@selector(validationTextViewDidBeginEditing:)])
        {
            [self.validationDelegate validationTextViewDidBeginEditing:textView];
        }
    }
   
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (self.maxLimit==0) {
        return true;
    }
    if (text.length==0) {
        return true;
    }
    if (textView.text.length<=self.maxLimit) {
        return true;
    }
    return false;
}
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if(self.validationDelegate)
    {
        
        if([self.validationDelegate respondsToSelector:@selector(validationTextViewShouldBeginEditing:)])
        {
            return  [self.validationDelegate validationTextViewShouldBeginEditing:textView];
        }
    }
    return YES;
}

-(void)textViewDidChange:(UITextView *)textView
{
    [self.lblPlaceholderTextView setHidden:([self.text length] > 0)];
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView
{
  [self.lblPlaceholderTextView setHidden:([self.text length] > 0)];
  
    return YES;
}
/*-(void)onTextViewFocussed : (id)sender
{
    if(self.validationDelegate)
    {
        if([self.validationDelegate respondsToSelector:@selector(validationTextFieldFocus:)])
        {
            return  [self.validationDelegate validationTextFieldFocus:self];
        }
    }
    
}
*/

-(void)setPlaceHolderText:(NSString *)placeHolderText
{
    _placeHolderText = placeHolderText;
    [self.lblPlaceholderTextView setText:self.placeHolderText];
}

-(void)setText:(NSString *)text
{
    [super setText:text];
   [self.lblPlaceholderTextView setHidden:([self.text length] > 0)];
}
-(void)addPlaceholderLabel
{
    CGSize lblSize = [AAUtils getTextSizeWithFont:self.font andText:@"Test" andMaxWidth:self.frame.size.width];
    self.lblPlaceholderTextView = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, self.frame.size.width, lblSize.height)];
    [self.lblPlaceholderTextView setFont:self.font];
  
     [self.lblPlaceholderTextView setUserInteractionEnabled:NO];
    [self.lblPlaceholderTextView setBackgroundColor:[UIColor clearColor]];
    [self.lblPlaceholderTextView setTextColor:self.placeHolderTextColor];
    [self addSubview:self.lblPlaceholderTextView];
    
}
@end
