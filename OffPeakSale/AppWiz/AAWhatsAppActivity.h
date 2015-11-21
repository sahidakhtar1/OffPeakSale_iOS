//
//  AAWhatsAppActivity.h
//  AppWiz
//
//  Created by Shaikh Shahid Akhtar on 14/12/14.
//  Copyright (c) 2014 Shahid Akhtar Shaikh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AAWhatsAppActivity : UIActivity
@property (nonatomic, strong) UIImage *shareImage;
@property (nonatomic, strong) NSString *shareString;
@property (readwrite) BOOL includeURL;
@property (nonatomic, strong) UIDocumentInteractionController *documentController;
@property (nonatomic, strong) UIBarButtonItem *presentFromButton;
@property (nonatomic, strong) UIView *presentFromView;
@end
