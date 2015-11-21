//
//  AAHomeNavigationViewController.h
//  Swensens
//
//  Created by Shahid Akhtar Shaikh on 15/12/13.
//  Copyright (c) 2013 Shahid Akhtar Shaikh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AAHomeNavigationViewController.h"
#import "AAChildBaseViewController.h"
#import "AAChildNavigationControllerDelegate.h"
#import "AAHomeViewController.h"
@interface AAHomeNavigationViewController : UINavigationController <AAChildBaseViewControllerProtocol>

@property (nonatomic,weak) id<AAChildNavigationControllerDelegate> childNavigationControllerDelegate;
-(void)setRootViewControllerDelegate : (id<AARootChildViewControllerDelegate>)rootViewControllerDelegate;

-(void)showBackButtonView;
@end
