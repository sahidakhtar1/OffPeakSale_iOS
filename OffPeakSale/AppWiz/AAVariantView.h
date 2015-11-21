//
//  AAVariantView.h
//  AppWiz
//
//  Created by Shaikh Shahid Akhtar on 21/12/14.
//  Copyright (c) 2014 Shahid Akhtar Shaikh. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OptionsSlectionDelegate <NSObject>

-(void)showOptionDropDown:(int)optionIndex;

@end

@interface AAVariantView : UIView
@property (weak, nonatomic) IBOutlet UILabel *lblOptionlbl;
@property (weak, nonatomic) IBOutlet UIButton *btnOptions;
@property (weak, nonatomic) IBOutlet UIView *vwHorizontalLine;
@property (weak, nonatomic) IBOutlet UIView *vwVerticalLine;
@property (unsafe_unretained, nonatomic) id<OptionsSlectionDelegate> delegate;
- (IBAction)btnOptionTapped:(id)sender;

@end
