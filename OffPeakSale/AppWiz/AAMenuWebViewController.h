//
//  AAMenuWebViewController.h
//  AppWiz
//
//  Created by Shahid Akhtar Shaikh on 5/3/15.
//  Copyright (c) 2015 Shahid Akhtar Shaikh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AAThemeLabel.h"
@interface AAMenuWebViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic,strong) NSString *webPageUrl;
@property (nonatomic,strong) NSString *webPageTitle;

- (IBAction)btnMenuTapped:(id)sender;
- (IBAction)btnBackTapped:(id)sender;
- (IBAction)btnNextTapped:(id)sender;
@property (weak, nonatomic) IBOutlet AAThemeLabel *lblTitle;

@property (weak, nonatomic) IBOutlet UIButton *btnMenu;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet UIButton *btnNext;
-(void)setPageTitle:(NSString*)title;


@end
