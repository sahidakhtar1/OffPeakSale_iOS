//
//  AAEShopNavigationViewController.m
//  Swensens
//
//  Created by Shahid Akhtar Shaikh on 15/12/13.
//  Copyright (c) 2013 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AAEShopNavigationViewController.h"

@interface AAEShopNavigationViewController ()

@end

@implementation AAEShopNavigationViewController
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
    [self popToRootViewControllerAnimated:NO];
    
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

-(NSDictionary *)dictShareInformation
{
    AAChildBaseViewController* childBaseViewController = (AAChildBaseViewController*) self.topViewController;
    
    return [childBaseViewController dictShareInformation];
}
@end
