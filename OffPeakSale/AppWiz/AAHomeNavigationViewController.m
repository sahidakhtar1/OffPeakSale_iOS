//
//  AAHomeNavigationViewController.m
//  Swensens
//
//  Created by Shahid Akhtar Shaikh on 15/12/13.
//  Copyright (c) 2013 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AAHomeNavigationViewController.h"

@interface AAHomeNavigationViewController ()

@end

@implementation AAHomeNavigationViewController
@synthesize heading = heading_;

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
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)refreshView
{
     [self.childNavigationControllerDelegate hideBackButtonView];
    [self popToRootViewControllerAnimated:YES];
    AAChildBaseViewController* childBaseViewController = (AAChildBaseViewController*) self.topViewController;
    [childBaseViewController refreshView];
}

-(NSString *)heading
{
    AAChildBaseViewController* childBaseViewController = (AAChildBaseViewController*) [self.viewControllers objectAtIndex:0];
    
    return [childBaseViewController heading];
    
}
-(void)setRootViewControllerDelegate : (id<AARootChildViewControllerDelegate>)rootViewControllerDelegate
{
   AAHomeViewController* vcHome = [self.viewControllers objectAtIndex:0];
    [vcHome setRootViewControllerDelegate:rootViewControllerDelegate];
    
}

-(void)showBackButtonView
{
    [self.childNavigationControllerDelegate showBackButtonView];
}
@end
