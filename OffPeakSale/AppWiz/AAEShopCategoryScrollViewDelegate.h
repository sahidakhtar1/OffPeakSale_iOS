//
//  AAEShopCategoryScrollViewDelegate.h
//  Swensens
//
//  Created by Shahid Akhtar Shaikh on 17/12/13.
//  Copyright (c) 2013 Shahid Akhtar Shaikh. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AAEShopCategoryScrollViewDelegate <NSObject>
-(void)onCategeorySelected : (NSString*)categoryName;
@end
