//
//  AAValidationTextViewDelegate.h
//  Swensens
//
//  Created by Shahid Akhtar Shaikh on 23/12/13.
//  Copyright (c) 2013 Shahid Akhtar Shaikh. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AAValidationTextViewDelegate <NSObject>
-(void)validationTextViewDidBeginEditing:(UITextView*)validationTextView;
-(BOOL)validationTextViewShouldBeginEditing:(UITextView *)validationTextView;
-(void)validationTextViewFocus:(UITextView*)validationTextView;
@end
