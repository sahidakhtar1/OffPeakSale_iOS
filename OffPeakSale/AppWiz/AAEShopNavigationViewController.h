//
//  AAEShopNavigationViewController.h
//  Swensens
//
//  Created by Shahid Akhtar Shaikh on 15/12/13.
//  Copyright (c) 2013 Shahid Akhtar Shaikh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AAChildBaseViewController.h"
#import "AAChildNavigationControllerDelegate.h"
@interface AAEShopNavigationViewController : UINavigationController <AAChildBaseViewControllerProtocol>
@property (nonatomic,weak) id<AAChildNavigationControllerDelegate> childNavigationControllerDelegate;

-(void)showBackButtonView;
@end
