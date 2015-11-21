//
//  AAOrderItemCell.h
//  AppWiz
//
//  Created by Shahid Akhtar Shaikh on 11/12/15.
//  Copyright © 2015 Shaikh Shahid Akhtar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AAOrderItemCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *imgProductImage;
@property (strong, nonatomic) IBOutlet UILabel *lblDescription;
@property (strong, nonatomic) IBOutlet UILabel *lblItemTotal;
@property (weak, nonatomic) IBOutlet UILabel *lblProductOptions;
@property (weak, nonatomic) IBOutlet UILabel *lblRewardPoints;
@property (weak, nonatomic) IBOutlet UIView *vwDevider;
@end
