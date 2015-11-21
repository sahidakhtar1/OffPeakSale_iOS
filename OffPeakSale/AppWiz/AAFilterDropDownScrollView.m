//
//  AAFilterDropDownScrollView.m
//  AppWiz
//
//  Created by Shahid Akhtar Shaikh on 13/1/14.
//  Copyright (c) 2014 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AAFilterDropDownScrollView.h"

@implementation AAFilterDropDownScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self addTextField];
    }
    return self;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
-(void)addTextField
{
    self.hiddenTexfield = [[UITextField alloc] initWithFrame:CGRectMake(-1*[UIScreen mainScreen].bounds.size.width, 0, 20, 30)];
    self.hiddenTexfield.delegate = self;
    [self addSubview:self.hiddenTexfield];
   
    
}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString* newText = textField.text.mutableCopy;
    newText = [newText stringByReplacingCharactersInRange:range withString:string];
    [self scrollToItemWStartingWithString:newText];
    
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}

-(void)scrollToItemWStartingWithString:(NSString*)string
{
    for(NSString* item in self.items)
    {
        if([item.lowercaseString hasPrefix:string.lowercaseString])
        {
            AADropDownScrollItemView* itemView = [self.itemViews objectAtIndex:[self.items indexOfObject:item]];
            [self scrollRectToVisible:itemView.frame animated:YES];
            break;
            
        }
    }
}

@end
