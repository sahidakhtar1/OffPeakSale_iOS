//
//  AAEShopFilterView.m
//  AppWiz
//
//  Created by Shaikh Shahid Akhtar on 12/05/15.
//  Copyright (c) 2015 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AAEShopFilterView.h"
#import "AFHTTPRequestOperation.h";
@implementation AAEShopFilterView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self = [self initialize];
        self.frame = frame;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationUpdated:) name:NOTIFICATION_LOCATION_UPDATED object:nil];
        CLLocation *currentLocation = [AAAppGlobals sharedInstance].locationHandler.currentLocation;
        if (currentLocation) {
            [self getAddressFromCoordinates:currentLocation];
        }
        self.backgroundColor= [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        

        [self.vwContainerView setUserInteractionEnabled:YES];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnScreen)];
        tapGesture.numberOfTapsRequired = 1;
        [self addGestureRecognizer:tapGesture];

        
        [self setFont];
        CGRect rect = [UIScreen mainScreen].bounds;
        self.frame = rect;
        geocoder = [[CLGeocoder alloc] init];


        [self getLocationFromAddressString:@"Bommnahalli"];

    }
    return self;
}
-(void)locationUpdated:(NSNotification*)notification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        
        [self getAddressFromCoordinates:[AAAppGlobals sharedInstance].locationHandler.currentLocation];
        
    });
}
-(void)getAddressFromCoordinates:(CLLocation*)location{
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
    self.curntLocation.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:PROFILE_TF_FONTSIZE];
    self.targetLocation.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:PROFILE_TF_FONTSIZE];
    self.btnDone.titleLabel.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].boldFont size:BUTTON_FONTSIZE];
}
- (IBAction)btnFilteSelected:(id)sender {
    UIButton *button = (UIButton*)sender;
    self.selectedFilterIndex = [button tag];
    if (self.selectedFilterIndex == 0) {
        [self.curentRadioBtn setSelected:YES];
        [self.targetRadioBtn setSelected:NO];
        [self.targetLocation resignFirstResponder];
    }else{
        [self.curentRadioBtn setSelected:NO];
        [self.targetRadioBtn setSelected:YES];
        [self.targetLocation becomeFirstResponder];
    }
    
}

- (IBAction)btnDoneTapped:(id)sender {
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(filterAppliedWith:)]) {
//        [self.delegate filterAppliedWith:self.selectedFilterIndex];
    }
    [self removeFromSuperview];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (self.selectedFilterIndex == 0) {
       return false;
    }else{
        if (textField == self.targetLocation) {
            return false;
        }else{
            return false;
        }
    }
    return false;
}
- (void)tapOnScreen
{
    [self removeFromSuperview];
}
-(void)getAutocompleteWithText:(NSString*)text{
    NSString *url  =[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/autocomplete/json?input=%@&types=geocode&language=fr&key=AIzaSyDAIb7josxX55yT-aam9XpCnbPgKWjwIjs",text];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_5) AppleWebKit/537.71 (KHTML, like Gecko) Version/6.1 Safari/537.71" forHTTPHeaderField:@"User-Agent"];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",nil];
    AFHTTPRequestOperation *operation = [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Response= %@",responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}
@end
