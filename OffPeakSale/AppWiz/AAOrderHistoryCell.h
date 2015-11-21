//
//  AAOrderHistoryCell.h
//  AppWiz
//
//  Created by Shahid Akhtar Shaikh on 11/12/15.
//  Copyright © 2015 Shaikh Shahid Akhtar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AAOrderHistoryCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblOrderId;
@property (weak, nonatomic) IBOutlet UILabel *lblItemCount;
@property (weak, nonatomic) IBOutlet UILabel *lblTotal;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;
@property (weak, nonatomic) IBOutlet UIImageView *lmgCircle1;
@property (weak, nonatomic) IBOutlet UIImageView *imgCircle2;
@property (weak, nonatomic) IBOutlet UILabel *lblOrderIdValue;

@end
