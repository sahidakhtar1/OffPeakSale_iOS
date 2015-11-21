//
//  AALoginDailogView.h
//  AppWiz
//
//  Created by Shaikh Shahid Akhtar on 24/04/14.
//  Copyright (c) 2014 Shahid Akhtar Shaikh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AAThemeGlossyButton.h"
#import "AAThemeValidationTextField.h"
#import "AAThemeLabel.h"


@interface AAOrderSucessView : UIView <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIView *vwHeaderView;
@property (strong, nonatomic) IBOutlet AAThemeLabel *lblHeaderText;
@property (strong, nonatomic) IBOutlet UIView *vwContainerView;
@property (strong, nonatomic) IBOutlet UILabel *lblGrandTotal;
@property (strong, nonatomic) IBOutlet UILabel *lblOrderNo;
@property (strong, nonatomic) IBOutlet UILabel *lblOderMsg;
@property (strong, nonatomic) IBOutlet AAThemeGlossyButton *btnDismiss;
@property (strong, nonatomic) IBOutlet UILabel *lblThabkYou;

@property (nonatomic, strong) NSString *mOrderNumber;
@property (nonatomic, strong) NSString *mGrandTotal;
@property BOOL mIsByCredit;

- (IBAction)btnCloseTapped:(id)sender;
-(void)refreshView;
- (id)initWithFrame:(CGRect)frame withOderNumber:(NSString*)odernumber grandTotal:(NSString*)total andIsByCredit:(BOOL)isByCredit;

@end
