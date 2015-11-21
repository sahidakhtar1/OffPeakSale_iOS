//
//  AAHomePageHelper.m
//  Swensens
//
//  Created by Shahid Akhtar Shaikh on 21/12/13.
//  Copyright (c) 2013 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AAHomePageHelper.h"

@implementation AAHomePageHelper
+(UIView*)getImageViewWithFrame:(CGRect)frame wtihImageUrl : (NSURL*)imageUrl
{
    UIImageView* imvRetailer = [[UIImageView alloc] initWithFrame:frame];
    
    NSString *path = [imageUrl path];
    NSString *extension = [path pathExtension];
    if([extension.lowercaseString isEqualToString:@"gif"])
    {
        [imvRetailer setImageWithURL:imageUrl completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        }];
    }
    else
    {
        
        [imvRetailer setImageWithURL:imageUrl completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        }];
    }
    [imvRetailer setClipsToBounds:YES];
    [imvRetailer setContentMode:UIViewContentModeScaleAspectFill];
    
    return imvRetailer;
}

+(void)updateStoresMap:(AAMapView *)mapView
{
    
    for(AARetailerStores* retailerStore in [AAAppGlobals sharedInstance].retailer.stores)
    {
        NSString* content = [NSString stringWithFormat:@"%@\nContact : %@",retailerStore.storeAddress,retailerStore.storeContact];
        if (retailerStore.location.latitude == 0 || retailerStore.location.longitude == 0) {
            
        }else{
            GMSMarker* marker =   [mapView addMarkerWithTitle:[AAAppGlobals sharedInstance].retailer.retailerName andContent:content andCoordinate:retailerStore.location];
            [marker setIcon:[UIImage imageNamed:@"shoplocation"]];
            marker.userData = retailerStore;
        }
        
    
    }
   

}

@end
