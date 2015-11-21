//
//  AAVoucherList.h
//  AppWiz
//
//  Created by Shahid Akhtar Shaikh on 9/1/14.
//  Copyright (c) 2014 Shahid Akhtar Shaikh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AAVoucher.h"
@interface AAVoucherList : NSObject
{
    NSMutableArray* arrVouchers;
}
-(void)addVoucher : (AAVoucher*)voucher;
-(BOOL)doesVoucherExistWithURl : (NSString*)imageUrl;
-(void)removeVoucherWithURL:(NSString*)imageURL;
-(NSMutableArray*)getVouchers;
-(void)removeVoucherAtIndex:(int)index;
@end
