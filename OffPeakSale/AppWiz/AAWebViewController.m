//
//  AAWebViewController.m
//  AppWiz
//
//  Created by Shaikh Shahid Akhtar on 13/08/14.
//  Copyright (c) 2014 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AAWebViewController.h"
#import "AAAppGlobals.h"
@interface AAWebViewController ()

@end

@implementation AAWebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.lblContainerTitle.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].boldFont size:TITLE_FONTSIZE];
	// Do any additional setup after loading the view.
    NSString *url = [AAAppGlobals sharedInstance].termsConditions;
    if (self.intagramURL !=  nil) {
        url = self.intagramURL;
        [self.btnCancle setTitle:@"Cancle" forState:UIControlStateNormal];
    }
//    url = @"https://vtweb.sandbox.veritrans.co.id/v2/vtweb/8c700662-3358-4c09-81f6-25e6e2060818";
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [self.wvPayPal loadRequest:request];
    self.btnCancle.titleLabel.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].boldFont size:BUTTON_FONTSIZE];
    
    if ([[AAAppGlobals sharedInstance].retailer.appIconColor isEqualToString:@"White"]) {
        [self.btnBack setImage:[UIImage imageNamed:@"back_button"] forState:UIControlStateNormal];
        [self.btnNext setImage:[UIImage imageNamed:@"next"] forState:UIControlStateNormal];
        [self.btnClosePage setImage:[UIImage imageNamed:@"back_button"] forState:UIControlStateNormal];
    }else{
        [self.btnClosePage setImage:[UIImage imageNamed:@"back_button_black"] forState:UIControlStateNormal];
        [self.btnBack setImage:[UIImage imageNamed:@"eshop_back"] forState:UIControlStateNormal];
        [self.btnNext setImage:[UIImage imageNamed:@"esho_categories"] forState:UIControlStateNormal];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnBacktapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)goForward:(id)sender {
    if ([self.wvPayPal canGoForward]) {
        [self.wvPayPal goForward];
    }
}

- (IBAction)goBack:(id)sender {
    if ([self.wvPayPal canGoBack]) {
        [self.wvPayPal goBack];
    }

}

#pragma mark -
#pragma mark WebViewDelegate
-(void)webViewDidStartLoad:(UIWebView *)webView{
    
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    
    [self.btnBack setEnabled:[webView canGoBack]];
    [self.btnNext setEnabled:[webView canGoForward]];
    
}
@end
