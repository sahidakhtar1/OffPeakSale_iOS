//
//  AAVouchersViewController.h
//  Swensens
//
//  Created by Shahid Akhtar Shaikh on 15/12/13.
//  Copyright (c) 2013 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AAChildBaseViewController.h"
#import "AAVoucherTableViewCell.h"
#import "AAVoucher.h"
#import "AAAddHelper.h"
#import "AAAddHandler.h"
@interface AAVouchersViewController : AAChildBaseViewController <UITableViewDataSource,UITableViewDelegate,AAVoucherTableViewCellDelegate,AAAddHandlerDelegate>
{
    NSMutableArray* arrVouchers;
}
@property (weak, nonatomic) IBOutlet UITableView *tableViewVouchers;
@property (nonatomic,strong) AAAddHandler* adHandler;
@property (weak, nonatomic) IBOutlet UIView *vwHeaderView;
@end
