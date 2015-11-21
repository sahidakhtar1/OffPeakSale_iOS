//
//  AAHeaderView.h
//  AppWiz
//
//  Created by Shahid Akhtar Shaikh on 5/2/15.
//  Copyright (c) 2015 Shahid Akhtar Shaikh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AAThemeLabel.h"

@protocol HeaderViewDelegate <NSObject>

-(void)backButtonTapped;
-(void)cartButtonTapped;
-(void)searchItemWithText:(NSString*)text;
-(void)hideKeyBoard;

@end

@interface AAHeaderView : UIView<UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet AAThemeLabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIButton *brnMenu;
@property (weak, nonatomic) IBOutlet UIButton *brnShare;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet UIButton *btnSearch;
@property (weak, nonatomic) IBOutlet UIView *vwCart;
@property (weak, nonatomic) IBOutlet UISearchBar *mSearchBar;
@property (weak, nonatomic) IBOutlet AAThemeLabel *lblCartTotal;
@property (nonatomic, getter=isShowBack) BOOL showBack;
@property (nonatomic, getter=isShowCart) BOOL showCart;
@property (weak, nonatomic) IBOutlet UIButton *btnCart;
@property (weak, nonatomic) IBOutlet UIButton *btnScan;
@property (unsafe_unretained, nonatomic) id<HeaderViewDelegate> delegate;
- (IBAction)brnMenuTapped:(id)sender;
- (IBAction)btnShareTapped:(id)sender;
- (IBAction)btnSearchTapped:(id)sender;
- (IBAction)btnBackTapped:(id)sender;
- (IBAction)btnCartTapped:(id)sender;
- (IBAction)btnScanTapped:(id)sender;

-(void)setTitle:(NSString*)title;
-(void)setMenuIcons;
@end
