//
//  AAEShopHelper.h
//  Swensens
//
//  Created by Shahid Akhtar Shaikh on 16/12/13.
//  Copyright (c) 2013 Shahid Akhtar Shaikh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AAEshopCategory.h"
@interface AAEShopHelper : NSObject
+(void)refreshEshopInformationForCategory:(NSString*)cid
                               searchText:(NSString*)keyword
                                   sortBy:(NSString*)sortBy
                                   forLat:(NSString*)latitude
                                  andLong:(NSString*)longitude
                     WithCompletionBlock : (void(^)(void))success;
+(void)getEshopProductDetail:(NSString*)productId
        WithCompletionBlock : (void(^)(AAEShopProduct*))success;

@end
