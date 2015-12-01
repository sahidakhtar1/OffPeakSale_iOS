//
//  AASearchDisplayControler.m
//  AppWiz
//
//  Created by Shahid Akhtar Shaikh on 12/1/15.
//  Copyright © 2015 Shaikh Shahid Akhtar. All rights reserved.
//

#import "AASearchDisplayControler.h"

@interface AASearchDisplayControler ()
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation AASearchDisplayControler

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    CGRect frame = [UIScreen mainScreen].bounds;
    self.view.frame = frame;
    
//    self.searchController.searchResultsUpdater = self;
    
    
    self.searchBar.barTintColor = [AAColor sharedInstance].retailerThemeBackgroundColor;
    self.searchBar.tintColor = [AAColor sharedInstance].retailerThemeTextColor;
    [self.searchBar setShowsCancelButton:YES];
    self.searchBar.delegate = self;
    
    self.tbSearchResult.tableFooterView = [[UIView alloc] init];
    self.searchBar.hidden = false;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    NSString *trimmedString = [searchText stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceCharacterSet]];
    NSLog(@"trimmedString = %@",trimmedString);

    [self getAutocompleteWithText:trimmedString];
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self.view removeFromSuperview];
}
-(void)getAutocompleteWithText:(NSString*)text{
    NSString *url  =[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/autocomplete/json?input=%@&types=geocode&language=en&key=%@",[text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],API_KEY];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_5) AppleWebKit/537.71 (KHTML, like Gecko) Version/6.1 Safari/537.71" forHTTPHeaderField:@"User-Agent"];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",nil];
    AFHTTPRequestOperation *operation = [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Response= %@",responseObject);
        self.searchResult = [responseObject objectForKey:@"predictions"];
        [self.tbSearchResult reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.searchResult count];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.textLabel.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:14.0];
    }
    NSDictionary *dict = [self.searchResult objectAtIndex:indexPath.row];
    cell.textLabel.text = [dict valueForKey:@"description"];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view removeFromSuperview];
    if ([self.delegate respondsToSelector:@selector(selectedPlace:)]) {
        [self.delegate selectedPlace:[self.searchResult objectAtIndex:indexPath.row]];
    }
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view removeFromSuperview];
}

@end
