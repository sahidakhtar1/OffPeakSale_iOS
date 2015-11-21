//
//  ActivityIndicator.m
//  Univercell
//
//  Created by Nichepro on 02/04/13.
//  Copyright (c) 2013 Nichepro. All rights reserved.
//

#import "ActivityIndicator.h"
//Making activityCount as read write for local implemenation
@interface ActivityIndicator()
@property(nonatomic,readwrite) NSInteger activityCount;
@end
//Implementation of ActivityIndicator
@implementation ActivityIndicator
@synthesize containerview;
@synthesize window, activityIndicatoryView;
@synthesize activityCount;

#pragma mark Singleton Class
//sharedActivityIndicator: Method to return the shared instance of this class
+ (ActivityIndicator *)sharedActivityIndicator {
    static dispatch_once_t pred;
    static ActivityIndicator *_sharedActivityIndicator = nil;
    dispatch_once(&pred, ^{
        _sharedActivityIndicator = [[ActivityIndicator alloc] init];
    });
    return _sharedActivityIndicator;
}

#pragma mark Object Initialization
- (ActivityIndicator *)init {
	self = [super init];
	if (self != nil) {
		[[NSBundle mainBundle] loadNibNamed:@"ActivityIndicatorView" owner:self options:nil];
        activityCount = 0;
        self.containerview.center = self.window.center;
	}
	return self;
}

#pragma mark System Functions

//show: Method is used to display and start animating the activity indicator
- (void)show {
    self.activityCount += 1;
    if (self.activityCount != 1 ) return;
    
    UIInterfaceOrientation  ornttn = [[UIApplication sharedApplication] statusBarOrientation];
    if(ornttn == UIInterfaceOrientationLandscapeRight) {
        self.containerview.transform = CGAffineTransformIdentity;
        self.containerview.transform = CGAffineTransformMakeRotation(M_PI/2);
    } 
    else if(ornttn == UIInterfaceOrientationLandscapeLeft) {
        self.containerview.transform = CGAffineTransformIdentity;
        self.containerview.transform = CGAffineTransformMakeRotation(-1 * M_PI/2);
    } 
    else{
        self.containerview.transform = CGAffineTransformIdentity;
    }
	[activityIndicatoryView startAnimating];
	if(window.hidden == YES){
		window.hidden = NO;
	}
}

//hide: Method is used to hide and stop animating the activity indicator
- (void)hide {

    if (self.activityCount) 
        self.activityCount -= 1;
    if (self.activityCount) 
        return;
    
	[activityIndicatoryView stopAnimating];
	if(window.hidden == NO){
		window.hidden = YES;
	}
}

@end