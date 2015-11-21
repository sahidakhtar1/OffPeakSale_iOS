//
//  ActivityIndicator.h
//  Univercell
//
//  Created by Nichepro on 02/04/13.
//  Copyright (c) 2013 Nichepro. All rights reserved.
//

#import <UIKit/UIKit.h>

// Description: Class is used to show and hide application wide activity indicator.
//				Here a shared instance is created and is used acrossthe application.
@interface ActivityIndicator : NSObject {
	IBOutlet UIWindow *window;
	IBOutlet UIActivityIndicatorView* activityIndicatoryView;
    UIView *containerview;
    NSInteger activityCount;
    
}
@property (nonatomic, strong) IBOutlet UIView *containerview;

@property (nonatomic, strong) IBOutlet UIWindow* window;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView* activityIndicatoryView;
//Activity count is readonly for external world
@property (nonatomic, readonly) NSInteger activityCount;

+ (ActivityIndicator *)sharedActivityIndicator;

- (void)show;
- (void)hide;

@end
