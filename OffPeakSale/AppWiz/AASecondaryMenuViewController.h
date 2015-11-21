//
//  AASecondaryMenuViewController.h
//  AppWiz
//
//  Created by Shahid Akhtar Shaikh on 5/7/15.
//  Copyright (c) 2015 Shahid Akhtar Shaikh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AASecondaryMenuViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tbSecondaryMenu;
@property (nonatomic, strong) NSMutableArray *arrMenuItems;
@property (nonatomic) MenuItemType itemType;
@property (nonatomic) BOOL isCurrencyExpanded;
@end
