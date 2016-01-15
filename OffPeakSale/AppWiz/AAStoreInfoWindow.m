//
//  AAStoreInfoWindow.m
//  AppWiz
//
//  Created by Shahid Akhtar Shaikh on 13/1/14.
//  Copyright (c) 2014 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AAStoreInfoWindow.h"

@implementation AAStoreInfoWindow
static NSInteger const PADDING  = 10;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (IBAction)onContactNumberTap:(id)sender {
    NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"telprompt:%@",self.lblStoreContactNumber.text]];
    
    if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
        [[UIApplication sharedApplication] openURL:phoneUrl];
    } else
    {
       UIAlertView* calert = [[UIAlertView alloc]initWithTitle:@"Unable to call" message:@"Call feature is not available on this device." delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [calert show];
    }
}

-(void)updateContainerSize:(CGFloat)maxWidth
{
    
    self.lblStoreName.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].boldFont size:MAP_PIN_INFO_TITLE_FONT_SIZE];
    self.lblStoreAddress.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:MAP_PIN_INFO_DESC_FONT_SIZE];
    self.lblStoreContactNumber.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:MAP_PIN_INFO_DESC_FONT_SIZE];
    self.lblContactLabel.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:MAP_PIN_INFO_DESC_FONT_SIZE];
    
    [self setClipsToBounds:NO];
    self.backgroundColor = [UIColor clearColor];
    CGFloat containerHeight = 0;
    CGFloat containerWidth = 0;
   maxWidth = maxWidth/2;
    CGSize lblStoreNameSize = [AAUtils getTextSizeWithFont:self.lblStoreName.font andText:self.lblStoreName.text andMaxWidth:maxWidth];
     CGSize lblStoreAddressSize = [AAUtils getTextSizeWithFont:self.lblStoreAddress.font andText:self.lblStoreAddress.text andMaxWidth:maxWidth];
     CGSize lblStoreContactSize = [AAUtils getTextSizeWithFont:self.lblStoreContactNumber.font andText:self.lblStoreContactNumber.text andMaxWidth:maxWidth];
    
    CGFloat contactWidth = self.lblContactLabel.frame.size.width + lblStoreContactSize.width + 2*PADDING;
    CGFloat addressWidth = lblStoreAddressSize.width + 2*PADDING;
    CGFloat nameWidth = lblStoreNameSize.width + 2*PADDING;
    
    containerWidth = MAX(contactWidth, MAX(addressWidth, nameWidth));
   
    CGRect mainViewRect = self.frame;
    mainViewRect.size.width = containerWidth;
    
    CGRect containerViewRect = self.containerView.frame;
   containerViewRect.size.width = mainViewRect.size.width;
    CGRect lblStoreAddressRect = self.lblStoreAddress.frame;
    lblStoreAddressRect.size = lblStoreAddressSize;
    
    CGRect lblStoreContactRect = self.lblStoreContactNumber.frame;
    lblStoreContactRect.size = lblStoreContactSize;
    lblStoreContactRect.origin.y = lblStoreAddressRect.origin.y + lblStoreAddressRect.size.height;
   
    CGRect lblStoreContactLabelRect = self.lblContactLabel.frame;
    lblStoreContactLabelRect.origin.y = lblStoreAddressRect.origin.y + lblStoreAddressRect.size.height;
    lblStoreContactLabelRect.size.height = lblStoreContactSize.height;
    CGRect lblStoreNameRect = self.lblStoreName.frame;
   // lblStoreNameSize.height += 10;
    lblStoreNameRect.size = lblStoreNameSize;
    
   
    containerViewRect.size.height = lblStoreContactRect.origin.y + lblStoreContactRect.size.height + PADDING;
    mainViewRect.size.height = containerViewRect.size.height + self.imgViewCalloutArrow.frame.size.height;
    //[AAStyleHelper addLightShadowToView:self.containerView];
    //[AAStyleHelper addLightShadowToView:self.imgViewCalloutArrow];
    [self.containerView setClipsToBounds:NO];
    self.containerView.frame = containerViewRect;
    self.frame = mainViewRect;
    self.lblStoreName.frame = lblStoreNameRect;
    self.lblStoreAddress.frame = lblStoreAddressRect;
    self.lblStoreContactNumber.frame = lblStoreContactRect;
    self.lblContactLabel.frame = lblStoreContactLabelRect;
    self.lblStoreName.frame = lblStoreNameRect;
    self.containerView.layer.cornerRadius = 4;
//    self.containerView.layer.shadowOpacity = 0.5;
//    self.containerView.layer.shadowOffset = CGSizeMake(-4, -4);
//    self.containerView.layer.shadowColor = [UIColor blackColor].CGColor;
//    self.containerView.layer.shadowRadius = 4;

}
@end
