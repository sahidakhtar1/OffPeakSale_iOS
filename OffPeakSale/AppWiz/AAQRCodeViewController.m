//
//  AAQRCodeViewController.m
//  AppWiz
//
//  Created by Shahid Akhtar Shaikh on 11/12/15.
//  Copyright © 2015 Shaikh Shahid Akhtar. All rights reserved.
//

#import "AAQRCodeViewController.h"
#import "UIImageView+WebCache.h"
#import "AAThemeLabel.h"
#import "AAMapView.h"
#import "AARetailerStores.h"
@interface AAQRCodeViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imgQRCode;
- (IBAction)btnCloseTapped:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *vwHeader;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet AAThemeLabel *lblTitle;

@end

@implementation AAQRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.lblTitle.text = self.pageTitle;
    [self.lblTitle setFont:[UIFont fontWithName:[AAAppGlobals sharedInstance].boldFont size:TITLE_FONTSIZE]];
    if ([[AAAppGlobals sharedInstance].retailer.appIconColor isEqualToString:@"White"]) {
        
        [self.btnBack setImage:[UIImage imageNamed:@"back_button"] forState:UIControlStateNormal];
    }else{
        
        [self.btnBack setImage:[UIImage imageNamed:@"back_button_black"] forState:UIControlStateNormal];
    }
    AAMapView *mvRetailerStores = [[AAMapView alloc] initWithFrame:CGRectMake(15,80, self.view.frame.size.width-30 , self.view.frame.size.height-95 )];
    mvRetailerStores.storeName = self.pageTitle;
    [self.view addSubview:mvRetailerStores];
    [self putPinsOnMap:mvRetailerStores];
}
-(void)putPinsOnMap:(AAMapView*)map{
    NSString *outletAddr = [self.orderObj valueForKey:@"outletAddr"];
    NSString *outletContact = [self.orderObj valueForKey:@"outletContact"];
    NSString *outletLat = [self.orderObj valueForKey:@"outletLat"];
    NSString *outletLong = [self.orderObj valueForKey:@"outletLong"];
    [map addMarkerWithTitle:self.pageTitle
                    address:outletAddr
                 andConatct:outletContact
                      atLat:outletLat
                        lng:outletLong];
    CLLocationCoordinate2D currentLocation =
    CLLocationCoordinate2DMake([AAAppGlobals sharedInstance].currentLat,
                               [AAAppGlobals sharedInstance].currentLong);
    [map addCurrentLocationMarkerWithCoordinate:[AAAppGlobals sharedInstance].locationHandler.currentLocation.coordinate
                                      withTitle:@"Current Location"
                                        andIcon:[UIImage imageNamed:@"current_location_marker"]];
    [map setStores:[self convertToOutletObject]];
    [map fitMapToMarkers];
}
-(NSMutableArray*)convertToOutletObject{
    NSArray* items = [self.orderObj objectForKey:@"products"];
    NSDictionary *item = [items objectAtIndex:0];
    NSArray *arr = [item objectForKey:@"outlets"];
    NSMutableArray *outlets = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in arr) {
        [outlets addObject:[AARetailerStores retailStoreFromDict:dict]];
        
    }
    return outlets;
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
