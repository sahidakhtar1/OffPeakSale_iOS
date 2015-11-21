//
//  AAOrderItemCell.m
//  AppWiz
//
//  Created by Shahid Akhtar Shaikh on 11/12/15.
//  Copyright © 2015 Shaikh Shahid Akhtar. All rights reserved.
//

#import "AAOrderItemCell.h"

@implementation AAOrderItemCell

- (void)awakeFromNib {
    // Initialization code
    self.lblDescription.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].boldFont size:SHOPPINGCART_SHORTDESC_FONTSIZE];
    
    self.lblItemTotal.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:SHOPPINGCART_ITEMTOTAL_FONTSIZE];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
