//
//  AACategoryDataModel.m
//  AppWiz
//
//  Created by Shahid Akhtar Shaikh on 5/11/15.
//  Copyright (c) 2015 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AACategoryDataModel.h"

@implementation AACategoryDataModel
- (id)init
{
    self = [super init];
    if (self) {
        self.categoryId = @"";
        self.categoryName = @"";
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.categoryId forKey:@"categoryId"];
    [encoder encodeObject:self.categoryName forKey:@"categoryName"];
    
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        self.categoryId = [decoder decodeObjectForKey:@"categoryId"];
        self.categoryName = [decoder decodeObjectForKey:@"categoryName"];
    }
    return self;
}
@end
