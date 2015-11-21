//
//  AAMapView.m
//  AppWiz
//
//  Created by Shahid Akhtar Shaikh on 25/12/13.
//  Copyright (c) 2013 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AAMapView.h"

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
    [self addSubview:self.mapView];
    
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
//    else if([self.markersArray count]==1)
//    {
////        GMSMarker* marker = [self.markersArray objectAtIndex:0];
////         GMSCameraUpdate *markerCam = [GMSCameraUpdate setTarget:marker.position zoom:12];
////        [self.mapView animateWithCameraUpdate:markerCam];
//        
//        GMSMarker* marker = [self.markersArray objectAtIndex:0];
//        GMSCameraPosition *camera =
//        [GMSCameraPosition cameraWithLatitude:marker.position.latitude
//                                    longitude:marker.position.latitude
//                                         zoom:17.5
//                                      bearing:30
//                                 viewingAngle:40];
//        GMSCameraUpdate *markerCam = [GMSCameraUpdate setCamera:camera];
//        [self.mapView animateToCameraPosition:camera];
////        [self.mapView animateToBearing:30];
////        [self.mapView animateToViewingAngle:40];
//    }
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


@end
