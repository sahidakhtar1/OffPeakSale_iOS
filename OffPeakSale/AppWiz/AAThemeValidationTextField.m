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

-(void)updateTheme
{
    [self setTextColor:[AAColor sharedInstance].profileTextFieldTextColor];
    self.layer.borderColor = [AAColor sharedInstance].retailerThemeDarkColor.CGColor;
    self.layer.borderWidth = 1.0f;
    self.layer.cornerRadius = 4.0f;
    self.layer.backgroundColor = [UIColor clearColor].CGColor;
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
