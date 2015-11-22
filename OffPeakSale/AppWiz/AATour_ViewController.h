//
//  AATour_ViewController.h
//  AppWiz
//
//  Created by Litoo on 22/11/15.
//  Copyright © 2015 Shaikh Shahid Akhtar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AATour_ViewController : UIViewController <UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *logo;
@property (strong, nonatomic) IBOutlet UIButton *homeBtn;

-(IBAction)homeBtn_action:(id)sender;

@end
