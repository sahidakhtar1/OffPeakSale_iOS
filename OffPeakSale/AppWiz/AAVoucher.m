//
//  AAVoucher.m
//  AppWiz
//
//  Created by Shahid Akhtar Shaikh on 30/12/13.
//  Copyright (c) 2013 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AAVoucher.h"

@implementation AAVoucher
NSString* VOUCHER_FILE_TYPE_IMAGE = @"Image";
NSString* VOUCHER_FILE_TYPE_VIDEO = @"Video";
- (id)init
{
    self = [super init];
    if (self) {
       self.voucherFileUrl = @"";
        self.voucherFileType = @"";
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    
    
    [encoder encodeObject:self.voucherFileUrl forKey:@"voucherFileUrl"];
  [encoder encodeObject:self.voucherFileType forKey:@"voucherFileType"];
    [encoder encodeObject:self.pid forKey:@"pid"];
    
    
    
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
       
        if([decoder decodeObjectForKey:@"voucherFileType"])
        self.voucherFileType = [decoder decodeObjectForKey:@"voucherFileType"];
        if([decoder decodeObjectForKey:@"voucherFileUrl"])
        self.voucherFileUrl = [decoder decodeObjectForKey:@"voucherFileUrl"];
        if([decoder decodeObjectForKey:@"pid"])
            self.pid = [decoder decodeObjectForKey:@"pid"];
       
        
    }
    return self;
}

@end
