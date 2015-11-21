//
//  AADeleveryScheduleView.h
//  AppWiz
//
//  Created by Shahid Akhtar Shaikh on 5/10/15.
//  Copyright (c) 2015 Shahid Akhtar Shaikh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AAThemeValidationTextField.h"
#import "AADatePickerView.h"
#import "AAFilterDropDownScrollView.h"
@interface AADeleveryScheduleView : UIView<UITextFieldDelegate>

@property (nonatomic,strong) AADatePickerView* datePickerView;
@property (nonatomic, strong) NSDate *selectedDate;
@property (nonatomic, strong) NSString *selectedTime;
@property (nonatomic, strong) NSString *selectedAddress;
@property (nonatomic,strong) AAFilterDropDownScrollView* optionDropDown;

@property (strong, nonatomic)  NSMutableArray *items;

@property (strong, nonatomic) IBOutlet UIView *vwContainerView;
@property (weak, nonatomic) IBOutlet UILabel *lblDeleveryTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblSelectedSchedule;
@property (weak, nonatomic) IBOutlet UILabel *lblDeliveryDateTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblDeliveryTimeTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblCollectionAddressTitle;
@property (weak, nonatomic) IBOutlet AAThemeValidationTextField *tfDay;
@property (weak, nonatomic) IBOutlet AAThemeValidationTextField *tfMonth;
@property (weak, nonatomic) IBOutlet AAThemeValidationTextField *tfYear;
@property (weak, nonatomic) IBOutlet AAThemeValidationTextField *tfTime;
@property (weak, nonatomic) IBOutlet AAThemeValidationTextField *tfCollectionAddress;
@property (weak, nonatomic) IBOutlet AAThemeGlossyButton *btnDone;
@property (weak, nonatomic) IBOutlet UIImageView *imgUpdown;
@property (weak, nonatomic) IBOutlet UIImageView *imgTimeUpdown;
- (IBAction)btnCloseTapped:(id)sender;
- (IBAction)tfTimePressed:(id)sender;
- (IBAction)tfDeliveyDatePressed:(id)sender;
- (IBAction)tfCollectionAddressPressed:(id)sender;
- (IBAction)btnDonePressed:(id)sender;
@end
