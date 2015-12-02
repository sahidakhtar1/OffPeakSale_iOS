//
//  AARetailerStoreMapViewController.m
//  Swensens
//
//  Created by Shahid Akhtar Shaikh on 22/12/13.
//  Copyright (c) 2013 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AARetailerStoreMapViewController.h"
#import "AAHeaderView.h"
#import "UIViewController+AAShakeGestuew.h"
@interface AARetailerStoreMapViewController ()

@end

@implementation AARetailerStoreMapViewController
static NSInteger const PADDING = 10;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [AAStyleHelper addLightShadowToView:self.viewStoreMapContainer];
	// Do any additional setup after loading the view.
    [self addRetailerStoreMapView];
    //[self updateUserLocation];
//    AAHeaderView *headerView = [[AAHeaderView alloc] initWithFrame:self.vwHeaderView.frame];
//    [self.vwHeaderView addSubview:headerView];
//    [headerView setTitle:@"Locate Us"];
//    headerView.showCart = false;
//    headerView.showBack = false;
//    headerView.delegate = self;
//    [headerView setMenuIcons];
    
}

-(void)getCurrentLocation{
    if([CLLocationManager locationServicesEnabled])
    {
        if (nil == self.locationManager)
            self.locationManager = [[CLLocationManager alloc] init];
        
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        
        // self.locationManager.distanceFilter = 100;
        
        // Set a movement threshold for new events.
        //self.locationManager.distanceFilter = 1000; // meters
        if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [self.locationManager requestWhenInUseAuthorization];
        }
        
        [self.locationManager startUpdatingLocation];
        NSLog(@"location updated started");
    }else{
        [self showAlert];
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        if (alertView.tag == 121 && buttonIndex == 1)
        {
            //code for opening settings app in iOS 8
            [[UIApplication sharedApplication] openURL:[NSURL  URLWithString:UIApplicationOpenSettingsURLString]];
        }
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self cat_viewDidAppear:YES];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationUpdated:) name:NOTIFICATION_LOCATION_UPDATED object:nil];
    

    id<AAChildNavigationControllerDelegate> nvcHome = (id<AAChildNavigationControllerDelegate>) self.navigationController;
//    [nvcHome showBackButtonView];
//    [self getCurrentLocation];

}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_LOCATION_UPDATED object:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addRetailerStoreMapView
{
//    NSLog(@"Contaner Frame = %@",NSStringFromCGRect(self.viewStoreMapContainer.frame));
//    CGRect frame = CGRectMake(PADDING, PADDING, self.viewStoreMapContainer.frame.size.width - 2*PADDING, self.viewStoreMapContainer.frame.size.height - 2*PADDING);
//     NSLog(@"map Frame = %@",NSStringFromCGRect(frame));
    self.mvRetailerStores = [[AAMapView alloc] initWithFrame:CGRectMake(PADDING, PADDING, self.view.frame.size.width - 2*PADDING, self.view.frame.size.height )];
    self.mvRetailerStores.mapView.delegate = self;
    [self.mvRetailerStores.mapView.settings setConsumesGesturesInView:NO];
   [AAHomePageHelper updateStoresMap:self.mvRetailerStores];
    

    if (self.currentLocationMarker)
    {
        
         [self.mvRetailerStores addMarker:self.currentLocationMarker];
        self.mvRetailerStores.markerCurrentLocation = self.currentLocationMarker;
        [self.mvRetailerStores.mapView setSelectedMarker:self.currentLocationMarker];
        GMSCameraPosition *camera =
        [GMSCameraPosition cameraWithLatitude:self.currentLocationMarker.position.latitude
                                    longitude:self.currentLocationMarker.position.latitude
                                         zoom:17.5
                                      bearing:30
                                 viewingAngle:40];
        GMSCameraUpdate *markerCam = [GMSCameraUpdate setCamera:camera];

        [self.mvRetailerStores.mapView animateWithCameraUpdate:markerCam];
      
        

        
    }
    else if (self.selectedRetailerMarker)
    {
        [self.mvRetailerStores addMarker:self.selectedRetailerMarker];
    [self.mvRetailerStores.mapView setSelectedMarker:self.selectedRetailerMarker];
        GMSCameraPosition *camera =
        [GMSCameraPosition cameraWithLatitude:self.selectedRetailerMarker.position.latitude
                                    longitude:self.selectedRetailerMarker.position.latitude
                                         zoom:17.5
                                      bearing:30
                                 viewingAngle:40];
        GMSCameraUpdate *markerCam = [GMSCameraUpdate setCamera:camera];
        [self.mvRetailerStores.mapView animateWithCameraUpdate:markerCam];

    }

    [ self.mvRetailerStores setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight ];
    
    
   
    [self.viewStoreMapContainer addSubview:self.mvRetailerStores];
    [self.mvRetailerStores fitMapToMarkers];
    
}
- (void)updateUserLocation
{
    if(!self.mvRetailerStores.markerCurrentLocation.map)
    {
        if([AAAppGlobals sharedInstance].locationHandler.currentLocation)
        {
            [self.mvRetailerStores addCurrentLocationMarkerWithCoordinate:[AAAppGlobals sharedInstance].locationHandler.currentLocation.coordinate withTitle:@"My Location" andIcon:[UIImage imageNamed:@"current_location_marker"]];
        }
        
    }
    else
    {
        if([AAAppGlobals sharedInstance].locationHandler.currentLocation)
        {
            [self.mvRetailerStores updateCurrentLocationMarkerCoordinate:[AAAppGlobals sharedInstance].locationHandler.currentLocation.coordinate];
        }
    }
    [self.mvRetailerStores fitMapToMarkers];
}
-(UIView *)mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker
{
    
   if((marker!=self.currentLocationMarker)&&(marker!=self.mvRetailerStores.markerCurrentLocation))
    {
    AAStoreInfoWindow* storeInfoWindow = [[[NSBundle mainBundle] loadNibNamed:@"AAStoreInfoWindow" owner:self options:nil] objectAtIndex:0];
        AARetailerStores* retailerStore =  marker.userData;
        storeInfoWindow.lblStoreContactNumber.text = retailerStore.storeContact;
    storeInfoWindow.lblStoreAddress.text = [NSString stringWithFormat:@"\n%@\n",retailerStore.storeAddress ];
    storeInfoWindow.lblStoreName.text = [AAAppGlobals sharedInstance].retailer.retailerName;
        [storeInfoWindow updateContainerSize:mapView.frame.size.width];
        self.phoneNumberTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(phoneNumberTap:)];
        self.phoneNumberTap.numberOfTapsRequired = 1;
        self.phoneNumberTap.delegate = self;
        [storeInfoWindow.containerView addGestureRecognizer:self.phoneNumberTap];
    return storeInfoWindow;
    }
    return nil;
}
-(void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker
{
    if(marker!=self.mvRetailerStores.markerCurrentLocation)
    {
         AARetailerStores* retailerStore = (AARetailerStores*)marker.userData;
        NSString *number = [retailerStore.storeContact stringByReplacingOccurrencesOfString:@" " withString:@""];
         NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"telprompt:%@",number]];
        
         NSURL *testUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"tel:%@",number]];
         if ([[UIApplication sharedApplication] canOpenURL:testUrl]) {
         [[UIApplication sharedApplication] openURL:phoneUrl];
         } else
         {
         UIAlertView* calert = [[UIAlertView alloc]initWithTitle:@"Unable to call" message:@"Cannot call on this device." delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
         [calert show];
         }
    }

}
-(void)phoneNumberTap:(UITapGestureRecognizer*)gestureRecognizier
{
   /* AAStoreInfoWindow* infoWindow = (AAStoreInfoWindow*)gestureRecognizier.view;
    NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"telprompt:%@",infoWindow.lblStoreContactNumber.text]];
    
    if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
        [[UIApplication sharedApplication] openURL:phoneUrl];
    } else
    {
        UIAlertView* calert = [[UIAlertView alloc]initWithTitle:@"Unable to call" message:@"Call feature is not available on this device." delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [calert show];
    }*/

}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return YES;
}

//- (void)updateUserLocation
//{
//    if(!self.mvRetailerStores.markerCurrentLocation.map)
//    {
//        [self.mvRetailerStores addCurrentLocationMarkerWithCoordinate:[AAAppGlobals sharedInstance].locationHandler.currentLocation.coordinate withTitle:@"My Location" andIcon:[UIImage imageNamed:@"current_location_marker"]];
//        
//    }
//    else
//    {
//        [self.mvRetailerStores updateCurrentLocationMarkerCoordinate:[AAAppGlobals sharedInstance].locationHandler.currentLocation.coordinate];
//    }
//    
//}
-(void)locationUpdated:(NSNotification*)notification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        
//        [self updateUserLocation];
        
    });
}
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"location updated faild = %@",error);
    if ([error domain] == kCLErrorDomain) {
        
        // We handle CoreLocation-related errors here
        switch ([error code]) {
                // "Don't Allow" on two successive app launches is the same as saying "never allow". The user
                // can reset this for all apps by going to Settings > General > Reset > Reset Location Warnings.
            case kCLErrorDenied:
            {
                [self showAlert];
                [self.locationManager stopUpdatingLocation];
                self.locationManager.delegate = nil;
                break;
            }
                
            case kCLErrorLocationUnknown:
                
            default:
                break;
        }
    } else {
        // We handle all non-CoreLocation errors here
    }
    
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = [locations lastObject];
    [AAAppGlobals sharedInstance].locationHandler.currentLocation = location;
    [self.locationManager stopUpdatingLocation];
    self.locationManager.delegate = nil;
    NSLog(@"==================");
    NSLog(@"location updated");
    NSLog(@"==================");
    [self updateUserLocation];
}
-(void)showAlert{
    if([[[UIDevice currentDevice] systemVersion] floatValue]<8.0)
    {
        UIAlertView* curr1=[[UIAlertView alloc] initWithTitle:@"This app does not have access to Location service" message:@"You can enable access in Settings->Privacy->Location->Location Services" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [curr1 show];
    }
    else
    {
        UIAlertView* curr2=[[UIAlertView alloc] initWithTitle:@"Information" message:@"Enable location services" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Enable", nil];
        curr2.tag=121;
        [curr2 show];
    }
    
}
@end
