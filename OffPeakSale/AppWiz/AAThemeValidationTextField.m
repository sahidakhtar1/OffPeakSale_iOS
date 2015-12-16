//
//  AAProfileValidationTextField.m
//  Swensens
//
//  Created by Shahid Akhtar Shaikh on 19/12/13.
//  Copyright (c) 2013 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AAThemeValidationTextField.h"

@implementation AAThemeValidationTextField

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
    [super initValues];
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeTheme) name:NOTIFICATION_THEME_CHANGED object:nil];
    [self updateTheme];
    [self setAutocorrectionType:UITextAutocorrectionTypeNo];
   
}

-(void)setNoPadding:(BOOL)noPadding{
    _noPadding = noPadding;
    if (noPadding) {
        self.leftViewMode = UITextFieldViewModeNever;
    }else{
        self.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 10)];
        self.leftViewMode = UITextFieldViewModeAlways;
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
-(void)changeTheme
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateTheme];
    });
}
-(void)setUseLightBoarder:(BOOL)useLightBoarder{
    _useLightBoarder = useLightBoarder;
    [self updateTheme];
}
-(void)setNoBoarder:(BOOL)noBoarder{
    _noBoarder = noBoarder;
    [self updateTheme];
}
-(void)updateTheme
{
    self.layer.borderWidth = 1.0f;
    self.layer.cornerRadius = 4.0f;
    [self setTextColor:[AAColor sharedInstance].profileTextFieldTextColor];
    if (self.useLightBoarder) {
        self.layer.borderColor = [AAColor sharedInstance].textFieldDefaultBorader.CGColor;
        self.layer.backgroundColor = [UIColor whiteColor].CGColor;
    }else if (self.noBoarder) {
        self.layer.borderWidth = 0.0f;
        self.layer.borderColor =/*[UIColor clearColor].CGColor;*/
        [UIColor colorWithRed:229/255.0 green:231/255.0 blue:226/255.0 alpha:1].CGColor;
        self.borderStyle = UITextBorderStyleNone;
        self.layer.backgroundColor = [UIColor whiteColor].CGColor;
    }
    else{
        self.layer.borderColor = [AAColor sharedInstance].retailerThemeDarkColor.CGColor;
        self.layer.backgroundColor = [UIColor clearColor].CGColor;
    }
    
    if (self.noPadding) {
        self.leftViewMode = UITextFieldViewModeNever;
    }else{
        self.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 10)];
        self.leftViewMode = UITextFieldViewModeAlways;
    }
    
//    self.
//    self.layer.borderColor = [UIColor greenColor].CGColor;
    
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_THEME_CHANGED object:nil];
}
-(void)setLightTextColor:(BOOL)lightTextColor{
    [self setTextColor:[AAColor sharedInstance].retailerThemeTextColor];
    [self setValue:[UIColor colorWithWhite:1 alpha:0.5f]
        forKeyPath:@"_placeholderLabel.textColor"];
}

@end
