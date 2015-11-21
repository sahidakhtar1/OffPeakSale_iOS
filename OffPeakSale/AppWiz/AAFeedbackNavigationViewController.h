//
//  AAFeedbackNavigationViewController.h
//  AppWiz
//
//  Created by Shahid Akhtar Shaikh on 2/1/14.
//  Copyright (c) 2014 Shahid Akhtar Shaikh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AAChildBaseViewController.h"
#import "AAChildNavigationControllerDelegate.h"
@interface AAFeedbackNavigationViewController : UINavigationController <AAChildBaseViewControllerProtocol>
@property (nonatomic,weak) id<AAChildNavigationControllerDelegate> childNavigationControllerDelegate;
-(void)showBackButtonView;
-(void)hideBackButtonView;
@end
