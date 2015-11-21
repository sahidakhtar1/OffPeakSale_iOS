//
//  AAFeedback.m
//  AppWiz
//
//  Created by Shahid Akhtar Shaikh on 1/1/14.
//  Copyright (c) 2014 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AAFeedback.h"

@implementation AAFeedback
- (id)init
{
    self = [super init];
    if (self) {
        self.feedBackGiftUrlString = @"";
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    
    
    [encoder encodeObject:self.feedBackGiftUrlString forKey:@"feedBackGiftUrlString"];
    [encoder encodeObject:self.feedbackOption1 forKey:@"feedbackOption1"];
    [encoder encodeObject:self.feedbackOption2 forKey:@"feedbackOption2"];
    [encoder encodeObject:self.feedbackOption3 forKey:@"feedbackOption3"];
    
    
    
    
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        
        self.feedBackGiftUrlString = [decoder decodeObjectForKey:@"feedBackGiftUrlString"];
        self.feedbackOption1 = [decoder decodeObjectForKey:@"feedbackOption1"];
        self.feedbackOption2 = [decoder decodeObjectForKey:@"feedbackOption2"];
        self.feedbackOption3 = [decoder decodeObjectForKey:@"feedbackOption3"];
        
        
        
        
    }
    return self;
}

@end
