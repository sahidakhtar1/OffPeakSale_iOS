//
//  AAOrderDetailView.h
//  AppWiz
//
//  Created by Shahid Akhtar Shaikh on 11/15/15.
//  Copyright © 2015 Shaikh Shahid Akhtar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AAOrderDetailView : UIView
@property (weak, nonatomic) IBOutlet UILabel *lblOrderId;
@property (weak, nonatomic) IBOutlet UILabel *lblOrderStatus;
@property (weak, nonatomic) IBOutlet UILabel *lblOrderDate;
@property (weak, nonatomic) IBOutlet UILabel *lblOrderTotal;
@property (weak, nonatomic) IBOutlet UILabel *lblCreditRedeemed;
@property (weak, nonatomic) IBOutlet UILabel *lblDiscount;
@property (weak, nonatomic) IBOutlet UILabel *lblShippingFee;
@property (weak, nonatomic) IBOutlet UILabel *DeliveryDate;
@property (weak, nonatomic) IBOutlet UILabel *lblAddress;
@property (weak, nonatomic) IBOutlet UILabel *lblAddressValue;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addressHeight;
@property (weak, nonatomic) IBOutlet UIView *vwDevider;
@property (weak, nonatomic) IBOutlet UILabel *lblInstruction;
@property (weak, nonatomic) IBOutlet UILabel *lblInstructionValue;

@end
