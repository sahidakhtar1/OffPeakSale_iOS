//
//  AAEShopCategoriesScrollView.m
//  Swensens
//
//  Created by Shahid Akhtar Shaikh on 17/12/13.
//  Copyright (c) 2013 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AAEShopCategoriesScrollView.h"

#import "AAConfig.h"
#import "AAAppGlobals.h"
@implementation AAEShopCategoriesScrollView
NSInteger const BUTTON_TEXT_PADDING = 20;
NSInteger  MAX_BUTTON_WIDTH = 180;
NSInteger const SELECTIONINDICATOR_HEIGHT = 3;

@synthesize selectedCategory = selectedCategory_;
@synthesize selectedIndicator;
#pragma mark - UI View Management
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        MAX_BUTTON_WIDTH = [UIScreen mainScreen].bounds.size.width/2 - 45;
        [self initValues];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
       
        MAX_BUTTON_WIDTH = [UIScreen mainScreen].bounds.size.width/2 - 45;
        [self initValues];
        
    }
    return self;
}

-(void)initValues
{
     arrButtonViews_ = [[NSMutableArray alloc] init];
    self.fontCategoryName = [UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:CATEGORY_FONTSIZE];
    self.selectedIndicator = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-SELECTIONINDICATOR_HEIGHT, MAX_BUTTON_WIDTH, SELECTIONINDICATOR_HEIGHT)];
    self.selectedIndicator.backgroundColor = [[AAColor sharedInstance].retailerThemeBackgroundColor colorWithAlphaComponent:.8];
    [self addSubview:self.selectedIndicator];
    self.selectedIndicator.hidden = true;
   self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"btn_tab_default"]];
    
}

#pragma mark - UI Event Management

-(void)categorySelected: (id)sender
{
    if([self.categories indexOfObject:self.selectedCategory]!=NSNotFound)
    {
        NSInteger indexOfSelectedCat = [self.categories indexOfObject:self.selectedCategory];
        AATabButton* btnSelectedCategory = [arrButtonViews_ objectAtIndex:[self.categories indexOfObject:self.selectedCategory]];
        [btnSelectedCategory setSelected:NO];
    }
    NSUInteger indexOfButton = [arrButtonViews_ indexOfObject:sender];
    UIButton *btn = (UIButton*)sender;
    
    CGRect frame = self.selectedIndicator.frame;
    frame.size.width = btn.frame.size.width;
    frame.origin.x = btn.frame.origin.x;
    self.selectedIndicator.frame = frame;
    self.selectedIndicator.hidden = false;
    
    NSString* categoryName = [self.categories objectAtIndex:indexOfButton];
    self.selectedCategory = categoryName;
    [self.eShopCategoryDelegate onCategeorySelected:categoryName];
    [self updateSelectedCategory:NO];
    [sender setSelected:YES];
}

-(void)addCategoriesToScrollView
{
//    NSInteger buttonWidth = [self computeButtonWidthForCategories];
  
    NSInteger currentX = 0;
    for(NSString* category in self.categories)
    {
        AATabButton* btnCategory = [  self createCategoryButtonWithText:category andFrame:CGRectMake(currentX, 0, MAX_BUTTON_WIDTH, self.frame.size.height)];
        
        [arrButtonViews_ addObject:btnCategory];
        currentX+=btnCategory.frame.size.width;
    }
    
    for(int i = ([arrButtonViews_ count] - 1);i>=0;i--)
    {
        [self addSubview:[arrButtonViews_ objectAtIndex:i]];
    }
    
    
    [self setContentSize:CGSizeMake(currentX, self.frame.size.height)];
    
    CGRect frame = self.selectedIndicator.frame;
    frame.size.width = MAX_BUTTON_WIDTH;
    self.selectedIndicator.frame = frame;
    [self bringSubviewToFront:self.selectedIndicator];
    if ([self.categories count]) {
        self.selectedIndicator.hidden = false;
    }else{
        self.selectedIndicator.hidden = YES;
    }
    
}

-(NSInteger)computeButtonWidthForCategories
{
    
    NSString *longestWord = @"FEATURED";
    for(NSString *str in self.categories) {
     // NSString*  str1 = [NSString stringWithFormat:@" %@ ",str];
        if (longestWord == nil || [str length] > [longestWord length]) {
            longestWord = str;
        }
    }
    
    CGSize textSize = [AAUtils getTextSizeWithFont:[UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:CATEGORY_FONTSIZE] andText:longestWord andMaxWidth:MAX_BUTTON_WIDTH];
    
    NSInteger width = textSize.width + 2*BUTTON_TEXT_PADDING;
    return width;
}


-(void)refreshScrollView
{
    NSArray *viewsToRemove = [self subviews];
    for (UIView *v in viewsToRemove)
    {
        if([v isKindOfClass:[UIButton class]])
        {
            [v removeFromSuperview];
        }
    }
    [arrButtonViews_ removeAllObjects];
    CGRect frame = self.selectedIndicator.frame;
    if ([self.categories count]<=2) {
         MAX_BUTTON_WIDTH = [UIScreen mainScreen].bounds.size.width/2;
    }else{
         MAX_BUTTON_WIDTH = [UIScreen mainScreen].bounds.size.width/2 - 45;
    }
    
    frame.size.width = MAX_BUTTON_WIDTH;
    frame.origin.x = MAX_BUTTON_WIDTH;
    self.selectedIndicator.frame = frame;
    [self addCategoriesToScrollView];
    [self updateSelectedCategory:YES];
    

}


-(AATabButton*)createCategoryButtonWithText : (NSString*) categoryName andFrame : (CGRect)frame
{
    
    AATabButton* btnCategory  =[[AATabButton alloc] init];
    [btnCategory setTitleColor:[AAColor sharedInstance].eShopCategoryTextColor forState:UIControlStateNormal];
    [btnCategory setTitleColor:[AAColor sharedInstance].retailerThemeBackgroundColor forState:UIControlStateSelected];
    [btnCategory setBackgroundColor:[UIColor whiteColor]];
    //[btnCategory setBackgroundImage:[UIImage imageNamed:@"first.png"] forState:UIControlStateNormal];
     [btnCategory.titleLabel setFont:[UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:CATEGORY_FONTSIZE]];
    [btnCategory setTitle:categoryName forState:UIControlStateNormal];
    
    [btnCategory addTarget:self action:@selector(categorySelected:) forControlEvents:UIControlEventTouchUpInside];
    [btnCategory setFrame:frame];
    [btnCategory removeShadow];
    UIImage* selectedBackgroundImage = [UIImage imageNamed:@"btn_tab_default"];
    
    [btnCategory setBackgroundImage:[selectedBackgroundImage resizableImageWithCapInsets:UIEdgeInsetsMake(0,0,0,0)] forState:UIControlStateSelected];
//    [btnCategory setBackgroundImage:nil forState:UIControlStateSelected];
    
    return btnCategory;
}

-(void)updateSelectedCategory :(BOOL)selected
{
    
        if([self.categories indexOfObject:self.selectedCategory]!=NSNotFound)
        {
            NSInteger indexOfSelectedCat = [self.categories indexOfObject:self.selectedCategory];
            AATabButton* btnSelectedCategory = [arrButtonViews_ objectAtIndex:[self.categories indexOfObject:self.selectedCategory]];
            [btnSelectedCategory setSelected:selected];
            if ([arrButtonViews_ count] == 2) {
                return;
            }
            CGRect frame = self.selectedIndicator.frame;
            frame.size.width = btnSelectedCategory.frame.size.width;
            frame.origin.x = btnSelectedCategory.frame.origin.x;
            self.selectedIndicator.frame = frame;
            float  selectedItemX = self.selectedIndicator.frame.origin.x;
            CGPoint contentOffset = self.contentOffset;
            float targetOffsetX = selectedItemX-self.frame.size.width/2+MAX_BUTTON_WIDTH/2;
            if (targetOffsetX + self.frame.size.width > self.contentSize.width){
                targetOffsetX = self.contentSize.width - self.frame.size.width;
            }
            if (targetOffsetX <= 0) {
                targetOffsetX = 0;
            }
            contentOffset.x = targetOffsetX;
            [self setContentOffset:contentOffset animated:YES];
            
        }
    
}



@end
