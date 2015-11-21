//
//  AAScannerViewController.h
//  AppWiz
//
//  Created by Shahid Akhtar Shaikh on 9/2/15.
//  Copyright (c) 2015 Shahid Akhtar Shaikh. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ScannerDelegate <NSObject>

-(void)scanningResult:(NSString*)result;

@end

@interface AAScannerViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *vwCameraPreview;
- (IBAction)btnCancleTapped:(id)sender;
@property (nonatomic, unsafe_unretained) id<ScannerDelegate> delegate;

@end
