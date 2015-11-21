//
//  AALookBookResponseObject.m
//  AppWiz
//
//  Created by Shahid Akhtar Shaikh on 10/16/15.
//  Copyright (c) 2015 Vignesh Badrinath Krishna. All rights reserved.
//

#import "AALookBookResponseObject.h"

@implementation AALookBookResponseObject
- (id)init
{
    self = [super init];
    if (self) {
        
        self.lookBookItems = [[NSMutableArray alloc] init];
        
    }
    return self;
}
- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.lookBookItems forKey:@"lookBookItems"];
    
}
- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        self.lookBookItems = [decoder decodeObjectForKey:@"lookBookItems"];
        
    }
    return self;
}
@end
