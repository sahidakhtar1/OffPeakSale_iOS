//
//  AACertVeiwCell.m
//  AppWiz
//
//  Created by Shaikh Shahid Akhtar on 26/04/14.
//  Copyright (c) 2014 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AACertVeiwCell.h"

@implementation AACertVeiwCell
@synthesize delegate,indexPath;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void)awakeFromNib{
//    CALayer *layer = self.imgProductImage.layer;
//    layer.shadowOffset = CGSizeMake(1, 1);
//    layer.shadowColor = [[UIColor blackColor] CGColor];
//    layer.shadowRadius = 1.0f;
//    layer.shadowOpacity = 0.80f;
//    layer.shadowPath = [[UIBezierPath bezierPathWithRect:layer.bounds] CGPath];
//    CALayer *layer = self.imgProductImage.layer;
//    layer.borderColor = BOARDER_COLOR.CGColor;
//    layer.borderWidth = 1.0f;
//    float screenWidth = [UIScreen mainScreen].bounds.size.width - 20;
//    CGRect frame = self.overLayView.frame;
//    frame.size.width =screenWidth;
//    self.overLayView.frame = frame;
//    [AAStyleHelper addGradientOverlayToView:self.overLayView withFrame:self.overLayView.frame withColor:[UIColor blackColor]];
    
    self.lblDescription.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].boldFont size:SHOPPINGCART_SHORTDESC_FONTSIZE];
    self.lbUnitPrice.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:SHOPPINGCART_ITEMTOTAL_FONTSIZE];
    self.lblItemTotal.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].boldFont size:SHOPPINGCART_ITEMTOTAL_FONTSIZE];
    self.tfQty.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:SHOPPINGCART_QTY_FONTSIZE];
    self.btnUpdate.titleLabel.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].boldFont size:14];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)btnUpdateQTYTapped:(id)sender {
    [self.tfQty resignFirstResponder];
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(updateQTYAtIndexPath:withQTY:)]) {
        [self.delegate updateQTYAtIndexPath:self.indexPath withQTY:self.tfQty.text];
    }
}

- (IBAction)btnDeleteTapped:(id)sender {
    [self.tfQty resignFirstResponder];
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(deleteProductAtIndexPath:)]) {
        [self.delegate deleteProductAtIndexPath:self.indexPath];
    }
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    BOOL flag = true;
    if ([string length]== 0) {
        return true;
    }
    NSString *str = [NSString stringWithFormat:@"%@%@",textField.text,string];
    if ([str integerValue]>9) {
        return false;
    }else{
        return true;
    }
    return flag;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(updateQTYAtIndexPath:withQTY:)]) {
        [self.delegate updateQTYAtIndexPath:self.indexPath withQTY:self.tfQty.text];
    }
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(updateQTYAtIndexPath:withQTY:)]) {
        [self.delegate updateQTYAtIndexPath:self.indexPath withQTY:self.tfQty.text];
    }
}
@end
