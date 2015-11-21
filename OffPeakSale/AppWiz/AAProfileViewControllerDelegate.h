//
//  AAProfileViewControllerDelegate.h
//  Swensens
//
//  Created by Shahid Akhtar Shaikh on 20/12/13.
//  Copyright (c) 2013 Shahid Akhtar Shaikh. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AAProfileViewControllerDelegate <NSObject>
@optional
-(void)closeProfileViewController : (id)viewController;
-(void)onPaymentSucceeded:(NSDictionary*)response;

@end
