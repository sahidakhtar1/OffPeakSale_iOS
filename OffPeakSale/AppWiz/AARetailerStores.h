//
//  AARetailerStores.h
//  Swensens
//
//  Created by Shahid Akhtar Shaikh on 17/12/13.
//  Copyright (c) 2013 Shahid Akhtar Shaikh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
@interface AARetailerStores : NSObject
@property (nonatomic,copy) NSString* name;
@property (nonatomic,copy) NSString* storeAddress;
@property (nonatomic,copy) NSString* storeContact;
@property (nonatomic) CLLocationCoordinate2D location;
+(AARetailerStores*)retailStoreFromDict:(NSDictionary*)dict;
@end
