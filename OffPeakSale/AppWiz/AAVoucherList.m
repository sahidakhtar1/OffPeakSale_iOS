//
//  AAVoucherList.m
//  AppWiz
//
//  Created by Shahid Akhtar Shaikh on 9/1/14.
//  Copyright (c) 2014 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AAVoucherList.h"

@implementation AAVoucherList
- (id)init
{
    self = [super init];
    if (self) {
        arrVouchers = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)addVoucher : (AAVoucher*)voucher
{
    [arrVouchers insertObject:voucher atIndex:0];
}

-(BOOL)doesVoucherExistWithURl : (NSString*)fileUrl
{
    
        NSArray *fileUrls = [arrVouchers valueForKey:@"voucherFileUrl"];
        
        for(NSString* voucherFileUrl in fileUrls)
        {
            if([voucherFileUrl isEqualToString:fileUrl])
            {
                return YES;
            }
        }
        return NO;
    
}

-(void)removeVoucherWithURL:(NSString*)fileURL
{
    NSMutableIndexSet* indexesToRemove = [[NSMutableIndexSet alloc]init];
    for(AAVoucher* voucher in arrVouchers)
    {
        if([voucher.voucherFileUrl isEqualToString:fileURL])
        {
            [indexesToRemove addIndex:[arrVouchers indexOfObject:voucher]];
        }
    }
    [arrVouchers removeObjectsAtIndexes:indexesToRemove];
}
-(void)removeVoucherAtIndex:(int)index
{
    if (index<[arrVouchers count]) {
        [arrVouchers removeObjectAtIndex:index];
    }
    
}
-(NSMutableArray*)getVouchers
{
    return arrVouchers.mutableCopy;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    
    
    [encoder encodeObject:arrVouchers forKey:@"arrVouchers"];
    
    
    
    
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        
        arrVouchers = [decoder decodeObjectForKey:@"arrVouchers"];
        
        
        
        
    }
    return self;
}
@end
