//
//  AAOrderDetailViewController.m
//  AppWiz
//
//  Created by Shahid Akhtar Shaikh on 11/12/15.
//  Copyright © 2015 Shaikh Shahid Akhtar. All rights reserved.
//

#import "AAOrderDetailViewController.h"
#import "AAThemeLabel.h"
#import "AAQRCodeViewController.h"
#import "AAOrderItemCell.h"
#import "UIImageView+WebCache.h"
#import "AAOrderDetailView.h"
static NSString *name = @"name";
static NSString *new_price = @"new_price";
static NSString *product_img = @"product_img";
static NSString *quantity = @"quantity";
static NSString *prodOptions = @"prodOptions";
static NSString *rewards = @"rewards";
static NSString *products = @"products";

@interface AAOrderDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet AAThemeLabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnQRCode;
@property (weak, nonatomic) IBOutlet UIView *vwHeader;
@property (weak, nonatomic) IBOutlet UITableView *tbOrderItems;
@property (nonatomic, strong) NSArray *orderedItems;

@property (nonatomic, strong) AAOrderDetailView *orderDetailView;
- (IBAction)btnBackTapped:(id)sender;
- (IBAction)btnQRCodeTapped:(id)sender;

@end

@implementation AAOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.lblTitle setFont:[UIFont fontWithName:[AAAppGlobals sharedInstance].boldFont size:TITLE_FONTSIZE]];
    [self.btnQRCode.titleLabel setFont:[UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:BUTTON_FONTSIZE]];
    [self.btnQRCode setTitleColor:[AAColor sharedInstance].retailerThemeTextColor forState:UIControlStateNormal];
    if ([[AAAppGlobals sharedInstance].retailer.appIconColor isEqualToString:@"White"]) {
        
        [self.btnBack setImage:[UIImage imageNamed:@"back_button"] forState:UIControlStateNormal];
        //        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    }else{
        
        [self.btnBack setImage:[UIImage imageNamed:@"back_button_black"] forState:UIControlStateNormal];
    }
    self.orderedItems = [[NSArray alloc] initWithArray:[self.orderObj objectForKey:products]];
    [self.tbOrderItems reloadData];
    self.orderDetailView = [[AAOrderDetailView alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width, 235)];
    [self populateOrderInfo];
    [self.tbOrderItems setTableHeaderView:self.orderDetailView];
    [self.tbOrderItems setTableFooterView:[[UIView alloc]init]];
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

- (IBAction)btnBackTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnQRCodeTapped:(id)sender {
    AAQRCodeViewController *qrCodeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AAQRCodeViewController"];
    
    [self.navigationController pushViewController:qrCodeVC animated:YES];
    [qrCodeVC setCouponCode:[self.orderObj valueForKey:@"qrCode"]];
}

#pragma mark -
#pragma mark UITableView Delegate and DataSources
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.orderedItems count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    float height=10;
    
    NSDictionary* item = [self.orderedItems objectAtIndex:indexPath.row];
    NSString *productShortDescription = [item valueForKey:name];
    NSString *oprionValue = [item valueForKey:prodOptions];
    NSString *rewardsValue = [item valueForKey:rewards];
    
    float maxWidthForLbl = [UIScreen mainScreen].bounds.size.width - (MARGIN+PRODUCT_IMAGE_WIDTH+MARGIN + MARGIN+RIGHTITEM_WIDTH+MARGIN);
    CGSize productTextSize = [AAUtils getTextSizeWithFont:[UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:SHOPPINGCART_SHORTDESC_FONTSIZE] andText:productShortDescription andMaxWidth:maxWidthForLbl];
    height += productTextSize.height + ITEM_GAP;
    
    if ([oprionValue length] != 0) {
        NSString *oprionStr = [NSString stringWithFormat:@"Options: %@",oprionValue];
        
        CGSize optionSize= [AAUtils getTextSizeWithFont:[UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:PRODUCTDETAIL_REWARDS_FONTSIZE] andText:oprionStr andMaxWidth:maxWidthForLbl ];
        height +=optionSize.height+ITEM_GAP;
    }
    if ([[AAAppGlobals sharedInstance].retailer.enableRewards isEqualToString:@"1"] && [rewardsValue length] != 0) {
        height +=20+ITEM_GAP;
    }
    height += 20+ITEM_GAP;
    if (height < 88) {
        height = 88;
    }
    height += 5;
    
    return height;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AAOrderItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AAOrderItemCell"];
    
    NSDictionary* item = [self.orderedItems objectAtIndex:indexPath.row];
    NSString *productShortDescription = [item valueForKey:name];
    NSString *oprionValue = [item valueForKey:prodOptions];
//    oprionValue = @"XL,Black";
    NSString *rewardsValue = [item valueForKey:rewards];
    NSString *qty = [item valueForKey:quantity];
    NSString *imageUrl = [item valueForKey:product_img];
    NSString *itemPrice = [item valueForKey:new_price];
    
    float maxWidthForLbl = [UIScreen mainScreen].bounds.size.width - (MARGIN+PRODUCT_IMAGE_WIDTH+MARGIN + MARGIN+RIGHTITEM_WIDTH+MARGIN);
    CGSize productTextSize = [AAUtils getTextSizeWithFont:[UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:SHOPPINGCART_SHORTDESC_FONTSIZE] andText:productShortDescription andMaxWidth:maxWidthForLbl];
    CGRect frame = cell.lblDescription.frame ;
    frame.size.height = productTextSize.height;
    cell.lblDescription.frame  = frame;
    cell.lblDescription.text = productShortDescription;
    
    float cellHieght = frame.origin.y + frame.size.height+ITEM_GAP+5;
    if ([oprionValue length] == 0) {
        cell.lblProductOptions.hidden = true;
        
    }else{
        cell.lblProductOptions.hidden = false;
        
        NSMutableString *oprionStr = [NSMutableString stringWithFormat:@"Options: %@",oprionValue];
        
        cell.lblProductOptions.text = oprionStr;
        [cell.lblProductOptions setFont:[UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:PRODUCTDETAIL_REWARDS_FONTSIZE]];
        CGSize optionSize= [AAUtils getTextSizeWithFont:[UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:PRODUCTDETAIL_REWARDS_FONTSIZE] andText:oprionStr andMaxWidth:maxWidthForLbl ];
        CGRect productOptionFrame = cell.lblProductOptions.frame;
        productOptionFrame.origin.y = cellHieght;
        productOptionFrame.size.width = maxWidthForLbl;
        productOptionFrame.size.height = optionSize.height;
        cell.lblProductOptions.frame = productOptionFrame;
        cellHieght += optionSize.height+ITEM_GAP;
    }
    if ([[AAAppGlobals sharedInstance].retailer.enableRewards isEqualToString:@"1"] && [rewardsValue length] != 0) {
        cell.lblRewardPoints.hidden = false;
        CGRect productOptionFrame = cell.lblRewardPoints.frame;
        productOptionFrame.origin.y = cellHieght;
        cell.lblRewardPoints.frame = productOptionFrame;
        cellHieght += 20+ITEM_GAP;
        NSMutableAttributedString *hogan = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld Credit Points",[qty integerValue ] * [rewardsValue integerValue]]];
        NSUInteger length = [[NSString stringWithFormat:@"%ld",[qty integerValue ] * [rewardsValue integerValue]] length];
        [hogan addAttribute:NSFontAttributeName
                      value:[UIFont fontWithName:[AAAppGlobals sharedInstance].boldFont size:PRODUCTDETAIL_REWARDS_FONTSIZE]
                      range:NSMakeRange(0,length)];
        [hogan addAttribute:NSFontAttributeName
                      value:[UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:PRODUCTDETAIL_REWARDS_FONTSIZE]
                      range:NSMakeRange(length+1,[@"Credit Points" length])];
        [cell.lblRewardPoints setAttributedText:hogan];
    }else{
        cell.lblRewardPoints.hidden = true;
        
    }
    
    
    NSString *itemTotal;
    if (true) {
        itemTotal = [NSString stringWithFormat:@"%.2f",[qty integerValue ] * [itemPrice floatValue]];
    }else{
        itemTotal = [NSString stringWithFormat:@"%.0f",[qty integerValue ] * [itemPrice floatValue]];
    }
    itemTotal = [[AAAppGlobals sharedInstance] getPriceStrfromFromPrice:[itemTotal floatValue]];
    cell.lblItemTotal.text = [NSString stringWithFormat:@"%@x%@ = %@%@",qty,itemPrice,[AAAppGlobals sharedInstance].currency_symbol, itemTotal];
    
    
    
    CGRect itemTotalFrame = cell.lblItemTotal.frame;
    itemTotalFrame.origin.y = cellHieght;
    itemTotalFrame.size.width = [UIScreen mainScreen].bounds.size.width - (MARGIN+RIGHTITEM_WIDTH+MARGIN) - itemTotalFrame.origin.x;
    cell.lblItemTotal.frame = itemTotalFrame;
    
    cellHieght += 20+ITEM_GAP;
    
    [cell.imgProductImage setImageWithURL:[NSURL URLWithString:imageUrl]
                                completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                                }];
    if (cellHieght < 88) {
        cellHieght = 88;
    }
    cellHieght +=5;
    CGRect deviderFrame = cell.frame;
    deviderFrame.origin.y = cellHieght;
    cell.frame = deviderFrame;
    return cell;
}
-(void)populateOrderInfo{
    NSString *orderId = [self.orderObj valueForKey:@"orderId"];
    NSString *orderDate = [self.orderObj valueForKey:@"orderDate"];
    NSString *discountAmt = [self.orderObj valueForKey:@"discountAmt"];
    
    NSString *reward_redeemed = [self.orderObj valueForKey:@"reward_redeemed"];
    NSString *shippingAmt = [self.orderObj valueForKey:@"shippingAmt"];
    NSString *orderTotal = [self.orderObj valueForKey:@"orderTotal"];
    
    
    NSString *shippingStatus = [self.orderObj valueForKey:@"shippingStatus"];
    NSString *deliverydate = [self.orderObj valueForKey:@"deliverydate"];
    NSString *deliveryaddress = [self.orderObj valueForKey:@"deliveryaddress"];
    
    NSString *collectiondate = [self.orderObj valueForKey:@"collectiondate"];
    NSString *collectionaddress = [self.orderObj valueForKey:@"collectionaddress"];
    NSString *orderInstr = [self.orderObj valueForKey:@"orderInstr"];
    
    self.orderDetailView.lblOrderId.text = [NSString stringWithFormat:@"Order id: %@",orderId];
    self.orderDetailView.lblOrderStatus.text = [NSString stringWithFormat:@"Order status: %@",shippingStatus];
    self.orderDetailView.lblOrderDate.text = [NSString stringWithFormat:@"Order date: %@",orderDate];
    
    self.orderDetailView.lblOrderTotal.text = [NSString stringWithFormat:@"Total: %@",orderTotal];
    self.orderDetailView.lblCreditRedeemed.text = [NSString stringWithFormat:@"Credit Redeemed: %@",reward_redeemed];
    self.orderDetailView.lblDiscount.text = [NSString stringWithFormat:@"Discount: %@",discountAmt];
    
    self.orderDetailView.lblShippingFee.text = [NSString stringWithFormat:@"Shipping Fee: %@",shippingAmt];
    @try {
        if (deliverydate != nil && [deliveryaddress length]>0) {
            self.orderDetailView.DeliveryDate.text = [NSString stringWithFormat:@"Delivery Date: %@",deliverydate];
            self.orderDetailView.lblAddress.text = [NSString stringWithFormat:@"Delivery Address:"];
            self.orderDetailView.lblAddressValue.text = [NSString stringWithFormat:@"%@",deliveryaddress];
        }else{
            self.orderDetailView.DeliveryDate.text = [NSString stringWithFormat:@"Collection Date: %@",collectiondate];
            self.orderDetailView.lblAddress.text = [NSString stringWithFormat:@"Collection Address:"];
            self.orderDetailView.lblAddressValue.text = [NSString stringWithFormat:@"%@",collectionaddress];
        }
    }
    @catch (NSException *exception) {
        
    }
    
//    [self.orderDetailView.lblAddressValue sizeToFit];
    if ([shippingStatus isEqualToString:@"Fulfilled"]) {
        self.btnQRCode.hidden = true;
    }
    CGSize addressSize = [AAUtils getTextSizeWithFont:self.orderDetailView.lblAddressValue.font andText:self.orderDetailView.lblAddressValue.text andMaxWidth:self.orderDetailView.lblAddressValue.frame.size.width];
    if (addressSize.height <25) {
        addressSize.height = 25;
    }
    
    
    CGRect frame = self.orderDetailView.lblAddressValue.frame;
    frame.size.height = addressSize.height;
    self.orderDetailView.lblAddressValue.frame = frame;
    CGFloat height = frame.origin.y+frame.size.height;
    @try {
        if (orderInstr != nil && [orderInstr length]) {
            self.orderDetailView.lblInstruction.text = @"Instruction: ";
            self.orderDetailView.lblInstruction.hidden = false;
            self.orderDetailView.lblInstructionValue.text = orderInstr;
            self.orderDetailView.lblInstructionValue.hidden = false;
            CGSize instructionSize = [AAUtils getTextSizeWithFont:self.orderDetailView.lblInstructionValue.font andText:orderInstr andMaxWidth:self.orderDetailView.lblInstructionValue.frame.size.width];
            if (instructionSize.height <25) {
                instructionSize.height = 25;
            }
            frame = self.orderDetailView.lblInstruction.frame;
            frame.origin.y = height;
            self.orderDetailView.lblInstruction.frame = frame;
            
            frame = self.orderDetailView.lblInstructionValue.frame;
            frame.origin.y = height;
            frame.size.height = instructionSize.height;
            self.orderDetailView.lblInstructionValue.frame = frame;
            
            height += instructionSize.height;


        }else{
            self.orderDetailView.lblInstruction.hidden = true;
            self.orderDetailView.lblInstructionValue.hidden = true;
        }
    }
    @catch (NSException *exception) {
        
    }
    
    frame = self.orderDetailView.vwDevider.frame;
    frame.origin.y = height+7;
    self.orderDetailView.vwDevider.frame = frame;
    
    frame = self.orderDetailView.frame;
    frame.size.height =self.orderDetailView.vwDevider.frame.origin.y+1;
    self.orderDetailView.frame = frame;
    
}
@end
