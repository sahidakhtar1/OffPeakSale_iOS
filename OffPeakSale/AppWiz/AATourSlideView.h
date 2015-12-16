//
//  AATourSlideView.h
//  AppWiz
//
//  Created by Shahid Akhtar Shaikh on 12/5/15.
//  Copyright © 2015 Shaikh Shahid Akhtar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AATourItem.h"
@interface AATourSlideView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *imgBg;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UITextView *lblDecription;
@property (weak, nonatomic) IBOutlet UIView *vwContainer;
@property (weak, nonatomic) IBOutlet UIImageView *imgLogo;
@property (nonatomic, strong) AATourItem *tourItem;
@end
