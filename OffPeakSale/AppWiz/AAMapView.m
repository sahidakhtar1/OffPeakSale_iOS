//
//  AAMapView.m
//  AppWiz
//
//  Created by Shahid Akhtar Shaikh on 25/12/13.
//  Copyright (c) 2013 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AAMapView.h"
#import "AAStoreInfoWindow.h"
@implementation AAMapView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpViews];
    }
    return self;
}


-(void)setUpViews
{
    self.markersArray = [[NSMutableArray alloc] init];
//    self.mapView = [[GMSMapView alloc] initWithFrame:self.bounds];
//    self.coordinateBounds =  [[GMSCoordinateBounds alloc] init];
//    self.markerCurrentLocation = [[GMSMarker alloc] init];
//    [self.mapView setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth ];
//    [self addSubview:self.mapView];
    
    self.coordinateBounds =  [[GMSCoordinateBounds alloc] init];
    self.markerCurrentLocation = [[GMSMarker alloc] init];
    CLLocationCoordinate2D coordinates =  [AAAppGlobals sharedInstance].locationHandler.currentLocation.coordinate ;
    GMSCameraPosition *camera =
    [GMSCameraPosition cameraWithLatitude:coordinates.latitude
                                longitude:coordinates.latitude
                                     zoom:17.5
                                  bearing:30
                             viewingAngle:40];
    float mapHeight = [UIScreen mainScreen].bounds.size.height - 64;
    self.mapView = [GMSMapView mapWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) camera:camera];
    self.mapView.delegate = self;
    [self addSubview:self.mapView];
    [self setBackgroundColor:[UIColor clearColor]];
    
}
-(void)addMarkerWithTitle:(NSString*)title
                  address:(NSString*)address
               andConatct:(NSString*)contact
                    atLat:(NSString *)lat
                      lng:(NSString*)lng{
    NSString* content = [NSString stringWithFormat:@"%@\n%@",address,contact];
    if (lat == nil || lng == nil) {
        
    }else{
        AARetailerStores *retailerStore = [[AARetailerStores alloc] init];
        retailerStore.storeAddress = address;
        retailerStore.storeContact = contact;
        retailerStore.name = title;
        retailerStore.location = CLLocationCoordinate2DMake([lat doubleValue], [lng doubleValue]);
        GMSMarker* marker =   [self addMarkerWithTitle:title andContent:content andCoordinate:retailerStore.location];
        [marker setIcon:[UIImage imageNamed:@"shoplocation"]];
        marker.userData = retailerStore;
        [self.mapView setSelectedMarker:marker];
        [self addMarker:marker];
    }
    [self fitMapToMarkers];
}

-(GMSMarker*)addMarkerWithTitle : (NSString*)title andContent:(NSString*)content andCoordinate : (CLLocationCoordinate2D) coordinate
{
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = coordinate;
    marker.title = title;
    marker.snippet = content;
    marker.appearAnimation = NO;
    [self.markersArray addObject:marker];
    marker.map = self.mapView;
   
   
    self.coordinateBounds = [self.coordinateBounds includingCoordinate:marker.position];
    return marker;
    
    
}

-(void)addMarker:(GMSMarker*)marker
{
     [self.markersArray addObject:marker];
    marker.map = self.mapView;
   
    self.coordinateBounds = [self.coordinateBounds includingCoordinate:marker.position];
}

-(void)removeAllMarkers
{
    [self.mapView clear];
    [self.markersArray removeAllObjects];
    self.coordinateBounds = [[GMSCoordinateBounds alloc] init];
}

-(void)fitMapToMarkers
{
    if([self.markersArray count]==0)
    {
        return;
    }
    else
    {
        GMSCameraUpdate *update = [GMSCameraUpdate fitBounds:self.coordinateBounds withPadding:100.0f];
        [self.mapView animateWithCameraUpdate:update];
        [self.mapView animateToBearing:30];
        [self.mapView animateToViewingAngle:40];
    }

}

-(void)addCurrentLocationMarkerWithCoordinate:(CLLocationCoordinate2D)coordinate withTitle:(NSString *)title andIcon : (UIImage*)icon
{
    self.markerCurrentLocation.position = coordinate;
     self.markerCurrentLocation.title = title;
    self.markerCurrentLocation.snippet = @"";
    self.markerCurrentLocation.icon = icon;
     self.markerCurrentLocation.appearAnimation = NO;
     self.markerCurrentLocation.map = self.mapView;
    [self.markersArray addObject: self.markerCurrentLocation];
    [self.markerCurrentLocation setIcon:[UIImage imageNamed:@"customerlocation"]];
    
    self.coordinateBounds = [self.coordinateBounds includingCoordinate: self.markerCurrentLocation.position];
}

-(void)updateCurrentLocationMarkerCoordinate:(CLLocationCoordinate2D)coordinate
{
    self.markerCurrentLocation.position = coordinate;
  
}
-(UIView *)mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker
{
    
    if((marker!=self.currentLocationMarker)&&(marker!=self.markerCurrentLocation))
    {
        AAStoreInfoWindow* storeInfoWindow = [[[NSBundle mainBundle] loadNibNamed:@"AAStoreInfoWindow" owner:self options:nil] objectAtIndex:0];
        AARetailerStores* retailerStore =  marker.userData;
        storeInfoWindow.lblStoreContactNumber.text = retailerStore.storeContact;
        storeInfoWindow.lblStoreAddress.text = [NSString stringWithFormat:@"\n%@\n",retailerStore.storeAddress ];
        storeInfoWindow.lblStoreName.text = retailerStore.name;
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
    if(marker!=self.markerCurrentLocation)
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
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        if (alertView.tag == 121 && buttonIndex == 1)
        {
            //code for opening settings app in iOS 8
            [[UIApplication sharedApplication] openURL:[NSURL  URLWithString:UIApplicationOpenSettingsURLString]];
        }
    }
}
-(void)setStores:(NSArray *)stores{
    _stores = stores;
    [self updateStoresMap:nil];
}
-(void)updateStoresMap:(AAMapView *)mapView
{
    
    for(AARetailerStores* retailerStore in self.stores)
    {
        NSString* content = [NSString stringWithFormat:@"%@\n\n%@",retailerStore.storeAddress,retailerStore.storeContact];
        if (retailerStore.location.latitude == 0 || retailerStore.location.longitude == 0) {
            
        }else{
            GMSMarker* marker =   [self addMarkerWithTitle:self.storeName andContent:content andCoordinate:retailerStore.location];
            [marker setIcon:[UIImage imageNamed:@"shoplocation"]];
            marker.userData = retailerStore;
        }
        
        
    }
    
    
}
@end
