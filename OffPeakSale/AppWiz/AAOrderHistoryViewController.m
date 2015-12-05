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
@property (nonatomic, strong) NSDictionary *allRrders;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;
- (IBAction)btnLoginTapped:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *vwTopTab;
@property (weak, nonatomic) IBOutlet UIButton *btnActive;
@property (weak, nonatomic) IBOutlet UIButton *btnUsed;
@property (weak, nonatomic) IBOutlet AAThemeView *vwSelectionUnderline;
- (IBAction)btnActiveTapped:(id)sender;
- (IBAction)btnUsedTapped:(id)sender;

@property (nonatomic) int selectedIndex;

@end

@implementation AAOrderHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.selectedIndex = 0;
    AAHeaderView *headerView = [[AAHeaderView alloc] initWithFrame:self.vwHeaderView.frame];
    [self.vwHeaderView addSubview:headerView];
    [headerView setTitle:self.pageTitle];
    headerView.showCart = false;
    headerView.showBack = false;
    [headerView setMenuIcons];
    BOOL isLoggedIn = [[NSUserDefaults standardUserDefaults] boolForKey:KEY_IS_LOGGED_IN];
    if (!isLoggedIn) {
        [self showLoginView];
    }
    self.vwTopTab.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"btn_tab_default"]];
    [self adjustTabButtons];
    [self.btnActive.titleLabel setFont:[UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:FONT_SIZE_OLD_PRICE]];
    [self.btnUsed.titleLabel setFont:[UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:FONT_SIZE_OLD_PRICE]];
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
                          withCompletionBlock:^(NSDictionary *obj) {
                              weakSelf.allRrders = obj;
                              [weakSelf refreshTableView];
                          }
                                   andFailure:^(NSString *error) {
                                       
                                   }];
        self.btnLogin.hidden = true;
        self.tbOrderHstory.hidden = false;
        self.vwTopTab.hidden = false;
    }else{
        self.btnLogin.hidden = false;
        self.tbOrderHstory.hidden = true;
        self.vwTopTab.hidden = true;
    }
    
}
-(void)adjustTabButtons{
    CGRect frame = self.btnActive.frame;
    frame.size.width = self.view.frame.size.width/2;
    self.btnActive.frame = frame;
    
    frame = self.btnUsed.frame;
    frame.size.width = self.view.frame.size.width/2;
    frame.origin.x = self.view.frame.size.width/2;
    self.btnUsed.frame = frame;
    [UIView animateWithDuration:.5 animations:^{
        CGPoint center = self.vwSelectionUnderline.center;
        center.x = self.btnActive.center.x;
        self.vwSelectionUnderline.center = center;
    }
                     completion:nil];
    
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
    NSString *orderId = [dict valueForKey:@"qrCode"];
    NSArray *items = [dict objectForKey:@"products"];
    NSString *total = [dict valueForKey:@"orderTotal"];
    NSString *purchaseDate = [dict valueForKey:@"orderDate"];
    NSString *status = [dict valueForKey:@"orderStatus"];
    NSString *orderUsedOn = [dict valueForKey:@"orderUsedOn"];
    NSString *orderExpiry = [dict valueForKey:@"orderExpiry"];
//    NSArray *dateComp = [date componentsSeparatedByString:@" "];
//    if ([dateComp count]>0) {
//        date = [dateComp objectAtIndex:0];
//    }
    cell.lblOrderId.text = [NSString stringWithFormat:@"Order %@",orderId];
    cell.lblDatePurchase.text = [NSString stringWithFormat:@"Date of Purchase %@",purchaseDate];
    
    cell.lblTotal.text = [NSString stringWithFormat:@"Price %@%@",[AAAppGlobals sharedInstance].currency_symbol,total];
    cell.lblStatus.text = [NSString stringWithFormat:@"Order Status %@",status];
    if ([status isEqualToString:@"Redeemed"]) {
       cell.lblOrderExpiry.text = [NSString stringWithFormat:@"Redeemed On %@",orderUsedOn];
    }else if ([status isEqualToString:@"Expired"]){
        cell.lblOrderExpiry.text = [NSString stringWithFormat:@"Expired On %@",orderUsedOn];
    }else{
        cell.lblOrderExpiry.text = [NSString stringWithFormat:@"Expiry Date %@",orderExpiry];
    }

    
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
- (IBAction)btnActiveTapped:(id)sender {
    self.selectedIndex = 0;
    [UIView animateWithDuration:.5 animations:^{
                                    CGPoint center = self.vwSelectionUnderline.center;
                                    center.x = self.btnActive.center.x;
                                    self.vwSelectionUnderline.center = center;
                                }
                     completion:nil];
    
    [self refreshTableView];
}

- (IBAction)btnUsedTapped:(id)sender {
    self.selectedIndex = 1;
    [UIView animateWithDuration:.5 animations:^{
                                    CGPoint center = self.vwSelectionUnderline.center;
                                    center.x = self.btnUsed.center.x;
                                    self.vwSelectionUnderline.center = center;
                                }
                     completion:nil];
    [self refreshTableView];
}
-(void)refreshTableView{
    if (self.selectedIndex == 0) {
        self.orders = [self.allRrders objectForKey:@"active"];
    }else{
        self.orders = [self.allRrders objectForKey:@"used"];
    }
    [self.tbOrderHstory reloadData];
}
-(void)closeProfileViewController:(id)viewController
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
