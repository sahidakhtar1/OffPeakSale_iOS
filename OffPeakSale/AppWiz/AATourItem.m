//
//  AATourItem.m
//  AppWiz
//
//  Created by Shahid Akhtar Shaikh on 12/4/15.
//  Copyright © 2015 Shaikh Shahid Akhtar. All rights reserved.
//

#import "AATourItem.h"

@implementation AATourItem
- (id)init
{
    self = [super init];
    if (self) {
        self.imageUrl = @"";
        self.headerTitle = @"";
        self.desc = @"";
    }
    return self;
}
- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.imageUrl forKey:@"imageUrl"];
    [encoder encodeObject:self.headerTitle forKey:@"headerTitle"];
    [encoder encodeObject:self.desc forKey:@"desc"];
    
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        self.imageUrl = [decoder decodeObjectForKey:@"imageUrl"];
        self.headerTitle = [decoder decodeObjectForKey:@"headerTitle"];
        self.desc = [decoder decodeObjectForKey:@"desc"];
    }
    return self;
}
+(AATourItem*)createTourItemFrom:(NSDictionary*)dict{
    AATourItem *tourItem = [[AATourItem alloc] init];
    tourItem.imageUrl = [dict valueForKey:@"imageUrl"];
    tourItem.headerTitle = [dict valueForKey:@"headerTitle"];
    tourItem.desc = [dict valueForKey:@"description"];
    return tourItem;
}
@end
