//
//  AATour_ViewController.m
//  AppWiz
//
//  Created by Litoo on 22/11/15.
//  Copyright © 2015 Shaikh Shahid Akhtar. All rights reserved.
//

#import "AATour_ViewController.h"
#import "AAAppDelegate.h"
#import "AATourItem.h"
#import "AATourSlideView.h"
#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define PAGE_CONTROL_SIZE 10
@interface AATour_ViewController ()
{
    IBOutlet UIScrollView *scroll;
    NSTimer *timer;
    NSArray *infoText_Arr;
    NSMutableArray *PageControlBtns;
    UIButton *skipBtn;
}
@end

@implementation AATour_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"Key_tourChk"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    PageControlBtns = [[NSMutableArray alloc] init];
    infoText_Arr = [[NSArray alloc] initWithObjects:@"Filter a resturant as per desired location and cuisine with your matching time slots for morning, afternoon and night",@"Filter a resturant as per desired location and cuisine with your matching time slots for morning, afternoon and night",@"Filter a resturant as per desired location and cuisine with your matching time slots for morning, afternoon and night", nil];
    
    NSArray *slides = [AAAppGlobals sharedInstance].retailer.tutorialSlides;
    [scroll setContentSize:CGSizeMake(SCREEN_WIDTH * [slides count], self.view.frame.size.height)];
    [scroll setPagingEnabled:YES];
    scroll.delegate = self;
    [scroll setShowsHorizontalScrollIndicator:NO];
    [scroll setBackgroundColor:[UIColor clearColor]];
    
    [self.homeBtn.layer setCornerRadius:self.homeBtn.frame.size.height/2];

    
    int xpos = (SCREEN_WIDTH/2) - PAGE_CONTROL_SIZE*[slides count];
    int xpos1 = PAGE_CONTROL_SIZE*[slides count];
    
    for (int i = 0; i< [slides count]; i++)
    {
        AATourItem *tourItem = [slides objectAtIndex:i];
        AATourSlideView *slideView = [[AATourSlideView alloc] initWithFrame:CGRectMake(i*SCREEN_WIDTH, 0, self.view.frame.size.width, self.view.frame.size.height)];
        [slideView setTourItem:tourItem];
        [scroll addSubview:slideView];
        
        xpos1 = xpos1 + SCREEN_WIDTH;
        
        //PageControlButtons
        UIButton *PageControlBtn = [[UIButton alloc] initWithFrame:CGRectMake(xpos, SCREEN_HEIGHT - 60, 10, 10)];
        PageControlBtn.layer.cornerRadius = PageControlBtn.bounds.size.width / 2.0;
        [PageControlBtn setBackgroundColor:(i==0)?[UIColor whiteColor]:[UIColor colorWithWhite:1.0 alpha:0.4]];
        
        [PageControlBtn.layer setBorderWidth:1.5];
        [PageControlBtn.layer setBorderColor:[[UIColor clearColor] CGColor]];
        
        [PageControlBtn setTag:i+2000];
        [PageControlBtn addTarget:self action:@selector(onPageControlBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:PageControlBtn];
        [PageControlBtns addObject:PageControlBtn];
        xpos = xpos + 20;
    }
}
-(void)SetActivePageControlWithIndex:(int)index
{
    for (int i=0; i<[PageControlBtns count]; i++)
    {
        [[PageControlBtns objectAtIndex:i] setBackgroundColor:(i==index)?[UIColor whiteColor]:[UIColor colorWithWhite:1.0 alpha:0.4]];
    }
}
-(void)onPageControlBtnPressed:(id)sender
{
    UIButton *button = (UIButton *)sender;
    int tag=button.tag-2000;
    [scroll setContentOffset:CGPointMake(scroll.frame.size.width*tag, 0) animated:YES];
    [self SetActivePageControlWithIndex:tag];
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)sender
{
    CGFloat pageWidth = scroll.frame.size.width;
    int page = floor((scroll.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    [self SetActivePageControlWithIndex:page];
}
-(IBAction)homeBtn_action:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"Key_tourChk"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    AAAppDelegate *appDel = (AAAppDelegate *) [UIApplication sharedApplication].delegate;
    [appDel onSplashScreenDisplayCompleted];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
