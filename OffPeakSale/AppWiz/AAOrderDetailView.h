//
//  AAOrderDetailView.h
//  AppWiz
//
//  Created by Shahid Akhtar Shaikh on 11/15/15.
//  Copyright © 2015 Shaikh Shahid Akhtar. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OrderDetailDelegate <NSObject>

-(void)nameTappaed;

@end

@interface AAOrderDetailView : UIView
@property (weak, nonatomic) IBOutlet UILabel *lblOrderId;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblAddress;
@property (weak, nonatomic) IBOutlet UILabel *lblTelephone;
@property (weak, nonatomic) IBOutlet UILabel *lblDistance;
@property (weak, nonatomic) IBOutlet UILabel *lblExpiry;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;

@property (weak, nonatomic) IBOutlet UIView *vwDevider;
@property (nonatomic, unsafe_unretained) id<OrderDetailDelegate> delegate;
- (IBAction)btnNameTapped:(id)sender;


@end
