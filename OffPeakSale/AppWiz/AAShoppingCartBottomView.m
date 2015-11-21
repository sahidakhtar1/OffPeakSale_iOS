//
//  AAShoppingCartBottomView.m
//  AppWiz
//
//  Created by Shahid Akhtar Shaikh on 5/9/15.
//  Copyright (c) 2015 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AAShoppingCartBottomView.h"

#import "AAEarliestSchedule.h"
NSString* const DELIVERY_OPTIONS_BUTTON_GROUP = @"DeliveryOptionGroup";
@implementation AAShoppingCartBottomView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self = [self initialize];
        [self setUpRadioButtons];
        self.frame = frame;
        
        [self refreshView];
        [self adjustFrames];
        [self setFonts];
        [self setUpRadioButtons];
        
    }
    return self;
}
-(void)awakeFromNib{
    
}
- (UIView*)initialize{
    UIView *childView= [[[NSBundle mainBundle] loadNibNamed:@"ShoppingCartBottomView" owner:self options:nil] objectAtIndex:0];
    
        return childView;
}
- (IBAction)btnDeleveryScheduleTapped:(id)sender {
    
    self.deliveryScheduleView = [[AADeleveryScheduleView alloc] init];
    UIWindow *mainWindow = [UIApplication sharedApplication].keyWindow;
    [mainWindow addSubview:self.deliveryScheduleView];

    
}

- (IBAction)btnRedeemRewardTapped:(id)sender {
    BOOL isLoggedIn = [[NSUserDefaults standardUserDefaults] boolForKey:KEY_IS_LOGGED_IN];
    if (!isLoggedIn) {
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(showLoginView)]) {
            [self.delegate showLoginView];
        }
    }else{
        self.redeemRewardView = [[AARedeemRewardsView alloc] init];
        UIWindow *mainWindow = [UIApplication sharedApplication].keyWindow;
        [mainWindow addSubview:self.redeemRewardView];
    }
    
}

- (IBAction)radioButtonTapped:(id)sender {
    UIButton *btn = (UIButton*)sender;
    if ([btn tag] ==0) {
        self.rdHomeDelivery.selected = true;
        self.rdStoreCollection.selected = false;
        [AAAppGlobals sharedInstance].deliveryOptonSelectedIndex = 0;
    }else{
        self.rdHomeDelivery.selected = false;
        self.rdStoreCollection.selected = true;
        [AAAppGlobals sharedInstance].deliveryOptonSelectedIndex = 1;
    }
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(deliveryOptionchnaged)]) {
        [self.delegate deliveryOptionchnaged];
    }
    [self refreshView];
    [self adjustFrames];
}
-(void)updateSchedule{
    if ([AAAppGlobals sharedInstance].deliveryOptonSelectedIndex == 0 ) {
        NSString *scheduledDate =[[AAAppGlobals sharedInstance] convertDateToString:[AAAppGlobals sharedInstance].scheduledDate];
        [self.btnDelivetDate setTitle:scheduledDate forState:UIControlStateNormal];
        [self.btnDeliveryTime setTitle:[AAAppGlobals sharedInstance].selectedTime  forState:UIControlStateNormal];
    }else if ([AAAppGlobals sharedInstance].deliveryOptonSelectedIndex == 1){
        NSString *scheduledDate =[[AAAppGlobals sharedInstance] convertDateToString:[AAAppGlobals sharedInstance].scheduledDate];
        [self.btnDelivetDate setTitle:scheduledDate forState:UIControlStateNormal];
        [self.btnDeliveryTime setTitle:[AAAppGlobals sharedInstance].selectedTime  forState:UIControlStateNormal];
        [self.btnCollectionAddress setTitle:[AAAppGlobals sharedInstance].selectedCollectionAddress forState:UIControlStateNormal];
    }
}
-(void)refreshView{
    if ([AAAppGlobals sharedInstance].deliveryOptonSelectedIndex == 0 ) {
        BOOL isTimeLapse = [[AAAppGlobals sharedInstance].retailer.deliveryType isEqualToString:@"0"]?NO:YES;
        self.vwDeliveryDate.hidden = false;
        
        self.viewCollectionAddress.hidden = true;
        
        [[AAAppGlobals sharedInstance] getDateByAddingDays:[[AAAppGlobals sharedInstance].retailer.deliveryDays intValue]];
       AAEarliestSchedule *earlieastSchedule = [[AAAppGlobals sharedInstance] getDateByAddingDays:[[AAAppGlobals sharedInstance].retailer.deliveryDays intValue] andHours:[[AAAppGlobals sharedInstance].retailer.deliveryHours intValue] andTimeSlots:[AAAppGlobals sharedInstance].deliverySlotsArray isStandardLimeLapse:isTimeLapse];
        [AAAppGlobals sharedInstance].earlieastSchedule = earlieastSchedule;
        NSString *scheduledDate =[[AAAppGlobals sharedInstance] convertDateToString:[AAAppGlobals sharedInstance].scheduledDate];
        [self.btnDelivetDate setTitle:scheduledDate forState:UIControlStateNormal];
        if (isTimeLapse) {
            [AAAppGlobals sharedInstance].selectedTime = @"";
            self.vwdeliveryTime.hidden = true;
        }else{
            [AAAppGlobals sharedInstance].selectedTime = [earlieastSchedule.possibleTimeSlots objectAtIndex:0];
            [self.btnDeliveryTime setTitle:[AAAppGlobals sharedInstance].selectedTime  forState:UIControlStateNormal];
            self.vwdeliveryTime.hidden = false;
        }
        
        self.lblDeliveyDate.text = @"Delivery Date";
        self.lblDeliveyTime.text = @"Delivery Time";
        
    }else if ([AAAppGlobals sharedInstance].deliveryOptonSelectedIndex == 1){
        BOOL isTimeLapse = [[AAAppGlobals sharedInstance].retailer.collectionType isEqualToString:@"0"]?NO:YES;
        self.vwDeliveryDate.hidden = false;
        self.vwdeliveryTime.hidden = false;
        self.viewCollectionAddress.hidden = false;
        [[AAAppGlobals sharedInstance] getDateByAddingDays:[[AAAppGlobals sharedInstance].retailer.collectionDays intValue]];
        AAEarliestSchedule *earlieastSchedule = [[AAAppGlobals sharedInstance] getDateByAddingDays:[[AAAppGlobals sharedInstance].retailer.collectionDays intValue] andHours:[[AAAppGlobals sharedInstance].retailer.collectionHours intValue] andTimeSlots:[AAAppGlobals sharedInstance].collectionSlotsArray isStandardLimeLapse:isTimeLapse];
        [AAAppGlobals sharedInstance].earlieastSchedule = earlieastSchedule;
        NSString *scheduledDate =[[AAAppGlobals sharedInstance] convertDateToString:[AAAppGlobals sharedInstance].scheduledDate];
        [self.btnDelivetDate setTitle:scheduledDate forState:UIControlStateNormal];
        if (isTimeLapse) {
            [AAAppGlobals sharedInstance].selectedTime = @"";
            self.vwdeliveryTime.hidden = true;
        }else{
            [AAAppGlobals sharedInstance].selectedTime = [earlieastSchedule.possibleTimeSlots objectAtIndex:0];
            [self.btnDeliveryTime setTitle:[AAAppGlobals sharedInstance].selectedTime forState:UIControlStateNormal];
            self.vwdeliveryTime.hidden = false;
        }
        
        [self.btnCollectionAddress setTitle:[AAAppGlobals sharedInstance].selectedCollectionAddress forState:UIControlStateNormal];
        
        self.lblDeliveyDate.text = @"Collection Date";
        self.lblDeliveyTime.text = @"Collection Time";
    }
    else{
        
        self.vwDeliveryDate.hidden = true;
        self.vwdeliveryTime.hidden = true;
        self.viewCollectionAddress.hidden = true;
    }
    if (![[AAAppGlobals sharedInstance].retailer.enableRewards isEqualToString:@"1"]) {
        self.vwRewardsRedeemed.hidden = true;
        self.vwRewardsEarned.hidden = true;
    }else{
        self.vwRewardsRedeemed.hidden = false;
        self.vwRewardsEarned.hidden = false;
        [self.btnRewardRedeemed setTitle:[NSString stringWithFormat:@"(%@)",[AAAppGlobals sharedInstance].rewardPointsRedeemed] forState:UIControlStateNormal];
        [self.rewardsEarnedValue setText:[AAAppGlobals sharedInstance].reward_points];
    }
    if (![[AAAppGlobals sharedInstance].retailer.enableCreditCode isEqualToString:@"1"] || [AAAppGlobals sharedInstance].discountPercent == 0) {
        self.vwDiscount.hidden = true;
    }else{
        self.vwDiscount.hidden = false;
    }
    
    if([AAAppGlobals sharedInstance].deliveryOptonSelectedIndex == 1){
        self.vwShipping.hidden = true;
    }else{
         self.vwShipping.hidden = false;
    }
    
}

-(void)adjustFrames{
    float yCod = 0;
    CGRect frame;
    if ([[AAAppGlobals sharedInstance].enableDelivery isEqualToString:@"1"] && [[AAAppGlobals sharedInstance].retailer.enableCollection isEqualToString:@"1"]) {
        yCod = 35;
    }
    if ([AAAppGlobals sharedInstance].deliveryOptonSelectedIndex == 0 ) {
        BOOL isTimeLapse = [[AAAppGlobals sharedInstance].retailer.deliveryType isEqualToString:@"0"]?NO:YES;
        if (isTimeLapse) {
            yCod += self.vwDeliveryDate.frame.size.height * 1;
        }else{
            yCod += self.vwDeliveryDate.frame.size.height * 2;
        }
        
    }else if([AAAppGlobals sharedInstance].deliveryOptonSelectedIndex == 1){
        BOOL isTimeLapse = [[AAAppGlobals sharedInstance].retailer.collectionType isEqualToString:@"0"]?NO:YES;
        frame = self.viewCollectionAddress.frame;
        if (isTimeLapse) {
            yCod += self.vwDeliveryDate.frame.size.height * 2;
            frame.origin.y = self.vwDeliveryDate.frame.size.height + self.vwDeliveryDate.frame.origin.y;
        }else{
            yCod += self.vwDeliveryDate.frame.size.height * 3;
            frame.origin.y = self.vwdeliveryTime.frame.size.height + self.vwdeliveryTime.frame.origin.y;
        }
        
        
        self.viewCollectionAddress.frame = frame;
        
    }
    
    if ([[AAAppGlobals sharedInstance].retailer.enableRewards isEqualToString:@"1"]) {
        frame = self.vwRewardsEarned.frame;
        frame.origin.y = yCod;
        self.vwRewardsEarned.frame = frame;
        yCod+= frame.size.height ;
    }
    if ([[AAAppGlobals sharedInstance].retailer.enableRewards isEqualToString:@"1"]) {
        CGRect frame = self.vwRewardsRedeemed.frame;
        frame.origin.y = yCod;
        self.vwRewardsRedeemed.frame = frame;
        yCod+= frame.size.height ;
    }
    if ([[AAAppGlobals sharedInstance].retailer.enableCreditCode isEqualToString:@"1"] || [AAAppGlobals sharedInstance].discountPercent != 0) {
        CGRect frame = self.vwDiscount.frame;
        frame.origin.y = yCod;
        self.vwDiscount.frame = frame;
        yCod+= frame.size.height ;
        self.vwDiscount.hidden = false;
    }
    
    if ([AAAppGlobals sharedInstance].deliveryOptonSelectedIndex == 0) {
        frame = self.vwShipping.frame;
        frame.origin.y = yCod;
        self.vwShipping.frame = frame;
        yCod+= frame.size.height ;
    }
    
    yCod += 5;
    
    CGRect bottomViewFrame = self.frame;
    bottomViewFrame.size.height = yCod;
    self.frame = bottomViewFrame;
    
}
-(void)setFonts{
    [self.lblDeliveyDate setFont:[UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:FOOTER_OPTIONS_FONTSIZE]];
    [self.lblDeliveyTime setFont:[UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:FOOTER_OPTIONS_FONTSIZE]];
    [self.lblCollectionAddress setFont:[UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:FOOTER_OPTIONS_FONTSIZE]];
    [self.lblRewardsRedeemed setFont:[UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:FOOTER_OPTIONS_FONTSIZE]];
    
    [self.btnDelivetDate.titleLabel setFont:[UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:FOOTER_OPTIONS_FONTSIZE]];
    [self.btnDeliveryTime.titleLabel setFont:[UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:FOOTER_OPTIONS_FONTSIZE]];
    [self.btnCollectionAddress.titleLabel setFont:[UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:FOOTER_OPTIONS_FONTSIZE]];
    [self.btnRewardRedeemed.titleLabel setFont:[UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:FOOTER_OPTIONS_FONTSIZE]];
    [self.lblDiscount setFont:[UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:FOOTER_OPTIONS_FONTSIZE]];
    [self.lblDiscountApplied setFont:[UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:FOOTER_OPTIONS_FONTSIZE]];
    [self.lblShippingFee setFont:[UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:FOOTER_OPTIONS_FONTSIZE]];
    [self.lblShippingValue setFont:[UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:FOOTER_OPTIONS_FONTSIZE]];
    [self.lblRewardsEarned setFont:[UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:FOOTER_OPTIONS_FONTSIZE]];
    [self.rewardsEarnedValue setFont:[UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:FOOTER_OPTIONS_FONTSIZE]];
}

-(void)setUpRadioButtons
{
    if ([[AAAppGlobals sharedInstance].enableDelivery isEqualToString:@"1"] && [[AAAppGlobals sharedInstance].retailer.enableCollection isEqualToString:@"1"]) {
        [AAAppGlobals sharedInstance].deliveryOptonSelectedIndex = 0;
    }else if([[AAAppGlobals sharedInstance].enableDelivery isEqualToString:@"1"]){
       [AAAppGlobals sharedInstance].deliveryOptonSelectedIndex = 0;
    }
    else if([[AAAppGlobals sharedInstance].retailer.enableCollection isEqualToString:@"1"]){
       [AAAppGlobals sharedInstance].deliveryOptonSelectedIndex = 1;
    }
    
    
}

@end
