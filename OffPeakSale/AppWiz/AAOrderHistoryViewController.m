//
//  AAOrderHistoryViewController.m
//  AppWiz
//
//  Created by Shahid Akhtar Shaikh on 11/12/15.
//  Copyright © 2015 Shaikh Shahid Akhtar. All rights reserved.
//

#import "AAOrderHistoryViewController.h"
#import "AAOrderHistoryCell.h"
#import "AAHeaderView.h"
#import "AAProfileViewController.h"
#import "AAOrderHistoryHelper.h"
#import "AAOrderDetailViewController.h"
@interface AAOrderHistoryViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *vwHeaderView;
@property (weak, nonatomic) IBOutlet UITableView *tbOrderHstory;
@property (nonatomic, strong) NSMutableArray *orders;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;
- (IBAction)btnLoginTapped:(id)sender;

@end

@implementation AAOrderHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    AAHeaderView *headerView = [[AAHeaderView alloc] initWithFrame:self.vwHeaderView.frame];
    [self.vwHeaderView addSubview:headerView];
    [headerView setTitle:@"My Orders"];
    headerView.showCart = false;
    headerView.showBack = false;
    [headerView setMenuIcons];
    BOOL isLoggedIn = [[NSUserDefaults standardUserDefaults] boolForKey:KEY_IS_LOGGED_IN];
    if (!isLoggedIn) {
        [self showLoginView];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
   BOOL isLoggedIn = [[NSUserDefaults standardUserDefaults] boolForKey:KEY_IS_LOGGED_IN];
    __weak AAOrderHistoryViewController *weakSelf = self;
    NSString *email = [AAAppGlobals sharedInstance].consumer.email;
//    email = @"pendyala.bhargavi@gmail.com";
    if (isLoggedIn) {
        [AAOrderHistoryHelper getOrderHostory:email
                          withCompletionBlock:^(NSArray *obj) {
                              weakSelf.orders = obj;
                              [weakSelf.tbOrderHstory reloadData];
                          }
                                   andFailure:^(NSString *error) {
                                       
                                   }];
        self.btnLogin.hidden = true;
        self.tbOrderHstory.hidden = false;
    }else{
        self.btnLogin.hidden = false;
        self.tbOrderHstory.hidden = true;
    }
}
-(void)showLoginView{
    AAProfileViewController* profileViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AAProfileViewController"];
    [profileViewController setShowBuyButton:YES];
    profileViewController.profileDelegate = self;
    profileViewController.showBuyButton = NO;
    [self.navigationController pushViewController:profileViewController animated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.orders count];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AAOrderHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AAOrderHistoryCell"];
    NSDictionary *dict = [self.orders objectAtIndex:indexPath.row];
    NSString *orderId = [dict valueForKey:@"orderId"];
    NSArray *items = [dict objectForKey:@"products"];
    NSString *total = [dict valueForKey:@"orderTotal"];
    NSString *date = [dict valueForKey:@"orderDate"];
    NSString *status = [dict valueForKey:@"shippingStatus"];
    NSArray *dateComp = [date componentsSeparatedByString:@" "];
    if ([dateComp count]>0) {
        date = [dateComp objectAtIndex:0];
    }
   
    cell.lblOrderIdValue.text = orderId;
    cell.lblItemCount.text = [NSString stringWithFormat:@"%lu Items",(unsigned long)[items count]];
    cell.lblTotal.text = [NSString stringWithFormat:@"%@ %@",[AAAppGlobals sharedInstance].currency_code,total];
    
    cell.lblDate.text = [NSString stringWithFormat:@"%@",date];
    
    cell.lblStatus.text = [NSString stringWithFormat:@"Order status: %@",status];
    
    CGSize lblOrderIdSize = [AAUtils getTextSizeWithFont:cell.lblOrderId.font andText:cell.lblOrderId.text andMaxWidth:MAXFLOAT];
    CGRect frameOrderId = cell.lblOrderId.frame;
    frameOrderId.size.width = lblOrderIdSize.width;
    cell.lblOrderId.frame = frameOrderId;
    
    CGRect frameOrderIdValue = cell.lblOrderIdValue.frame;
    frameOrderIdValue.origin.x = frameOrderId.origin.x+ lblOrderIdSize.width+5;
    cell.lblOrderIdValue.frame = frameOrderIdValue;
    
    CGSize lblItemCountSize = [AAUtils getTextSizeWithFont:cell.lblItemCount.font andText:cell.lblItemCount.text andMaxWidth:MAXFLOAT];
    CGRect frameItemCount = cell.lblItemCount.frame;
    frameItemCount.size.width = lblItemCountSize.width;
    cell.lblItemCount.frame = frameItemCount;
    
    CGRect frameCircle1 = cell.lmgCircle1.frame;
    frameCircle1.origin.x = frameItemCount.origin.x+ frameItemCount.size.width+5;
    cell.lmgCircle1.frame = frameCircle1;
    
    CGSize lblTotalSize = [AAUtils getTextSizeWithFont:cell.lblTotal.font andText:cell.lblTotal.text andMaxWidth:MAXFLOAT];
    CGRect frameTotal = cell.lblTotal.frame;
    frameTotal.size.width = lblTotalSize.width;
    frameTotal.origin.x = frameCircle1.origin.x+ frameCircle1.size.width+5;
    cell.lblTotal.frame = frameTotal;
    
    CGRect frameCircle2 = cell.imgCircle2.frame;
    frameCircle2.origin.x = frameTotal.origin.x+ frameTotal.size.width+5;
    cell.imgCircle2.frame = frameCircle2;
    
    CGSize lblDateSize = [AAUtils getTextSizeWithFont:cell.lblDate.font andText:cell.lblDate.text andMaxWidth:MAXFLOAT];
    CGRect frameDate = cell.lblDate.frame;
    frameDate.size.width = lblDateSize.width;
    frameDate.origin.x = frameCircle2.origin.x+ frameCircle2.size.width+5;
    cell.lblDate.frame = frameDate;
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = [self.orders objectAtIndex:indexPath.row];
    AAOrderDetailViewController *orderDetailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AAOrderDetailViewController"];
    [orderDetailVC setOrderObj:dict];
    [self.navigationController pushViewController:orderDetailVC animated:YES];
}
- (IBAction)btnLoginTapped:(id)sender {
    [self showLoginView];
}
@end
