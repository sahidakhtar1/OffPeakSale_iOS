//
//  AASideMenuViewController.h
//  AppWiz
//
//  Created by Shahid Akhtar Shaikh on 4/23/15.
//  Copyright (c) 2015 Shahid Akhtar Shaikh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AASideMenuViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tbMenu;
@property (nonatomic, strong) NSMutableArray *arrMenuItems;
@end
