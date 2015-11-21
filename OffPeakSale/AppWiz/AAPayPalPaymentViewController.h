//
//  AAPayPalPaymentViewController.h
//  AppWiz
//
//  Created by Shahid Akhtar Shaikh on 6/1/14.
//  Copyright (c) 2014 Shahid Akhtar Shaikh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AAPayPalPaymentViewControllerDelegate.h"
#import "AAThemeGlossyButton.h"
@interface AAPayPalPaymentViewController : UIViewController <UIWebViewDelegate>
@property (nonatomic,strong) NSURL* urlPayPalProduct;
@property (nonatomic,strong) NSString* paypalSuccessURLString;
@property (nonatomic,strong) NSString* paypalFailureURLString;
@property (nonatomic,strong) NSString* veritRedirectUrl;
@property (weak, nonatomic) IBOutlet UIWebView *wvPayPal;
@property (strong, nonatomic) IBOutlet UIView *vwCancelView;
@property (strong, nonatomic) IBOutlet AAThemeGlossyButton *btnCancle;
- (IBAction)btnCancleTapped:(id)sender;
@property (nonatomic,weak) id<AAPayPalPaymentViewControllerDelegate> paypalPaymentDelegate;
@end
