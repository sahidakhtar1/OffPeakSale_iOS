//
//  AAHomePageHelper.h
//  Swensens
//
//  Created by Shahid Akhtar Shaikh on 21/12/13.
//  Copyright (c) 2013 Shahid Akhtar Shaikh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AARetailer.h"
#import <GoogleMaps/GoogleMaps.h>
#import "UIImageView+WebCache.h"
#import "AAMapView.h"
@interface AAHomePageHelper : NSObject
+(void)updateStoresMap : (AAMapView*)mapView;
+(UIView*)getImageViewWithFrame:(CGRect)frame wtihImageUrl : (NSURL*)imageUrl;
@end
