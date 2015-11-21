//
//  AAOrderHistoryCell.m
//  AppWiz
//
//  Created by Shahid Akhtar Shaikh on 11/12/15.
//  Copyright © 2015 Shaikh Shahid Akhtar. All rights reserved.
//

#import "AAOrderHistoryCell.h"

@implementation AAOrderHistoryCell

- (void)awakeFromNib {
    // Initialization code
    self.lblOrderId.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:ORDER_HISTORY_FONTSIZE];
    self.lblOrderIdValue.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].boldFont size:ORDER_HISTORY_FONTSIZE];
    self.lblItemCount.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:ORDER_HISTORY_FONTSIZE];
    self.lblTotal.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].boldFont size:ORDER_HISTORY_FONTSIZE];
    self.lblDate.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:ORDER_HISTORY_FONTSIZE];
    self.lblStatus.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:ORDER_HISTORY_FONTSIZE];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
