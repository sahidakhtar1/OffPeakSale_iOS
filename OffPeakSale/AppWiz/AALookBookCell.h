//
//  AALookBookCell.h
//  AppWiz
//
//  Created by Shahid Akhtar Shaikh on 10/16/15.
//  Copyright (c) 2015 Shahid Akhtar Shaikh. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LookBookCellDelegate <NSObject>

-(void)likeTappedAtIndex:(NSInteger)index;

@end

@interface AALookBookCell : UITableViewCell
@property (nonatomic, unsafe_unretained) id<LookBookCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIImageView *imgLookbook;
@property (weak, nonatomic) IBOutlet UIView *vwDetail;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblDescription;
@property (weak, nonatomic) IBOutlet UIButton *btnLike;
- (IBAction)btnLikeTapped:(id)sender;

@end
