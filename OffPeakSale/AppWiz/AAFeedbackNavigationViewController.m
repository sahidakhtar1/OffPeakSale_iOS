//
//  AAFeedbackNavigationViewController.m
//  AppWiz
//
//  Created by Shahid Akhtar Shaikh on 2/1/14.
//  Copyright (c) 2014 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AAFeedbackNavigationViewController.h"

@interface AAFeedbackNavigationViewController ()

@end

@implementation AAFeedbackNavigationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)refreshView
{
    AAChildBaseViewController* childBaseViewController = (AAChildBaseViewController*) self.topViewController;
    [childBaseViewController refreshView];
}

-(NSString *)heading
{
    AAChildBaseViewController* childBaseViewController = (AAChildBaseViewController*) [self.viewControllers objectAtIndex:0];
    
    return [childBaseViewController heading];
    
}

-(void)showBackButtonView
{
    [self.childNavigationControllerDelegate showBackButtonView];
}

-(void)hideBackButtonView
{
    [self.childNavigationControllerDelegate hideBackButtonView];
}
@end
