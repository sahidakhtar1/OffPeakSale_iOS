//
//  AADatePickerView.h
//  Swensens
//
//  Created by Shahid Akhtar Shaikh on 20/12/13.
//  Copyright (c) 2013 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AABasePopupView.h"
#import "AADatePickerViewDelegate.h"
@interface AADatePickerView : AABasePopupView

//Creates and return a date picker view given a background frame.
+(AADatePickerView*)createDatePickerViewWithBackgroundFrameRect : (CGRect)backgroundFrameRect;

@property (nonatomic,strong) UIDatePicker* datePicker;
@property (nonatomic,weak) id<AADatePickerViewDelegate> datePickerDelegate;

//set the current date for the date picker
-(void)setDatepickerDate:(NSDate *)date;
@end
