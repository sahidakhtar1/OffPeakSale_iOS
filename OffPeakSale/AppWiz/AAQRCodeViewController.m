//
//  AAQRCodeViewController.m
//  AppWiz
//
//  Created by Shahid Akhtar Shaikh on 11/12/15.
//  Copyright © 2015 Shaikh Shahid Akhtar. All rights reserved.
//

#import "AAQRCodeViewController.h"
#import "UIImageView+WebCache.h"
@interface AAQRCodeViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imgQRCode;
- (IBAction)btnCloseTapped:(id)sender;

@end

@implementation AAQRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self showQRCode:self.couponCode];
}
-(void)setCouponCode:(NSString *)couponCode{
    _couponCode = couponCode;
    [self showQRCode:couponCode];
}
-(void)showQRCode:(NSString*)code{
    NSString *qrCodeUrl = [NSString stringWithFormat:@"https://api.qrserver.com/v1/create-qr-code/?size=300x300&data=%@",code];
    [self.imgQRCode setImageWithURL:[NSURL URLWithString:qrCodeUrl]
                          completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                          }];
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

- (IBAction)btnCloseTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
