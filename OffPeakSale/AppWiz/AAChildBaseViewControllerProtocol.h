//
//  AAChildBaseViewControllerProtocol.h
//  Swensens
//
//  Created by Shahid Akhtar Shaikh on 15/12/13.
//  Copyright (c) 2013 Shahid Akhtar Shaikh. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AAChildBaseViewControllerProtocol <NSObject>
@optional
@property (nonatomic,strong) NSString* heading;
@property (nonatomic,strong) NSDictionary* dictShareInformation;
@required
-(void)refreshView;
@end
