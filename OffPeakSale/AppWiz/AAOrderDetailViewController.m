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
@property (nonatomic, strong) UIImageView *imgQRCode;

@property (nonatomic, strong) AAOrderDetailView *orderDetailView;
- (IBAction)btnBackTapped:(id)sender;
- (IBAction)btnQRCodeTapped:(id)sender;

@end

@implementation AAOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.lblTitle.text = self.pageTitle;
    [self.lblTitle setFont:[UIFont fontWithName:[AAAppGlobals sharedInstance].boldFont size:TITLE_FONTSIZE]];
    [self.btnQRCode.titleLabel setFont:[UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:BUTTON_FONTSIZE]];
    [self.btnQRCode setTitleColor:[AAColor sharedInstance].retailerThemeTextColor forState:UIControlStateNormal];
    if ([[AAAppGlobals sharedInstance].retailer.appIconColor isEqualToString:@"White"]) {
        
        [self.btnBack setImage:[UIImage imageNamed:@"back_button"] forState:UIControlStateNormal];
        //        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    }else{
        
        [self.btnBack setImage:[UIImage imageNamed:@"back_button_black"] forState:UIControlStateNormal];
    }
    self.imgQRCode = [[UIImageView alloc] initWithFrame:CGRectMake(0, 40, 150, 150)];
    CGPoint center = self.imgQRCode.center;
    center.x = self.view.frame.size.width/2;
    self.imgQRCode.center = center;
    UIView *tbFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 250)];
    [tbFooterView addSubview:self.imgQRCode];
    [tbFooterView setBackgroundColor:[UIColor clearColor]];
    [self.tbOrderItems setTableFooterView:tbFooterView];

    self.orderedItems = [[NSArray alloc] initWithArray:[self.orderObj objectForKey:products]];
    [self.tbOrderItems reloadData];
    self.orderDetailView = [[AAOrderDetailView alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width, 209)];
    self.orderDetailView.delegate = self;
    [self populateOrderInfo];
    [self.tbOrderItems setTableHeaderView:self.orderDetailView];
    
    
    
    
    //    [self.view addSubview:tbFooterView];
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
-(void)nameTappaed{
    AAQRCodeViewController *qrCodeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AAQRCodeViewController"];
    
    if ([self.orderedItems count]) {
        NSDictionary* item = [self.orderedItems objectAtIndex:0];
        qrCodeVC.pageTitle = [item valueForKey:@"name"];
        qrCodeVC.orderObj = self.orderObj;
    }
    [self.navigationController pushViewController:qrCodeVC animated:YES];
//    [qrCodeVC setCouponCode:[self.orderObj valueForKey:@"qrCode"]];
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
    NSString *discount = [item valueForKey:@"offpeak_discount"];
    
    float maxWidthForLbl = [UIScreen mainScreen].bounds.size.width - (MARGIN+PRODUCT_IMAGE_WIDTH+MARGIN + MARGIN+RIGHTITEM_WIDTH+MARGIN);
    CGSize productTextSize = [AAUtils getTextSizeWithFont:[UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:SHOPPINGCART_SHORTDESC_FONTSIZE] andText:productShortDescription andMaxWidth:maxWidthForLbl];
    height += productTextSize.height + ITEM_GAP;
    if (discount != nil) {
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
    NSString *itemOldPrice = [item valueForKey:@"old_price"];
    NSString *itemPrice = [item valueForKey:new_price];
    NSString *discount = [item valueForKey:@"offpeak_discount"];
    
    
    float maxWidthForLbl = [UIScreen mainScreen].bounds.size.width - (MARGIN+PRODUCT_IMAGE_WIDTH+MARGIN + MARGIN+RIGHTITEM_WIDTH+MARGIN);
    CGSize productTextSize = [AAUtils getTextSizeWithFont:[UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:SHOPPINGCART_SHORTDESC_FONTSIZE] andText:productShortDescription andMaxWidth:maxWidthForLbl];
    CGRect frame = cell.lblDescription.frame ;
    frame.size.height = productTextSize.height;
    cell.lblDescription.frame  = frame;
    cell.lblDescription.text = productShortDescription;
    cell.lblDescription.textColor = [AAColor sharedInstance].retailerThemeBackgroundColor;
    
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
//    if ([[AAAppGlobals sharedInstance].retailer.enableRewards isEqualToString:@"1"] && [rewardsValue length] != 0) {
//        cell.lblRewardPoints.hidden = false;
//        CGRect productOptionFrame = cell.lblRewardPoints.frame;
//        productOptionFrame.origin.y = cellHieght;
//        cell.lblRewardPoints.frame = productOptionFrame;
//        cellHieght += 20+ITEM_GAP;
//        NSMutableAttributedString *hogan = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld Credit Points",[qty integerValue ] * [rewardsValue integerValue]]];
//        NSUInteger length = [[NSString stringWithFormat:@"%ld",[qty integerValue ] * [rewardsValue integerValue]] length];
//        [hogan addAttribute:NSFontAttributeName
//                      value:[UIFont fontWithName:[AAAppGlobals sharedInstance].boldFont size:PRODUCTDETAIL_REWARDS_FONTSIZE]
//                      range:NSMakeRange(0,length)];
//        [hogan addAttribute:NSFontAttributeName
//                      value:[UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:PRODUCTDETAIL_REWARDS_FONTSIZE]
//                      range:NSMakeRange(length+1,[@"Credit Points" length])];
//        [cell.lblRewardPoints setAttributedText:hogan];
//    }else{
//        cell.lblRewardPoints.hidden = true;
//        
//    }
    
    
    NSString *itemTotal;
    if (true) {
        itemTotal = [NSString stringWithFormat:@"%.2f",[qty integerValue ] * [itemPrice floatValue]];
    }else{
        itemTotal = [NSString stringWithFormat:@"%.0f",[qty integerValue ] * [itemPrice floatValue]];
    }
    itemTotal = [[AAAppGlobals sharedInstance] getPriceStrfromFromPrice:[itemTotal floatValue]];
    
    NSString *currencySymbol = [AAAppGlobals sharedInstance].currency_symbol;
    NSString *oldPrice  =[NSString stringWithFormat:@"%@%@",currencySymbol,itemOldPrice];
    
    NSString *price = [NSString stringWithFormat:@"%@ %@%@",oldPrice,currencySymbol,itemPrice];
    NSRange range = [price rangeOfString:oldPrice];
    NSMutableAttributedString *attributedText =[[NSMutableAttributedString alloc] initWithString:price];
    
    NSDictionary *attr = [NSDictionary dictionaryWithObjectsAndKeys:
                          [NSNumber numberWithInteger:NSUnderlinePatternSolid | NSUnderlineStyleSingle],
                          NSStrikethroughStyleAttributeName,
                          [UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:FONT_SIZE_OLD_PRICE],NSFontAttributeName,
                          nil];
    [attributedText setAttributes:attr range:range];

    cell.lblItemTotal.font=[UIFont fontWithName:[AAAppGlobals sharedInstance].boldFont size:FONT_SIZE_NEW_PRICE];
    cell.lblItemTotal.attributedText = attributedText;
    
    
    
    
    
    CGRect itemTotalFrame = cell.lblItemTotal.frame;
    itemTotalFrame.origin.y = cellHieght;
    itemTotalFrame.size.width = [UIScreen mainScreen].bounds.size.width - (MARGIN+RIGHTITEM_WIDTH+MARGIN) - itemTotalFrame.origin.x;
    cell.lblItemTotal.frame = itemTotalFrame;
    
    cellHieght += 20+ITEM_GAP;
    if (discount != nil ) {
        NSString *percentage = @"%";
        cell.lblRewardPoints.attributedText = [self getAttributedString:@"Discocunt" andValue:[NSString stringWithFormat:@"%@%@",discount,percentage]];
        cellHieght += 20+ITEM_GAP;
        CGRect frame = cell.lblRewardPoints.frame;
        frame.origin.x = cell.lblItemTotal.frame.origin.x;
        frame.origin.y = itemTotalFrame.origin.y+itemTotalFrame.size.height + ITEM_GAP;
        cell.lblRewardPoints.frame = frame;
        cell.lblRewardPoints.hidden = false;
    }else{
        cell.lblRewardPoints.hidden = true;
    }
    
    
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
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self nameTappaed];
}
-(void)populateOrderInfo{
    NSString *orderId = [self.orderObj valueForKey:@"qrCode"];
//    NSString *orderDate = [self.orderObj valueForKey:@"orderDate"];

    NSString *outletAddr = [self.orderObj valueForKey:@"outletAddr"];
    NSString *outletContact = [self.orderObj valueForKey:@"outletContact"];
    NSString *outletLat = [self.orderObj valueForKey:@"outletLat"];
    NSString *outletLong = [self.orderObj valueForKey:@"outletLong"];
    
    NSString *orderStatus = [self.orderObj valueForKey:@"orderStatus"];
    NSString *orderUsedOn = [self.orderObj valueForKey:@"orderUsedOn"];
    NSString *orderExpiry = [self.orderObj valueForKey:@"orderExpiry"];
    
    if ([self.orderedItems count]) {
        NSDictionary* item = [self.orderedItems objectAtIndex:0];
        NSString *name = [item valueForKey:@"name"];
        [self.orderDetailView.lblName
         setAttributedText:[self getAttributedString:@"Resturant Name" andValue:name]];
    }
//    if (outletLat != nil && outletLong != nil) {
//        NSString *distance = [[AAAppGlobals sharedInstance]
//                               getDisctanceFrom:[AAAppGlobals sharedInstance].locationHandler.currentLocation.coordinate.latitude
//                               andLong:[AAAppGlobals sharedInstance].locationHandler.currentLocation.coordinate.longitude
//                               toLat:[outletLat doubleValue]
//                               andLong:[outletLong doubleValue]];
//        [self.orderDetailView.lblDistance setAttributedText:[self getAttributedString:@"Distance" andValue:[NSString stringWithFormat:@"%@ KM",distance]]];
//    }else{
//       [self.orderDetailView.lblDistance setAttributedText:[self getAttributedString:@"Distance" andValue:@""]];
//    }
    
    
    
    [self.orderDetailView.lblOrderId
     setText:[NSString stringWithFormat:@"Order # %@",orderId]];
    [self.orderDetailView.lblAddress
     setAttributedText:[self getAttributedString:@"Address" andValue:outletAddr]];
    [self.orderDetailView.lblTelephone
     setAttributedText:[self getAttributedString:@"Telephone" andValue:outletContact]];
//    [self.orderDetailView.lblDistance
//     setAttributedText:[self getAttributedString:@"Telephone" andValue:outletContact]];
    
    NSString *statusValue = orderStatus;
    if ([orderStatus isEqualToString:@"Redeemed"]) {
        self.orderDetailView.lblExpiry.attributedText =[self getAttributedString:@"Redeemed On" andValue:orderUsedOn];
        [self.imgQRCode setImage:[UIImage imageNamed:@"redeemed_icon"]];
    }else if ([orderStatus isEqualToString:@"Expired"]){
        NSString *date =  orderUsedOn;
        NSArray *dateComp = [date componentsSeparatedByString:@" "];
        if ([dateComp count]>0) {
            date = [dateComp objectAtIndex:0];
        }
        self.orderDetailView.lblExpiry.attributedText = [self getAttributedString:@"Expired On" andValue:date];
        [self.imgQRCode setImage:[UIImage imageNamed:@"expired_icon"]];
    }else{
        NSString *date =  orderExpiry;
        NSArray *dateComp = [date componentsSeparatedByString:@" "];
        if ([dateComp count]>0) {
            date = [dateComp objectAtIndex:0];
        }
        self.orderDetailView.lblExpiry.attributedText = [self getAttributedString:@"Expiry Date" andValue:date];
        NSString *qrCodeUrl = [NSString stringWithFormat:@"https://api.qrserver.com/v1/create-qr-code/?size=300x300&data=%@",orderId];
        [self.imgQRCode setImageWithURL:[NSURL URLWithString:qrCodeUrl]
                              completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                              }];
        statusValue = @"Active";
    }
    [self.orderDetailView.lblStatus
     setAttributedText:[self getAttributedString:@"Status" andValue:statusValue]];
    
    CGSize size = [AAUtils getTextSizeWithFont:self.orderDetailView.lblName.font andText:self.orderDetailView.lblName.text andMaxWidth:self.orderDetailView.lblName.frame.size.width];
    CGRect frame = self.orderDetailView.lblName.frame;
    frame.size.height =size.height;
    self.orderDetailView.lblName.frame = frame;
    
    float itemGap = 5;
    float yCod = frame.origin.y+frame.size.height + itemGap;
    
    size =  [AAUtils getTextSizeWithFont:self.orderDetailView.lblAddress.font andText:self.orderDetailView.lblAddress.text andMaxWidth:self.orderDetailView.lblAddress.frame.size.width];
    frame = self.orderDetailView.lblAddress.frame;
    frame.size.height =size.height;
    frame.origin.y = yCod;
    self.orderDetailView.lblAddress.frame = frame;
    yCod += frame.size.height + itemGap;
    
    size =  [AAUtils getTextSizeWithFont:self.orderDetailView.lblTelephone.font andText:self.orderDetailView.lblTelephone.text andMaxWidth:self.orderDetailView.lblTelephone.frame.size.width];
    frame = self.orderDetailView.lblTelephone.frame;
    frame.size.height =size.height;
    frame.origin.y = yCod;
    self.orderDetailView.lblTelephone.frame = frame;
    yCod += frame.size.height + itemGap;
    
    size =  [AAUtils getTextSizeWithFont:self.orderDetailView.lblStatus.font andText:self.orderDetailView.lblStatus.text andMaxWidth:self.orderDetailView.lblStatus.frame.size.width];
    frame = self.orderDetailView.lblStatus.frame;
    frame.size.height =size.height;
    frame.origin.y = yCod;
    self.orderDetailView.lblStatus.frame = frame;
    yCod += frame.size.height + itemGap;
    
    size =  [AAUtils getTextSizeWithFont:self.orderDetailView.lblExpiry.font andText:self.orderDetailView.lblExpiry.text andMaxWidth:self.orderDetailView.lblExpiry.frame.size.width];
    frame = self.orderDetailView.lblExpiry.frame;
    frame.size.height =size.height;
    frame.origin.y = yCod;
    self.orderDetailView.lblExpiry.frame = frame;
    yCod += frame.size.height + itemGap;
    
    
    
    frame = self.orderDetailView.vwDevider.frame;
    frame.origin.y = self.orderDetailView.lblExpiry.frame.origin.y + self.orderDetailView.lblExpiry.frame.size.height+10;
    self.orderDetailView.vwDevider.frame = frame;
    
    frame = self.orderDetailView.frame;
    frame.size.height =self.orderDetailView.vwDevider.frame.origin.y+1;
    self.orderDetailView.frame = frame;
    
}
-(NSAttributedString*)getAttributedString:(NSString*)boldString andValue:(NSString*)normalString{
    if (normalString == nil) {
        normalString = @"";
    }
    NSString *myString = [NSString stringWithFormat:@"%@  %@",boldString,normalString];
    NSDictionary *attrs = @{
                            NSFontAttributeName:[UIFont fontWithName:[AAAppGlobals sharedInstance].boldFont size:ORDER_HISTORY_FONTSIZE]
                            };
    NSRange range = [myString rangeOfString:boldString];
    
    // Create the attributed string (text + attributes)
    NSMutableAttributedString *attributedText =[[NSMutableAttributedString alloc] initWithString:myString];
    [attributedText setAttributes:attrs range:range];
    return attributedText;
}
@end
