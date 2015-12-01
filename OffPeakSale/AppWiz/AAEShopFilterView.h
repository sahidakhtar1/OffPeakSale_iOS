//
//  AAEShopFilterView.h
//  AppWiz
//
//  Created by Shaikh Shahid Akhtar on 12/05/15.
//  Copyright (c) 2015 Shahid Akhtar Shaikh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "AAThemeView.h"

@class AASearchDisplayControler;
@protocol EshopFilterDelegate <NSObject>

-(void)filterAppliedWith:(NSInteger)filterIndex;

@end
@interface AAEShopFilterView : UIView <CLLocationManagerDelegate, UITextFieldDelegate>

{
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
    NSString *targetLat,*targetLong,*tagetedAddress;
}


@property (nonatomic, strong) AASearchDisplayControler *searchDisplayVc;
@property (strong, nonatomic) IBOutlet UIView *vwContainerView;
@property (weak, nonatomic) IBOutlet UITextField *curntLocation;
@property (weak, nonatomic) IBOutlet UITextField *targetLocation;
@property (weak, nonatomic) IBOutlet UIButton *curentRadioBtn;
@property (weak, nonatomic) IBOutlet UIButton *targetRadioBtn;
@property (weak, nonatomic) IBOutlet AAThemeGlossyButton *btnDone;
@property (unsafe_unretained, nonatomic) id<EshopFilterDelegate> delegate;
@property (nonatomic) NSInteger selectedFilterIndex;
- (IBAction)btnFilteSelected:(id)sender;
- (IBAction)btnDoneTapped:(id)sender;
@end
