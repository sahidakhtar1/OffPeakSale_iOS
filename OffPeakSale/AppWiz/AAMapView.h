//
//  AAMapView.h
//  AppWiz
//
//  Created by Shahid Akhtar Shaikh on 25/12/13.
//  Copyright (c) 2013 Shahid Akhtar Shaikh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GoogleMaps/GoogleMaps.h>
@interface AAMapView : UIView<GMSMapViewDelegate>

@property (nonatomic,strong) GMSCoordinateBounds* coordinateBounds;
@property (nonatomic,strong) NSMutableArray* markersArray;
@property (nonatomic,strong) GMSMapView* mapView;
@property (nonatomic,strong) GMSMarker* markerCurrentLocation;
@property (nonatomic, strong) GMSMarker* markerTargetLocation;
@property (nonatomic,strong) GMSMarker* selectedRetailerMarker;
@property (nonatomic,strong) GMSMarker* currentLocationMarker;
@property (nonatomic,strong) UITapGestureRecognizer* phoneNumberTap;
@property (nonatomic, strong) NSArray *stores;
@property (nonatomic,strong) NSString *storeName;
//Fits all markers into the map view
-(void)fitMapToMarkers;

//Creates and adds a marker onto map given its coordinate,title and content
-(GMSMarker*)addMarkerWithTitle : (NSString*)title andContent:(NSString*)content andCoordinate : (CLLocationCoordinate2D) coordinate;

//Adds a marker onto the map given a marker
-(void)addMarker:(GMSMarker*)marker;

//Adds a special marker for the user's current location give the coordinate,title and icon
-(void)addCurrentLocationMarkerWithCoordinate:(CLLocationCoordinate2D)coordinate withTitle:(NSString *)title andIcon : (UIImage*)icon;
-(void)addTargetLocationMarker;

//Update the current location marker given a coordinate
-(void)updateCurrentLocationMarkerCoordinate: (CLLocationCoordinate2D) coordinate;

//Removes all the markers from the map
-(void)removeAllMarkers;
-(void)addMarkerWithTitle:(NSString*)title
                  address:(NSString*)address
               andConatct:(NSString*)contact
                    atLat:(NSString *)lat
                      lng:(NSString*)lng;
@end
