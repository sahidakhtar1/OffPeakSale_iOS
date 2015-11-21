//
//  AAVoucherTableViewCell.h
//  AppWiz
//
//  Created by Shahid Akhtar Shaikh on 30/12/13.
//  Copyright (c) 2013 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AABaseTableViewCell.h"
#import "AAVoucher.h"
#import "AAVoucherTableViewCellDelegate.h"
#import <MediaPlayer/MediaPlayer.h>
#import "UIImageView+WebCache.h"
#import "AAVideoPlayerView.h"
@interface AAVoucherTableViewCell : AABaseTableViewCell
@property (nonatomic,strong) UIImageView* ivVoucher;
@property (nonatomic,strong) MPMoviePlayerController* moviePlayerController;
@property (nonatomic,strong) UIButton* btnDeleteVoucher;
@property (nonatomic,strong) AAVoucher* voucher;
@property (nonatomic,strong) id<AAVoucherTableViewCellDelegate> delegate;

@property (nonatomic,strong) AAVideoPlayerView* videoPlayerView;
@end
