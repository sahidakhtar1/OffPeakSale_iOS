//
//  AACertVeiwCell.h
//  AppWiz
//
//  Created by Shaikh Shahid Akhtar on 26/04/14.
//  Copyright (c) 2014 Shahid Akhtar Shaikh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AAThemeValidationTextField.h"
#import "AAThemeGlossyButton.h"
@protocol CartItemDelegate <NSObject>

-(void)updateQTYAtIndexPath:(NSIndexPath*)indexPath withQTY:(NSString*)qty;
-(void)deleteProductAtIndexPath:(NSIndexPath*)indexPath;

@end

@interface AACertVeiwCell : UITableViewCell <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *imgProductImage;
@property (strong, nonatomic) IBOutlet UILabel *lblDescription;
@property (strong, nonatomic) IBOutlet AAThemeValidationTextField *tfQty;
@property (strong, nonatomic) IBOutlet UILabel *lbUnitPrice;
@property (strong, nonatomic) IBOutlet UILabel *lblItemTotal;
@property (weak, nonatomic) IBOutlet UILabel *lblProductOptions;
@property (weak, nonatomic) IBOutlet UILabel *lblRewardPoints;
@property (weak, nonatomic) IBOutlet UIView *vwDevider;
@property (strong, nonatomic) NSIndexPath *indexPath;
@property (unsafe_unretained, nonatomic) id<CartItemDelegate> delegate;
@property (strong, nonatomic) IBOutlet AAThemeGlossyButton *btnUpdate;
- (IBAction)btnUpdateQTYTapped:(id)sender;
- (IBAction)btnDeleteTapped:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *overLayView;
@property (weak, nonatomic) IBOutlet UILabel *lblGiftMsg;
@property (weak, nonatomic) IBOutlet UIView *vwRightView;

@end
