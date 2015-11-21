//
//  AALoyalty.m
//  AppWiz
//
//  Created by Shahid Akhtar Shaikh on 2/1/14.
//  Copyright (c) 2014 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AALoyalty.h"

@implementation AALoyalty
NSInteger const MAX_COUPON_COUNT = 5;
@synthesize fbIconDisplay;
- (id)init
{
    self = [super init];
    if (self) {
        self.loyaltyImageUrlString = @"";
        self.facebookPageUrl = @"";
        self.termsCondtitions = @"";
        self.couponCount = 0;
        self.fbIconDisplay = @"";
        self.instagramDisplay = @"";
        
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    
    [encoder encodeObject:self.loyaltyImageUrlString forKey:@"loyaltyImageUrlString"];
    [encoder encodeObject:self.facebookPageUrl forKey:@"facebookPageUrl"];
    [encoder encodeObject:self.termsCondtitions forKey:@"termsCondtitions"];
    [encoder encodeObject:self.fbIconDisplay forKey:@"fbIconDisplay"];
    [encoder encodeObject:self.instagramDisplay forKey:@"instagramDisplay"];
    [encoder encodeObject:self.instagramUrl forKey:@"instagramUrl"];
    
    [encoder encodeObject:[NSNumber numberWithInteger:self.couponCount] forKey:@"couponCount"];
    
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        
        self.loyaltyImageUrlString = [decoder decodeObjectForKey:@"loyaltyImageUrlString"];
        
        self.facebookPageUrl = [decoder decodeObjectForKey:@"facebookPageUrl"];
        self.termsCondtitions = [decoder decodeObjectForKey:@"termsCondtitions"];
        self.couponCount = [[decoder decodeObjectForKey:@"couponCount"] integerValue];
        
        self.fbIconDisplay= [decoder decodeObjectForKey:@"fbIconDisplay"];
        self.instagramDisplay= [decoder decodeObjectForKey:@"instagramDisplay"];
        self.instagramUrl = [decoder decodeObjectForKey:@"instagramUrl"];
    }
    return self;
}

@end
