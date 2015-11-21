//
//  AAMediaItem.m
//  AppWiz
//
//  Created by Shaikh Shahid Akhtar on 27/11/14.
//  Copyright (c) 2014 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AAMediaItem.h"

@implementation AAMediaItem

- (id)init
{
    self = [super init];
    if (self) {
        self.mediaUrl = @"";
        self.mediaType = @"";
    }
    return self;
}


- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.mediaType forKey:@"mediaType"];
    [encoder encodeObject:self.mediaUrl forKey:@"mediaUrl"];
    
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        self.mediaUrl = [decoder decodeObjectForKey:@"mediaUrl"];
        self.mediaType = [decoder decodeObjectForKey:@"mediaType"];
    }
    return self;
}
@end
