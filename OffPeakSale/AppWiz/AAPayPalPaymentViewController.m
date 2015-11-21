//
//  AAPayPalPaymentViewController.m
//  AppWiz
//
//  Created by Shahid Akhtar Shaikh on 6/1/14.
//  Copyright (c) 2014 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AAPayPalPaymentViewController.h"
#import "AAConfig.h"
@interface AAPayPalPaymentViewController ()

@end

@implementation AAPayPalPaymentViewController

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
	// Do any additional setup after loading the view.
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
//    for(NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
//        
//        if([[cookie domain] isEqualToString:@"https://www.sandbox.paypal.com"]) {
//            
//            [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
//        }
//    }
//    [self.wvPayPal loadRequest:[NSURLRequest requestWithURL:self.urlPayPalProduct cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:100.0]];
    NSURL *redirectUrl = nil;
    if ([[AAAppGlobals sharedInstance].retailer.enableVerit isEqualToString:@"1"]) {
        redirectUrl = [NSURL URLWithString:self.veritRedirectUrl];
    }else{
        redirectUrl = self.urlPayPalProduct;
    }
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:redirectUrl];
//    [request setValue:@"Mozilla/5.0 (Linux; U; Android 2.2.1; en-us; Nexus One Build/FRG83) AppleWebKit/533.1 (KHTML, like Gecko) Version/4.0 Mobile Safari/533.1" forHTTPHeaderField:@"User_Agent"];
    [self.wvPayPal loadRequest:request];
    //[[UIApplication sharedApplication] openURL:self.urlPayPalProduct];
    self.wvPayPal.delegate = self;
    self.btnCancle.titleLabel.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].boldFont size:BUTTON_FONTSIZE];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL *newURL = [[NSURL alloc] initWithScheme:[request.URL scheme]
                                             host:[request.URL host]
                                             path:[request.URL path]];
    NSLog(@"url = %@",newURL);
    if ([newURL.absoluteString containsString:@"place_order.php"] || [newURL.absoluteString containsString:@"veritrans_order.php"]) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        [self.paypalPaymentDelegate onPaymentFinished:YES placeOderUrl:request.URL.absoluteString];
        return NO;
    }else if([newURL.absoluteString isEqualToString:self.paypalSuccessURLString] )
    {
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        [self.paypalPaymentDelegate onPaymentFinished:YES placeOderUrl:nil];
    }
    else if ([newURL.absoluteString isEqualToString:self.paypalFailureURLString])
    {
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        [self.paypalPaymentDelegate onPaymentFinished:NO placeOderUrl:nil];
    }
    //NSLog(@"%@",request.URL.absoluteString);
    return YES;
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
    self.vwCancelView.hidden = FALSE;
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    CGRect mainScreen = [UIScreen mainScreen].bounds;

    CGRect frame = webView.frame;
    frame.size.height = mainScreen.size.height;
    webView.frame = frame;
    self.vwCancelView.hidden = TRUE;
    
}

- (IBAction)btnCancleTapped:(id)sender {
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self.paypalPaymentDelegate onPaymentFinished:NO placeOderUrl:nil];
}
@end
