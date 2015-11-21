//
//  AALookBookObject.m
//  AppWiz
//
//  Created by Shahid Akhtar Shaikh on 10/16/15.
//  Copyright (c) 2015 Vignesh Badrinath Krishna. All rights reserved.
//

#import "AALookBookObject.h"

@implementation AALookBookObject
- (id)init
{
    self = [super init];
    if (self) {
                
    }
    return self;
}
- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.itemId forKey:@"itemId"];
    [encoder encodeObject:self.imgUrl forKey:@"imgUrl"];
    [encoder encodeObject:self.title forKey:@"title"];
    [encoder encodeObject:self.caption forKey:@"caption"];
    [encoder encodeObject:self.desc forKey:@"desc"];
    [encoder encodeObject:self.likesCnt forKey:@"likesCnt"];
}
- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        self.itemId = [decoder decodeObjectForKey:@"itemId"];
        self.imgUrl = [decoder decodeObjectForKey:@"imgUrl"];
        self.title = [decoder decodeObjectForKey:@"title"];
        self.caption = [decoder decodeObjectForKey:@"caption"];
        self.desc = [decoder decodeObjectForKey:@"desc"];
        self.likesCnt = [decoder decodeObjectForKey:@"likesCnt"];
    }
    return self;
}
@end
