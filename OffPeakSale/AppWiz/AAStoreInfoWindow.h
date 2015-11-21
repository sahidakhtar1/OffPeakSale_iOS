//
//  AAStoreInfoWindow.h
//  AppWiz
//
//  Created by Shahid Akhtar Shaikh on 13/1/14.
//  Copyright (c) 2014 Shahid Akhtar Shaikh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AAStoreInfoWindow : UIView
@property (weak, nonatomic) IBOutlet UILabel *lblStoreName;
@property (weak, nonatomic) IBOutlet UILabel *lblStoreAddress;
@property (weak, nonatomic) IBOutlet UILabel *lblStoreContactNumber;
@property (weak, nonatomic) IBOutlet UILabel *lblContactLabel;

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewCalloutArrow;
- (IBAction)onContactNumberTap:(id)sender;
//updates the info window to fit the content
-(void)updateContainerSize:(CGFloat)maxWidth;
@end
