//
//  AALookBookViewController.h
//  AppWiz
//
//  Created by Shahid Akhtar Shaikh on 10/16/15.
//  Copyright (c) 2015 Shahid Akhtar Shaikh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AALookBookViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) NSString *title;
@end
