//
//  AAMenuItem.h
//  AppWiz
//
//  Created by Shahid Akhtar Shaikh on 5/2/15.
//  Copyright (c) 2015 Shahid Akhtar Shaikh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AAMenuItem : NSObject
@property (nonatomic, strong) NSString *itemName;
@property (nonatomic) MenuItemType itemType;
@property (nonatomic) BOOL showArrow;
@property (nonatomic, strong) NSString *iconName;
@end
