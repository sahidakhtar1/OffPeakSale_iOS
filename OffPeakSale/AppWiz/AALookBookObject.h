//
//  AALookBookObject.h
//  AppWiz
//
//  Created by Shahid Akhtar Shaikh on 10/16/15.
//  Copyright (c) 2015 Vignesh Badrinath Krishna. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AALookBookObject : NSObject
@property (nonatomic, copy) NSString *itemId;
@property (nonatomic, copy) NSString *imgUrl;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *caption;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *likesCnt;
@end
