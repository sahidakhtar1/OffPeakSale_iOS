//
//  AAEShopFilterView.m
//  AppWiz
//
//  Created by Shaikh Shahid Akhtar on 12/05/15.
//  Copyright (c) 2015 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AAEShopFilterView.h"

@implementation AAEShopFilterView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self = [self initialize];
        self.frame = frame;
        self.backgroundColor= [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        
        
        self.curentRadioBtn.layer.cornerRadius = self.curentRadioBtn.frame.size.height/2;
        self.curentRadioBtn.layer.borderColor = [APP_COLOR CGColor];
        self.curentRadioBtn.layer.borderWidth = 1.5f;
        self.curentRadioBtn.layer.masksToBounds=YES;
        
        self.targetRadioBtn.layer.cornerRadius = self.curentRadioBtn.frame.size.height/2;
        self.targetRadioBtn.layer.borderColor = [APP_COLOR CGColor];
        self.targetRadioBtn.layer.borderWidth = 1.5f;
        self.targetRadioBtn.layer.masksToBounds=YES;

        self.curntLocation.layer.cornerRadius = 2;
        self.curntLocation.layer.masksToBounds=YES;

        self.targetLocation.layer.cornerRadius = 2;
        self.targetLocation.layer.masksToBounds=YES;

        self.curntLocation.layer.sublayerTransform = CATransform3DMakeTranslation(15, 0, 0);
        self.targetLocation.layer.sublayerTransform = CATransform3DMakeTranslation(15, 0, 0);

        [self.vwContainerView setUserInteractionEnabled:YES];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnScreen)];
        tapGesture.numberOfTapsRequired = 1;
//        tapGesture.delegate = self;
        [self addGestureRecognizer:tapGesture];

        
        [self setFont];
        //        [self setRightIconstoTestFields];
        CGRect rect = [UIScreen mainScreen].bounds;
        self.frame = rect;
        CALayer *layer = self.vwContainerView.layer;
        layer.shadowOffset = CGSizeMake(1, 1);
        layer.shadowColor = [[UIColor blackColor] CGColor];
        layer.shadowRadius = 2.0f;
        layer.shadowOpacity = 0.80f;
        layer.shadowPath = [[UIBezierPath bezierPathWithRect:layer.bounds] CGPath];
//        self.vwContainerView.center = CGPointMake(self.center.x, rect.size.height/2);
        self.vwContainerView.frame = CGRectMake(10, 147, SCREEN_WIDTH - 20, 230);
        
        
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.distanceFilter = kCLDistanceFilterNone;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
            [locationManager requestWhenInUseAuthorization];
        
        [locationManager startUpdatingLocation];

        geocoder = [[CLGeocoder alloc] init];


        [self getLocationFromAddressString:@"Bommnahalli"];

    }
    return self;
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = [locations lastObject];
    [locationManager stopUpdatingLocation];
    NSLog(@"lat%f - lon%f", location.coordinate.latitude, location.coordinate.longitude);

    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if (!(error))
         {
             placemark = [placemarks lastObject];
             NSLog(@"\nCurrent Location Detected\n");
             NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
             NSString *Address = [[NSString alloc]initWithString:locatedAt];
             NSString *Area = [[NSString alloc]initWithString:placemark.locality];
             NSString *Country = [[NSString alloc]initWithString:placemark.country];
             NSString *CountryArea = [NSString stringWithFormat:@"%@, %@", Area,Country];
             NSLog(@"%@",CountryArea);
             NSLog(@"Address == %@",Address);
             [self.curntLocation setText:Address];
         }
         else
         {
             NSLog(@"Geocode failed with error %@", error);
             NSLog(@"\nCurrent Location Not Detected\n");
             //return;
         }
     }];
}
-(CLLocationCoordinate2D) getLocationFromAddressString: (NSString*) addressStr {
    double latitude = 0, longitude = 0;
    NSString *esc_addr =  [addressStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *req = [NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?sensor=false&address=%@", esc_addr];
    NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:req] encoding:NSUTF8StringEncoding error:NULL];
    if (result) {
        NSScanner *scanner = [NSScanner scannerWithString:result];
        if ([scanner scanUpToString:@"\"lat\" :" intoString:nil] && [scanner scanString:@"\"lat\" :" intoString:nil]) {
            [scanner scanDouble:&latitude];
            if ([scanner scanUpToString:@"\"lng\" :" intoString:nil] && [scanner scanString:@"\"lng\" :" intoString:nil]) {
                [scanner scanDouble:&longitude];
            }
        }
    }
    CLLocationCoordinate2D center;
    center.latitude=latitude;
    center.longitude = longitude;
    NSLog(@"View Controller get Location Latitute : %f",center.latitude);
    NSLog(@"View Controller get Location Longitude : %f",center.longitude);
    return center;
    
}

- (UIView*)initialize{
    UIView *childView= [[[NSBundle mainBundle] loadNibNamed:@"AAEShopFilterView" owner:self options:nil] objectAtIndex:0];
    
    return childView;
}
-(void)setFont{
    self.curntLocation.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:13.0];
    self.targetLocation.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:13.0];
//    self.btnFilterPopularity.titleLabel.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:17.0];
//    self.btnFilterLatest.titleLabel.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:17.0];
//    self.btnFilterLowestPrice.titleLabel.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:17.0];
//    self.btnFilterHighestPrice.titleLabel.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:17.0];
    self.btnDone.titleLabel.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].boldFont size:13.0];
}
- (IBAction)btnFilteSelected:(id)sender {
    UIButton *button = (UIButton*)sender;
    self.selectedFilterIndex = [button tag];
//    CGPoint center = self.imgFilterIndicator.center;
//    center.y = button.center.y;
//    self.imgFilterIndicator.center = center;
}

- (IBAction)btnDoneTapped:(id)sender {
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(filterAppliedWith:)]) {
        [self.delegate filterAppliedWith:self.selectedFilterIndex];
    }
    [self removeFromSuperview];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.tag == 1)
    {

    }
    else
    {
        
    }
    return YES;
}

- (void)tapOnScreen
{
    [self removeFromSuperview];
}
@end
