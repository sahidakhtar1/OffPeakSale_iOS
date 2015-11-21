//
//  AAEShopProductOptions.m
//  AppWiz
//
//  Created by Shaikh Shahid Akhtar on 30/12/14.
//  Copyright (c) 2014 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AAEShopProductOptions.h"

@implementation AAEShopProductOptions
- (id)init
{
    self = [super init];
    if (self) {
        self.optionLabel = @"";
        self.optionValue = @"";
    }
    return self;
}


- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.optionValue forKey:@"optionValue"];
    [encoder encodeObject:self.optionLabel forKey:@"optionLabel"];
    
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        self.optionLabel = [decoder decodeObjectForKey:@"optionLabel"];
        self.optionValue = [decoder decodeObjectForKey:@"optionValue"];
    }
    return self;
}
@end
