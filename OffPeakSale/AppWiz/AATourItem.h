//
//  AATourItem.h
//  AppWiz
//
//  Created by Shahid Akhtar Shaikh on 12/4/15.
//  Copyright © 2015 Shaikh Shahid Akhtar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AATourItem : NSObject
@property (nonatomic,strong) NSString *imageUrl;
@property (nonatomic,strong) NSString *headerTitle;
@property (nonatomic,strong) NSString *desc;
+(AATourItem*)createTourItemFrom:(NSDictionary*)dict;
@end
