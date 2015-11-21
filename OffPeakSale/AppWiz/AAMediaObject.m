//
//  AAMediaObject.m
//  AppWiz
//
//  Created by Shaikh Shahid Akhtar on 30/12/14.
//  Copyright (c) 2014 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AAMediaObject.h"

@implementation AAMediaObject
- (id)init
{
    self = [super init];
    if (self) {
        self.filePath = @"";
        self.fileType = @"";
    }
    return self;
}


- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.fileType forKey:@"fileType"];
    [encoder encodeObject:self.filePath forKey:@"filePath"];
    
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        self.filePath = [decoder decodeObjectForKey:@"filePath"];
        self.fileType = [decoder decodeObjectForKey:@"fileType"];
    }
    return self;
}
@end
