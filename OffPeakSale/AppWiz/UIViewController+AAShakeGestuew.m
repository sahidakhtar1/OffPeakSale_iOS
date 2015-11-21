//
//  UIViewController+AAShakeGestuew.m
//  AppWiz
//
//  Created by Shahid Akhtar Shaikh on 5/13/15.
//  Copyright (c) 2015 Shahid Akhtar Shaikh. All rights reserved.
//

#import "UIViewController+AAShakeGestuew.h"
#import "AAAppDelegate.h"
@implementation UIViewController (AAShakeGestuew)

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if ( event.subtype == UIEventSubtypeMotionShake )
    {
        // Put in code here to handle shake
        NSLog(@"Device shaked");
        AAAppDelegate *appDelegate = (AAAppDelegate*)[UIApplication sharedApplication].delegate;
        [appDelegate showVoucher];
    }
    
    if ( [super respondsToSelector:@selector(motionEnded:withEvent:)] )
        [super motionEnded:motion withEvent:event];
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}
-(void)cat_viewDidAppear:(BOOL)animated{
    [self becomeFirstResponder];
}
-(void)cat_viewDidDisappear:(BOOL)animated{
    
}
@end
