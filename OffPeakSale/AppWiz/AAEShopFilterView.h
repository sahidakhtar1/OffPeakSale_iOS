//
//  AAEShopFilterView.h
//  AppWiz
//
//  Created by Shaikh Shahid Akhtar on 12/05/15.
//  Copyright (c) 2015 Shahid Akhtar Shaikh. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol EshopFilterDelegate <NSObject>

-(void)filterAppliedWith:(NSInteger)filterIndex;

@end
@interface AAEShopFilterView : UIView

@property (strong, nonatomic) IBOutlet UIView *vwContainerView;
@property (weak, nonatomic) IBOutlet UILabel *lblFilterTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnFilterNone;
@property (weak, nonatomic) IBOutlet UIButton *btnFilterPopularity;
@property (weak, nonatomic) IBOutlet UIButton *btnFilterLatest;
@property (weak, nonatomic) IBOutlet UIButton *btnFilterLowestPrice;
@property (weak, nonatomic) IBOutlet UIButton *btnFilterHighestPrice;
@property (weak, nonatomic) IBOutlet AAThemeGlossyButton *btnDone;
@property (weak, nonatomic) IBOutlet UIImageView *imgFilterIndicator;
@property (unsafe_unretained, nonatomic) id<EshopFilterDelegate> delegate;
@property (nonatomic) NSInteger selectedFilterIndex;
- (IBAction)btnFilteSelected:(id)sender;
- (IBAction)btnDoneTapped:(id)sender;
- (IBAction)btnCloseTapped:(id)sender;
@end
