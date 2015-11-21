//
//  AALookBookCell.m
//  AppWiz
//
//  Created by Shahid Akhtar Shaikh on 10/16/15.
//  Copyright (c) 2015 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AALookBookCell.h"

@implementation AALookBookCell

- (void)awakeFromNib {
    // Initialization code
    self.lblTitle.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].boldFont size:LOOKBOOK_TITLE_SIZE];
    self.lblDescription.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:LOOKBOOK_DESCRIPTION_SIZE];
    self.btnLike.titleLabel.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:LOOKBOOK_DESCRIPTION_SIZE];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)btnLikeTapped:(id)sender {
    if ([self.delegate respondsToSelector:@selector(likeTappedAtIndex:)]) {
        UIButton *btn = (UIButton*)sender;
        [self.delegate likeTappedAtIndex:btn.tag];
    }
}
@end
