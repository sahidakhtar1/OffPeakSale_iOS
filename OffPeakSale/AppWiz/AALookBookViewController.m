//
//  AALookBookViewController.m
//  AppWiz
//
//  Created by Shahid Akhtar Shaikh on 10/16/15.
//  Copyright (c) 2015 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AALookBookViewController.h"
#import "AALookBookCell.h"
#import "AAHeaderView.h"
#import "AALookBookHelper.h"
#import "AALookBookResponseObject.h"
#import "AALookBookObject.h"
#import "UIImageView+WebCache.h"
#import "AALookBookLikeHelper.h"
@interface AALookBookViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tbLookBook;
@property (weak, nonatomic) IBOutlet UIView *vwHeaderView;
@property (nonatomic, strong) AALookBookResponseObject *lookBookObj;
@property (nonatomic) NSInteger selectedIndex;
@end

@implementation AALookBookViewController
@synthesize title;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.selectedIndex = -1;
    __weak AALookBookViewController *weekSelf = self;
    [AALookBookHelper getLookBookDataWithCompletionBlock:^(AALookBookResponseObject *obj) {
        weekSelf.lookBookObj = obj;
//        [weekSelf.lookBookObj.lookBookItems addObjectsFromArray:obj.lookBookItems];
        [weekSelf.tbLookBook reloadData];
    } andFailure:^(NSString *error) {
        NSLog(@"error =%@",error);
    }];
    AAHeaderView *headerView = [[AAHeaderView alloc] initWithFrame:self.vwHeaderView.frame];
    [self.vwHeaderView addSubview:headerView];
    [headerView setTitle:self.title];
    headerView.showCart = false;
    headerView.showBack = false;
    headerView.delegate = self;
    [headerView setMenuIcons];
    [self.tbLookBook setTableFooterView:[[UIView alloc] init]];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark UITableView Delagate and Data Sources
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = [[AAAppGlobals sharedInstance] getImageHeight];
    if (indexPath.row == self.selectedIndex) {
        height += 5;
        height+=24;
        AALookBookObject *lookBook = [self.lookBookObj.lookBookItems objectAtIndex:indexPath.row];
        float maxWidthForLbl = self.view.frame.size.width - 30;
        CGSize optionSize= [AAUtils getTextSizeWithFont:[UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:LOOKBOOK_DESCRIPTION_SIZE] andText:lookBook.desc andMaxWidth:maxWidthForLbl ];
        if (optionSize.height > 51) {
            height += 51;
        }else{
            height += optionSize.height;
        }
        height += 5;
    }
    return height;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.lookBookObj.lookBookItems count];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    AALookBookCell *lookBookCell = (AALookBookCell*)[tableView dequeueReusableCellWithIdentifier:@"AALookBookCell"];
    cell = lookBookCell;
    lookBookCell.delegate = self;
    AALookBookObject *lookBook = [self.lookBookObj.lookBookItems objectAtIndex:indexPath.row];
    [lookBookCell.imgLookbook setImageWithURL:[NSURL URLWithString:lookBook.imgUrl]
                                completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                                }];
    CGFloat height = [[AAAppGlobals sharedInstance] getImageHeight];
    CGRect frame = lookBookCell.imgLookbook.frame;
    frame.size.height = height;
    lookBookCell.imgLookbook.frame = frame;
    
    
    float itemDetailHeight = 0;
    float maxWidthForLbl = self.view.frame.size.width - 30;
    if (self.selectedIndex == indexPath.row) {
        lookBookCell.vwDetail.hidden = false;
        
        itemDetailHeight += 5;
        itemDetailHeight+=24;
        
        CGSize optionSize= [AAUtils getTextSizeWithFont:[UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:LOOKBOOK_DESCRIPTION_SIZE] andText:lookBook.desc andMaxWidth:maxWidthForLbl ];
        float descHeight = 0;
        if (optionSize.height > 51) {
            descHeight = 51;
        }else{
            descHeight = optionSize.height;
        }
        CGRect descFrame = lookBookCell.lblDescription.frame;
        descFrame.size.height = descHeight;
        lookBookCell.lblDescription.frame = descFrame;
        
        itemDetailHeight += descHeight;
        itemDetailHeight += 5;
        
        
        
        
        lookBookCell.lblTitle.text = lookBook.title;
        lookBookCell.lblDescription.text = lookBook.desc;
        [lookBookCell.btnLike setTitle:lookBook.likesCnt forState:UIControlStateNormal];
        
        
    }else{
        lookBookCell.vwDetail.hidden = true;
    }
    lookBookCell.btnLike.tag = indexPath.row;
    [lookBookCell.vwDetail setAutoresizingMask:UIViewAutoresizingNone];
    CGRect itemDetailframe = lookBookCell.vwDetail.frame;
    itemDetailframe.origin.y = height;
    itemDetailframe.size.width = maxWidthForLbl;
    itemDetailframe.size.height = itemDetailHeight;
    lookBookCell.vwDetail.frame = itemDetailframe;
    
    
    height += itemDetailHeight;
    CGRect cellFrame = cell.frame;
    cellFrame.size.height = height;
    cell.frame = cellFrame;

    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.selectedIndex == indexPath.row) {
        self.selectedIndex = -1;
    }else{
        self.selectedIndex = indexPath.row;
    }
    [tableView reloadData];
}
-(void)likeTappedAtIndex:(NSInteger)index{
    __weak AALookBookViewController *weekSelf = self;

    AALookBookObject *lookBookItem = [self.lookBookObj.lookBookItems objectAtIndex:index];
    [AALookBookLikeHelper lookBookLikeItem:lookBookItem.itemId
                       withCompletionBlock:^(NSString *likeCount, NSString *msg) {
                           lookBookItem.likesCnt = likeCount;
                           [weekSelf.tbLookBook reloadData];
                        }
                        andFailure:^(NSString *msg) {
        
                        }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
