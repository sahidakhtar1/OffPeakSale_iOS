//
//  AAFeaturedStoreObject.m
//  AppWiz
//
//  Created by Shahid Akhtar Shaikh on 5/5/15.
//  Copyright (c) 2015 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AAFeaturedStoreObject.h"

@implementation AAFeaturedStoreObject
- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.storeName forKey:@"storeName"];
    [encoder encodeObject:self.storeUrl forKey:@"storeUrl"];
}
- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        self.storeName = [decoder decodeObjectForKey:@"storeName"];
        self.storeUrl = [decoder decodeObjectForKey:@"storeUrl"];
    }
    return self;
}
@end
