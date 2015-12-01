//
//  AASearchDisplayControler.h
//  AppWiz
//
//  Created by Shahid Akhtar Shaikh on 12/1/15.
//  Copyright © 2015 Shaikh Shahid Akhtar. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SearchDelegate <NSObject>
-(void)selectedPlace:(NSDictionary*)selectedPace;

@end
@interface AASearchDisplayControler : UIViewController<UISearchBarDelegate,UISearchControllerDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSMutableArray *searchResult;
@property (weak, nonatomic) IBOutlet UITableView *tbSearchResult;
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, unsafe_unretained) id<SearchDelegate> delegate;
@end
