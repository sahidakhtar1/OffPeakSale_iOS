//
//  AARetailerStores.m
//  Swensens
//
//  Created by Shahid Akhtar Shaikh on 17/12/13.
//  Copyright (c) 2013 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AARetailerStores.h"

@implementation AARetailerStores
- (id)init
{
    self = [super init];
    if (self) {
        self.storeAddress = @"";
        self.storeContact = @"";
        self.location = kCLLocationCoordinate2DInvalid;
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    
    
    [encoder encodeObject:self.storeAddress forKey:@"storeAddress"];
    [encoder encodeObject:self.storeContact forKey:@"storeContact"];
    NSNumber *lat = [NSNumber numberWithDouble:self.location.latitude];
    NSNumber *lon = [NSNumber numberWithDouble:self.location.longitude];
    [encoder encodeObject:lat forKey:@"latitude"];
     [encoder encodeObject:lon forKey:@"longitude"];
    [encoder encodeObject:self.name forKey:@"name"];
    
    
    
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        self.storeAddress = [decoder decodeObjectForKey:@"storeAddress"];
        self.storeContact =[decoder decodeObjectForKey:@"storeContact"];
        NSNumber *lat = [decoder decodeObjectForKey:@"latitude"];
        NSNumber *lon = [decoder decodeObjectForKey:@"longitude"];
        self.name = [decoder decodeObjectForKey:@"name"];
        
        self.location  = CLLocationCoordinate2DMake([lat doubleValue],[lon doubleValue]);
      
        
    }
    return self;
}


@end
