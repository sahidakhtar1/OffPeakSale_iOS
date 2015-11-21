//
//  AAEarliestSchedule.h
//  AppWiz
//
//  Created by Shahid Akhtar Shaikh on 10/4/15.
//  Copyright (c) 2015 Shahid Akhtar Shaikh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AAEarliestSchedule : NSObject
@property (nonatomic,retain) NSString* earliestDate;
@property (nonatomic,retain) NSMutableArray* possibleTimeSlots;
@end
