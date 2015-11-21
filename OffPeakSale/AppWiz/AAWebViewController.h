//
//  AAWebViewController.h
//  AppWiz
//
//  Created by Shaikh Shahid Akhtar on 13/08/14.
//  Copyright (c) 2014 Shahid Akhtar Shaikh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AAThemeLabel.h"
#import "AAThemeGlossyButton.h"
@interface AAWebViewController : UIViewController
@property (strong, nonatomic) IBOutlet AAThemeLabel *lblContainerTitle;
@property (weak, nonatomic) IBOutlet UIView *vwBottomView;
@property (weak, nonatomic) IBOutlet UIWebView *wvPayPal;
@property (weak, nonatomic) IBOutlet AAThemeGlossyButton *btnCancle;
@property (strong, nonatomic) NSString *intagramURL;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet UIButton *btnNext;
@property (weak, nonatomic) IBOutlet UIButton *btnClosePage;
- (IBAction)btnBacktapped:(id)sender;
- (IBAction)goForward:(id)sender;
- (IBAction)goBack:(id)sender;

@end
