//
//  AADropDownScrollView.m
//  Swensens
//
//  Created by Shahid Akhtar Shaikh on 19/12/13.
//  Copyright (c) 2013 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AADropDownScrollView.h"

@implementation AADropDownScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initValues];
    
    }
    return self;
}

-(void)initValues
{
    self.items = [[NSMutableArray alloc] init];
    self.itemViews = [[NSMutableArray alloc] init];
    self.itemHeight = 30;
    self.itemBackgroundColor = [UIColor lightGrayColor];
    self.itemBorderColor = [UIColor darkGrayColor];
    self.itemLabelFont = [UIFont systemFontOfSize:12];
    self.itemLabelTextColor = [UIColor blackColor];
    self.dropDownMenuClass = [AADropDownScrollItemView class];
    self.showBottomBorder = YES;
    self.showTopBorder = NO;
    [self setUserInteractionEnabled:YES];
}


-(void)refreshScrollView
{
    
    for(UIView* itemView in self.itemViews)
    {
        [itemView removeFromSuperview];
    }
    [self addDropDownScrollItems];
}

-(void)refreshScrollView:(BOOL)isProductOption
{
    self.isProductOptions = isProductOption;
    for(UIView* itemView in self.itemViews)
    {
        [itemView removeFromSuperview];
    }
    [self addDropDownScrollItems];
    
    float height = self.itemHeight;
    if (self.items.count>=3) {
        height = self.itemHeight*3;
    }else{
        height = self.itemHeight*self.items.count;
    }
    CGRect frame =self.frame;
    frame.size.height = height;
    self.frame = frame;
    self.layer.borderColor = BOARDER_COLOR.CGColor;
    self.layer.borderWidth = 1.0f;
}

-(void)addDropDownScrollItems
{
    
    CGFloat currentY=0;
    for(NSString* item in self.items)
    {
        
        AADropDownScrollItemView* itemView = [[self.dropDownMenuClass  alloc] initWithFrame:CGRectMake(0, currentY, self.frame.size.width, self.itemHeight)];
        if (self.isProductOptions) {
            [itemView setBottomBorderColor:[UIColor lightGrayColor]];
            [itemView setBackgroundColor:[UIColor whiteColor]];
            [itemView addBottomBorder];
            if (self.isLeftAlign) {
                [itemView.lblItemName setTextAlignment:NSTextAlignmentLeft];
            }else{
                [itemView.lblItemName setTextAlignment:NSTextAlignmentRight];
            }
            
        }else{
            [itemView setBackgroundColor:self.itemBackgroundColor];
            [itemView setBottomBorderColor:self.itemBorderColor];
            [itemView setTopBorderColor:self.itemBorderColor];
            [itemView.lblItemName setTextAlignment:NSTextAlignmentLeft];
        }
        
        [itemView.lblItemName setText:item];
        [itemView.lblItemName setFont:self.itemLabelFont];
        [itemView.lblItemName setTextColor:self.itemLabelTextColor];
        [itemView setUserInteractionEnabled:YES];
//        if([self showBottomBorder])
//        [itemView addBottomBorder];
        if([self showTopBorder])
            [itemView addTopBorder];
        
        UITapGestureRecognizer* tpgrDropDownItemView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDropDownItemTapped:)];
        [itemView addGestureRecognizer:tpgrDropDownItemView];
        [self addSubview:itemView];
        [self.itemViews addObject:itemView];
        currentY+= self.itemHeight;
    }
    
    [self setContentSize:CGSizeMake(self.frame.size.width,currentY)];
}


-(void)handleDropDownItemTapped: (UITapGestureRecognizer*)sender
{
    AADropDownScrollItemView* itemView = (AADropDownScrollItemView*)sender.view;
    
    if(self.dropDownDelegate)
    {
        [self.dropDownDelegate onDropDownMenuItemSelected:self withItemName:itemView.lblItemName.text];
    }
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
