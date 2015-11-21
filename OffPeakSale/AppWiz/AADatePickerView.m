//
//  AADatePickerView.m
//  Swensens
//
//  Created by Shahid Akhtar Shaikh on 20/12/13.
//  Copyright (c) 2013 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AADatePickerView.h"

@implementation AADatePickerView

CGFloat const DATE_PICKER_HEIGHT = 216;
CGFloat const TOOLBAR_HEIGHT = 44;



+(AADatePickerView*)createDatePickerViewWithBackgroundFrameRect : (CGRect)backgroundFrameRect
{
    
    AADatePickerView* datePickerView = [[AADatePickerView alloc] initWithBackgroundFrame:backgroundFrameRect andContentFrame:CGRectMake(0, backgroundFrameRect.size.height - DATE_PICKER_HEIGHT-TOOLBAR_HEIGHT, backgroundFrameRect.size.width, DATE_PICKER_HEIGHT + TOOLBAR_HEIGHT)];
    
    datePickerView.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, (backgroundFrameRect.size.height - DATE_PICKER_HEIGHT), backgroundFrameRect.size.width, DATE_PICKER_HEIGHT)];
    [datePickerView.datePicker setDatePickerMode:UIDatePickerModeDate];
    [datePickerView addSubview:datePickerView.datePicker];
    
    UIToolbar* toolbarDate = [[UIToolbar alloc] initWithFrame:CGRectMake(0,(backgroundFrameRect.size.height-datePickerView.datePicker.frame.size.height-TOOLBAR_HEIGHT),backgroundFrameRect.size.width,TOOLBAR_HEIGHT)];
    
    UIBarButtonItem *flexibleSpaceBarButton = [[UIBarButtonItem alloc]
                                               initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                               target:nil
                                               action:nil];
    UIBarButtonItem* confirmButton = [[UIBarButtonItem alloc] initWithTitle:@"Confirm" style:UIBarButtonItemStyleDone target:datePickerView action:@selector(handlerDateConfirmed:)];
    UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:datePickerView action:@selector(handlerDateCanceled:)];
    toolbarDate.items = [NSArray arrayWithObjects:cancelButton,flexibleSpaceBarButton, confirmButton,nil];
    [datePickerView addSubview:toolbarDate];

    return datePickerView;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

-(void)handlerDateConfirmed : (id)sender
{
    NSDate *selectedDate = self.datePicker.date;
    
    [self.datePickerDelegate onDateSelected:selectedDate];
    [self removeFromSuperview];
}


-(void)handlerDateCanceled : (id)sender
{
    [self.datePickerDelegate onDateCancelled];
    [self removeFromSuperview];
}

-(void)setDatepickerDate:(NSDate *)date
{
    [self.datePicker setDate:date animated:YES];
}


@end
