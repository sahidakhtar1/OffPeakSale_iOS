//
//  AAMenuWebViewController.m
//  AppWiz
//
//  Created by Shahid Akhtar Shaikh on 5/3/15.
//  Copyright (c) 2015 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AAMenuWebViewController.h"
#import "AAAppDelegate.h"
#import "UIViewController+AAShakeGestuew.h"
@interface AAMenuWebViewController ()

@end

@implementation AAMenuWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.lblTitle.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].boldFont size:TITLE_FONTSIZE];
    [self reloadWebView];
    if ([[AAAppGlobals sharedInstance].retailer.appIconColor isEqualToString:@"White"]) {
        [self.btnBack setImage:[UIImage imageNamed:@"back_button"] forState:UIControlStateNormal];
        [self.btnNext setImage:[UIImage imageNamed:@"next"] forState:UIControlStateNormal];
        [self.btnMenu setImage:[UIImage imageNamed:@"menu_button"] forState:UIControlStateNormal];
    }else{
        [self.btnMenu setImage:[UIImage imageNamed:@"menu_button_black"] forState:UIControlStateNormal];
        [self.btnBack setImage:[UIImage imageNamed:@"eshop_back"] forState:UIControlStateNormal];
        [self.btnNext setImage:[UIImage imageNamed:@"esho_categories"] forState:UIControlStateNormal];
    }
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [self cat_viewDidAppear:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btnMenuTapped:(id)sender {
    
    AAAppDelegate *appDelegate = (AAAppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate openSideMenu];
}

- (IBAction)btnBackTapped:(id)sender {
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    }
}

- (IBAction)btnNextTapped:(id)sender {
    if ([self.webView canGoForward]) {
        [self.webView goForward];
    }
}
-(void)reloadWebView{
//    self.webPageUrl = @"https://vtweb.sandbox.veritrans.co.id/v2/vtweb/4cee863e-fb16-4fd7-ba59-b9119ef2c41b";
    NSURL *url = [NSURL URLWithString:self.webPageUrl];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    self.lblTitle.text = self.webPageTitle;
}
-(void)setPageTitle:(NSString*)title{
    self.lblTitle.text = title;
}
#pragma mark -
#pragma mark WebViewDelegate
-(void)webViewDidStartLoad:(UIWebView *)webView{
    
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    
    [self.btnBack setEnabled:[webView canGoBack]];
    [self.btnNext setEnabled:[webView canGoForward]];
    
}
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSLog(@"URL = %@",request.URL);
    return true;
}
@end
