//
//  AAShoppingCartBottomView.h
//  AppWiz
//
//  Created by Shahid Akhtar Shaikh on 5/9/15.
//  Copyright (c) 2015 Shahid Akhtar Shaikh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AARedeemRewardsView.h"
#import "AADeleveryScheduleView.h"
#import "VCRadioButton.h"

@protocol ShoppingCartOptionsDelegate <NSObject>

-(void)deliveryOptionchnaged;
-(void)showLoginView;

@end

@interface AAShoppingCartBottomView : UIView

@property (weak, nonatomic) IBOutlet UIView *vwDeliveryDate;
@property (weak, nonatomic) IBOutlet UIView *vwdeliveryTime;
@property (weak, nonatomic) IBOutlet UIView *vwRewardsRedeemed;
@property (weak, nonatomic) IBOutlet UIView *vwDiscount;
@property (weak, nonatomic) IBOutlet UIView *vwShipping;
@property (weak, nonatomic) IBOutlet UIView *vwRewardsEarned;
@property (weak, nonatomic) IBOutlet UIButton *btnDelivetDate;
@property (weak, nonatomic) IBOutlet UILabel *lblDeliveyDate;
@property (weak, nonatomic) IBOutlet UILabel *lblDeliveyTime;
@property (weak, nonatomic) IBOutlet UIButton *btnDeliveryTime;
@property (weak, nonatomic) IBOutlet UILabel *lblRewardsRedeemed;
@property (weak, nonatomic) IBOutlet UIButton *btnRewardRedeemed;
@property (weak, nonatomic) IBOutlet UILabel *lblDiscount;
@property (weak, nonatomic) IBOutlet UILabel *lblDiscountApplied;
@property (weak, nonatomic) IBOutlet UILabel *lblShippingFee;
@property (weak, nonatomic) IBOutlet UILabel *lblShippingValue;

@property (weak, nonatomic) IBOutlet UILabel *lblRewardsEarned;
@property (weak, nonatomic) IBOutlet UILabel *rewardsEarnedValue;
@property (weak, nonatomic) IBOutlet UILabel *lblCollectionAddress;
@property (weak, nonatomic) IBOutlet UIButton *btnCollectionAddress;
@property (weak, nonatomic) IBOutlet UIView *viewCollectionAddress;

@property (nonatomic, strong) AARedeemRewardsView *redeemRewardView;
@property (nonatomic, strong) AADeleveryScheduleView *deliveryScheduleView
;
@property (weak, nonatomic) IBOutlet UIView *vwDeliveryOptions;
@property (weak, nonatomic) IBOutlet UIButton *rdHomeDelivery;
@property (weak, nonatomic) IBOutlet UIButton *rdStoreCollection;
@property (weak, nonatomic) IBOutlet UILabel *lblHomeDelivery;
@property (weak, nonatomic) IBOutlet UILabel *lblStoreCollection;



@property (unsafe_unretained, nonatomic) id<ShoppingCartOptionsDelegate> delegate;

- (IBAction)btnDeleveryScheduleTapped:(id)sender;
- (IBAction)btnRedeemRewardTapped:(id)sender;
- (IBAction)radioButtonTapped:(id)sender;
-(void)refreshView;
-(void)adjustFrames;
-(void)updateSchedule;
@end
