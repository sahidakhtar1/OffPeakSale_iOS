//
//  AADeleveryScheduleView.m
//  AppWiz
//
//  Created by Shahid Akhtar Shaikh on 5/10/15.
//  Copyright (c) 2015 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AADeleveryScheduleView.h"
#import "AAEarliestSchedule.h"

static NSString* const DATE_FORMAT = @"dd-MMM-yyyy";
@implementation AADeleveryScheduleView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self = [self initialize];
        self.frame = frame;
        self.backgroundColor= [UIColor colorWithRed:0 green:0 blue:0 alpha:.3];
        [self setFont];
        [self populateValues];
//        [self setRightIconstoTestFields];
        CGRect rect = [UIScreen mainScreen].bounds;
        self.frame = rect;
        CALayer *layer = self.vwContainerView.layer;
        layer.shadowOffset = CGSizeMake(1, 1);
        layer.shadowColor = [[UIColor blackColor] CGColor];
        layer.shadowRadius = 4.0f;
        layer.shadowOpacity = 0.80f;
        layer.shadowPath = [[UIBezierPath bezierPathWithRect:layer.bounds] CGPath];
        self.vwContainerView.center = CGPointMake(self.center.x, rect.size.height/2);
        self.items = [[NSMutableArray alloc] init];
    }
    return self;
}

- (UIView*)initialize{
    UIView *childView= [[[NSBundle mainBundle] loadNibNamed:@"AADeleveryScheduleView" owner:self options:nil] objectAtIndex:0];
    
    return childView;
}
-(void)setFont{
    self.lblDeleveryTitle.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].boldFont size:17.0];
    self.lblSelectedSchedule.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:14.0];
    self.lblDeliveryDateTitle.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].boldFont size:17.0];
    self.lblDeliveryTimeTitle.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].boldFont size:17.0];
    self.lblCollectionAddressTitle.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].boldFont size:17.0];
    self.btnDone.titleLabel.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].boldFont size:17.0];
}
-(void)populateValues{
//    [[AAAppGlobals sharedInstance] getDateByAddingDays:[[AAAppGlobals sharedInstance].deliveryDays intValue]];
    self.selectedDate = [AAAppGlobals sharedInstance].scheduledDate;
    self.selectedTime = [AAAppGlobals sharedInstance].selectedTime;
    self.selectedAddress = [AAAppGlobals sharedInstance].selectedCollectionAddress;
    NSString *scheduledDate =[[AAAppGlobals sharedInstance] convertDateToString:[AAAppGlobals sharedInstance].scheduledDate];
    NSString *selectedSchedule;
    if (![[AAAppGlobals sharedInstance].selectedTime isEqualToString:@""]) {
        selectedSchedule = [NSString stringWithFormat:@"%@, %@",scheduledDate,[AAAppGlobals sharedInstance].selectedTime];
        self.tfTime.text = [NSString stringWithFormat:@" %@",[AAAppGlobals sharedInstance].selectedTime];
    }else{
        selectedSchedule = [NSString stringWithFormat:@"%@",scheduledDate];
    }
    
    self.lblSelectedSchedule.text =selectedSchedule;
    
    self.tfCollectionAddress.text = [AAAppGlobals sharedInstance].selectedCollectionAddress;
    [self populateDateWithString:scheduledDate];
    [self adjustFrame];
    
}
-(void)adjustFrame{
    float originY = self.tfTime.frame.origin.y + self.tfTime.frame.size.height+10;
    
    if ([AAAppGlobals sharedInstance].deliveryOptonSelectedIndex == 1 ) {
        BOOL isTimeLapse = [[AAAppGlobals sharedInstance].retailer.collectionType isEqualToString:@"0"]?NO:YES;
        
        
        self.lblCollectionAddressTitle.hidden = false;
        self.tfCollectionAddress.hidden = false;
        self.imgUpdown.hidden = false;
        self.lblDeleveryTitle.text = @"Earlist date of Collection";
        self.lblDeliveryDateTitle.text = @"Prefered Delivery Collection";
        self.lblDeliveryTimeTitle.text = @"Delivery Time Collection";
        CGRect frame = self.lblCollectionAddressTitle.frame;
        if (isTimeLapse) {
            self.lblDeliveryTimeTitle.hidden = true;
            self.tfTime.hidden = true;
            self.imgTimeUpdown.hidden = true;
            frame.origin.y = self.tfDay.frame.origin.y + self.tfDay.frame.size.height+10;
           
        }else{
            self.lblDeliveryTimeTitle.hidden = false;
            self.tfTime.hidden = false;
            self.imgTimeUpdown.hidden = false;
            frame.origin.y = self.tfTime.frame.origin.y + self.tfTime.frame.size.height+10;
        }
        self.lblCollectionAddressTitle.frame = frame;
        
        frame = self.tfCollectionAddress.frame ;
        frame.origin.y = self.lblCollectionAddressTitle.frame.origin.y + self.lblCollectionAddressTitle.frame.size.height +5;
        self.tfCollectionAddress.frame = frame;
        
         originY = self.tfCollectionAddress.frame.origin.y + self.tfCollectionAddress.frame.size.height + 10;
    }else{
        BOOL isTimeLapse = [[AAAppGlobals sharedInstance].retailer.deliveryType isEqualToString:@"0"]?NO:YES;
        if (isTimeLapse) {
            self.lblDeliveryTimeTitle.hidden = true;
            self.tfTime.hidden = true;
            self.imgTimeUpdown.hidden = true;
            originY = self.tfDay.frame.origin.y + self.tfDay.frame.size.height + 10;
        }else{
            self.lblDeliveryTimeTitle.hidden = false;
            self.tfTime.hidden = false;
            self.imgTimeUpdown.hidden = false;
            originY = self.tfTime.frame.origin.y + self.tfTime.frame.size.height + 10;
        }
        self.lblCollectionAddressTitle.hidden = true;
        self.tfCollectionAddress.hidden = true;
        self.imgUpdown.hidden = true;
        
    }
   
    CGRect frame = self.btnDone.frame;
    frame.origin.y = originY;
    self.btnDone.frame = frame;
    
    frame = self.vwContainerView.frame;
    frame.size.height = self.btnDone.frame.size.height + originY +10;
    self.vwContainerView.frame =frame;
    
    CGRect rect = [UIScreen mainScreen].bounds;
    self.vwContainerView.center = CGPointMake(self.center.x, rect.size.height/2);
}
-(void)populateDateWithString:(NSString*)date{
    NSArray *dateComp = [date componentsSeparatedByString:@"-"];
    self.tfDay.text = [NSString stringWithFormat:@" %@",[dateComp objectAtIndex:0]];
    self.tfMonth.text = [NSString stringWithFormat:@" %@",[dateComp objectAtIndex:1]];
    self.tfYear.text = [NSString stringWithFormat:@" %@",[dateComp objectAtIndex:2]];
}
-(void)setRightIconstoTestFields{
    UIImageView *rightIcon1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"updown"]];
    UIImageView *rightIcon2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"updown"]];
    UIImageView *rightIcon3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"updown"]];
    UIImageView *rightIcon4 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"updown"]];
    rightIcon1.frame = CGRectMake(0, 0, 8, 16);
    rightIcon2.frame = CGRectMake(0, 0, 8, 16);
    rightIcon3.frame = CGRectMake(0, 0, 8, 16);
    rightIcon4.frame = CGRectMake(0, 0, 8, 16);
    [self.tfDay setRightView:rightIcon1];
    [self.tfMonth setRightView:rightIcon2];
    [self.tfYear setRightView:rightIcon3];
    [self.tfTime setRightView:rightIcon4];
}
- (IBAction)btnCloseTapped:(id)sender {
    [self removeFromSuperview];
}

- (IBAction)tfTimePressed:(id)sender {
    [self showTimeIntervalDropDown:true];
}

- (IBAction)tfDeliveyDatePressed:(id)sender {
    self.datePickerView = [AADatePickerView createDatePickerViewWithBackgroundFrameRect:CGRectMake(0, 0, self.superview.frame.size.width, self.superview.frame.size.height)];
    ;
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    if ([AAAppGlobals sharedInstance].deliveryOptonSelectedIndex == 0){
        [offsetComponents setHour:[[AAAppGlobals sharedInstance].retailer.deliveryDays intValue]];
        [offsetComponents setMinute:[[AAAppGlobals sharedInstance].retailer.deliveryHours intValue]];
    }else{
        [offsetComponents setHour:[[AAAppGlobals sharedInstance].retailer.collectionDays intValue]];
        [offsetComponents setMinute:[[AAAppGlobals sharedInstance].retailer.collectionHours intValue]];
    }
    
    NSDate* minimumDate =  [gregorian dateByAddingComponents:offsetComponents toDate:[NSDate date] options:0];
    
//    [self.datePickerView.datePicker setMaximumDate:[NSDate date]];
    [self.datePickerView.datePicker setMinimumDate:minimumDate];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:DATE_FORMAT];
     NSString *scheduledDate =[[AAAppGlobals sharedInstance] convertDateToString:[AAAppGlobals sharedInstance].scheduledDate];
    NSDate *date = [dateFormat dateFromString:scheduledDate];
    if(date)
    {
        [self.datePickerView setDatepickerDate:date];
    }
    self.datePickerView.datePickerDelegate = self;
    [self.superview addSubview:self.datePickerView];
}

- (IBAction)tfCollectionAddressPressed:(id)sender {
    [self showTimeIntervalDropDown:false];
}

- (IBAction)btnDonePressed:(id)sender {
    [AAAppGlobals sharedInstance].scheduledDate = self.selectedDate;
    [AAAppGlobals sharedInstance].selectedTime = self.selectedTime;
    [AAAppGlobals sharedInstance].selectedCollectionAddress = self.selectedAddress;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DeliveryScheduled" object:nil];
    [self removeFromSuperview];
}
#pragma mark - Date Picker Callbacks
-(void)onDateCancelled
{
    
}
-(void)onDateSelected:(NSDate *)date
{
    self.selectedDate = date;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:DATE_FORMAT];
    
    NSString* dateString = [dateFormatter stringFromDate:date];
    [self populateDateWithString:dateString];
    NSString *earlistDate = [dateFormatter stringFromDate:[AAAppGlobals sharedInstance].scheduledDate];
    if ([dateString isEqualToString:earlistDate]) {
        dateFormatter.dateFormat = @"hh a";
        NSString *hourString = [dateFormatter stringFromDate:date];
        NSArray *compArr = [hourString componentsSeparatedByString:@" "];
        NSString *lastComp = [compArr lastObject];
        int currentHour = [[dateFormatter stringFromDate:date] intValue];
        if ([lastComp isEqualToString:@"PM"]) {
            currentHour+=12;
        }
        dateFormatter.dateFormat = @"mm";
        int mins= [[dateFormatter stringFromDate:date] intValue];
        [self populateTimeSlots:currentHour mins:mins];
    }else{
        [self populateTimeSlots:0 mins:0];
    }
}
-(void)populateTimeSlots:(int)hours mins:(int)mins{
    
    NSArray *timeslots ;
    if ([AAAppGlobals sharedInstance].deliveryOptonSelectedIndex == 0){
        timeslots = [AAAppGlobals sharedInstance].deliverySlotsArray;
    }else{
        timeslots = [AAAppGlobals sharedInstance].collectionSlotsArray;
    }
    NSArray *possibleTimeSlots = [[AAAppGlobals sharedInstance]
                                  possibleTimeSlotes:timeslots
                                  hours:hours
                                  mins:mins
                                  ];
    [[AAAppGlobals sharedInstance].earlieastSchedule.possibleTimeSlots removeAllObjects];
    [[AAAppGlobals sharedInstance].earlieastSchedule.possibleTimeSlots addObjectsFromArray:[[AAAppGlobals sharedInstance] conver12HourFormat:possibleTimeSlots]];
    if ([[AAAppGlobals sharedInstance].earlieastSchedule.possibleTimeSlots count]) {
        [self.tfTime setText:[NSString stringWithFormat:@" %@",[[AAAppGlobals sharedInstance].earlieastSchedule.possibleTimeSlots objectAtIndex:0]]];
    }
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField.tag == 101) {
        [self tfTimePressed:nil];
    }else if(textField.tag ==  102){
        [self tfCollectionAddressPressed:nil];
    }
    else{
        
        [self tfDeliveyDatePressed:nil];
    }
    return NO;
}
-(void)showTimeIntervalDropDown:(BOOL)isTimeSchedule{
    if (self.optionDropDown != nil) {
        [self.optionDropDown removeFromSuperview];
        self.optionDropDown = nil;
    }
    
    
    
    if (isTimeSchedule) {
        
        self.optionDropDown = [[AAFilterDropDownScrollView alloc]
                               initWithFrame:CGRectMake(self.tfTime.frame.origin.x,
                                                        self.tfTime.frame.origin.y,
                                                        self.tfTime.frame.size.width,
                                                        90)];
        self.optionDropDown.tag = 0;
        if ([AAAppGlobals sharedInstance].deliveryOptonSelectedIndex == 0) {
            AAEarliestSchedule *earlieastSchedule = [AAAppGlobals sharedInstance].earlieastSchedule;
            [self.optionDropDown setItems:earlieastSchedule.possibleTimeSlots];
        }else{
            [self.optionDropDown setItems:[AAAppGlobals sharedInstance].earlieastSchedule.possibleTimeSlots];
        }
        
    }else{
        
        self.optionDropDown = [[AAFilterDropDownScrollView alloc]
                               initWithFrame:CGRectMake(self.tfCollectionAddress.frame.origin.x,
                                                        self.tfCollectionAddress.frame.origin.y,
                                                        self.tfCollectionAddress.frame.size.width,
                                                        90)];
        self.optionDropDown.tag = 1;
        [self.optionDropDown setItems:[AAAppGlobals sharedInstance].collectionAddressArray];
    }
    [self.optionDropDown setIsLeftAlign:true];
    [self.optionDropDown setItemHeight:30];
    self.optionDropDown.dropDownDelegate = self;
    [self.optionDropDown refreshScrollView:true];
    
    
    [self.vwContainerView addSubview:self.optionDropDown];
//    CGRect frame =self.optionDropDown.frame;
    // frame.origin.y += self.option2
    
}
-(void)onDropDownMenuItemSelected:(id)dropDownScrollView withItemName:(NSString *)itemName
{
    AAFilterDropDownScrollView *dropDown = (AAFilterDropDownScrollView*)dropDownScrollView;
    if (dropDown.tag == 0) {
        self.selectedTime = itemName;
        [self.tfTime setText:[NSString stringWithFormat:@" %@",itemName]];
    }else{
        self.selectedAddress = itemName;
        [self.tfCollectionAddress setText:[NSString stringWithFormat:@" %@",itemName]];
    }
    
    
    
    [self.optionDropDown removeFromSuperview];
    
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.optionDropDown removeFromSuperview];
    self.optionDropDown = nil;
}
@end
