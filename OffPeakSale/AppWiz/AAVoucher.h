//
//  AAVoucher.h
//  AppWiz
//
//  Created by Shahid Akhtar Shaikh on 30/12/13.
//  Copyright (c) 2013 Shahid Akhtar Shaikh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AAVoucher : NSObject
extern NSString* VOUCHER_FILE_TYPE_IMAGE;
extern NSString* VOUCHER_FILE_TYPE_VIDEO;
@property (nonatomic,strong) NSString* voucherFileUrl;
@property (nonatomic,strong) NSString* voucherFileType;
@property (nonatomic,strong) NSString* pid;
@end
