//
//  AAVouchersViewController.m
//  Swensens
//
//  Created by Shahid Akhtar Shaikh on 15/12/13.
//  Copyright (c) 2013 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AAVouchersViewController.h"
#import "AAHeaderView.h"
#import "UIViewController+AAShakeGestuew.h"
#import "AAEShopHelper.h"
#import "AAProductInformationViewController.h"
@interface AAVouchersViewController ()

@end

@implementation AAVouchersViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        self.heading = @"VOUCHERS";
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
     [self.tableViewVouchers registerClass:[AAVoucherTableViewCell class] forCellReuseIdentifier:@"VoucherCell"];
    self.tableViewVouchers.delegate = self;
    self.tableViewVouchers.dataSource = self;
    UIView* tbheaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 0.0)];
    tbheaderView.backgroundColor = [UIColor whiteColor];
    self.tableViewVouchers.tableHeaderView = tbheaderView;
//    AAVoucher* voucher = [[AAVoucher alloc] init];
//    [voucher setVoucherFileType:VOUCHER_FILE_TYPE_VIDEO];
//    //    [voucher setVoucherFileUrl:[NSString stringWithFormat:
//    //                                @"http://223.25.237.175/appwizlive/uploads/retailer/1/pnimages/Swensational_Christmas.mp4"]];
//    [voucher setVoucherFileUrl:[NSString stringWithFormat:
//                                @"http://appwizlive.com/uploads/retailer/1/pnimages/deviceimg/pn_1420467903portrait_video.mp4"]];
//    arrVouchers = [[NSMutableArray alloc] init];
//    [arrVouchers addObject:voucher];
//    [arrVouchers addObject:voucher];
    
    AAHeaderView *headerView = [[AAHeaderView alloc] initWithFrame:self.vwHeaderView.frame];
    [self.vwHeaderView addSubview:headerView];
    [headerView setTitle:@"Vouchers"];
    headerView.showCart = false;
    headerView.showBack = false;
    headerView.delegate = self;
    headerView.delegate = self;
    [headerView setMenuIcons];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self cat_viewDidAppear:YES];
    [self addBanner];
    [AAAddHelper getPublisherIdFromServerWithCompletionBlock:^ {
        self.adHandler = nil;
        [self addBanner];
    } andFailure:^(NSString *errMessage) {
        
    }];
    arrVouchers = [[AAAppGlobals sharedInstance].voucherList getVouchers];
//    [self addDummyVoucher];
    [self.tableViewVouchers reloadData];
}



-(void)refreshView
{
    arrVouchers = [[AAAppGlobals sharedInstance].voucherList getVouchers];
    
    [self.tableViewVouchers reloadData];
}
-(void)addDummyVoucher{
    if (arrVouchers == nil) {
        arrVouchers = [[NSMutableArray alloc] init];
    }
    AAVoucher* voucher = [[AAVoucher alloc] init];
    [voucher setVoucherFileType:VOUCHER_FILE_TYPE_IMAGE];
    voucher.pid = @"745";
    //    [voucher setVoucherFileUrl:[NSString stringWithFormat:
    //                                @"http://223.25.237.175/appwizlive/uploads/retailer/1/pnimages/Swensational_Christmas.mp4"]];
    [voucher setVoucherFileUrl:[NSString stringWithFormat:
                                @"http:\/\/smartcommerce.asia\/uploads\/retailer\/1\/pnimages\/deviceimg\/1496_pn_14349960321_1434972810_8._Push_Notification_Voucher_xdhpi.jpg"]];
    //http://appwizlive.com/uploads/retailer/11/pnimages/deviceimg/pn_14053468485.Eshop1.jpg
    [arrVouchers addObject:voucher];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI Table View Management
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrVouchers count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AAVoucherTableViewCell* voucherCell = [self.tableViewVouchers dequeueReusableCellWithIdentifier:@"VoucherCell" forIndexPath:indexPath];
    voucherCell.selectionStyle = UITableViewCellSelectionStyleNone;
    voucherCell.delegate = self;
    voucherCell.btnDeleteVoucher.tag = indexPath.row;
   AAVoucher* voucher = [arrVouchers objectAtIndex:indexPath.row];
    
    voucherCell.voucher = voucher;
    
    
    
    return voucherCell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[AAAppGlobals sharedInstance] getImageHeight]+10;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AAVoucher* voucher = [arrVouchers objectAtIndex:indexPath.row];
    if (voucher.pid != nil) {
        [AAEShopHelper getEshopProductDetail:voucher.pid WithCompletionBlock:^(AAEShopProduct *p) {
            AAProductInformationViewController *eshopVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AAProductInformationViewController"];
            eshopVC.product = p;
            [self.navigationController pushViewController:eshopVC animated:YES];
        }];
    }
}
-(void)onVoucherDeleteTap:(int)index
{
    if (index<[arrVouchers count]) {
      [arrVouchers removeObjectAtIndex:index];
    }
    
    [[AAAppGlobals sharedInstance].voucherList removeVoucherAtIndex:index];
    [self.tableViewVouchers reloadData];
    NSData *dataVouchers = [NSKeyedArchiver archivedDataWithRootObject:[AAAppGlobals sharedInstance].voucherList];
    
    [[NSUserDefaults standardUserDefaults] setObject:dataVouchers    forKey:USER_DEFAULTS_VOUCHERS_KEY];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)addBanner
{
    if(self.adHandler==nil && [AAAppGlobals sharedInstance].addPublisherId && ([AAAppGlobals sharedInstance].addPublisherId.length > 0))
    {
        self.adHandler = [[AAAddHandler alloc]initWithPublisherId:/*@"ca-app-pub-8773946931527913/7091917786"*/[AAAppGlobals sharedInstance].addPublisherId];
        self.adHandler.delegate = self;
        [self.adHandler addAdBannerWithContainerView:self.view];
    }
}

-(void)didNotReceivedAd
{
    CGRect tableViewVouchersFrame =  self.tableViewVouchers.frame;
    tableViewVouchersFrame.size.height = self.view.frame.size.height-64;
    tableViewVouchersFrame.origin.y = 64;
    self.tableViewVouchers.frame = tableViewVouchersFrame;
}

-(void)didReceiveAd
{
  CGRect tableViewVouchersFrame =  self.tableViewVouchers.frame;
    tableViewVouchersFrame.origin.y = 64;
    tableViewVouchersFrame.size.height = self.view.frame.size.height - self.adHandler.bannerHeight-64;
    self.tableViewVouchers.frame = tableViewVouchersFrame;
}
-(void)searchItemWithText:(NSString*)text{
   
}
@end
