//
//  SearchResultTableViewController.m
//  WikiSearch
//
//  Created by Trivedi, Astha on 07/09/15.
//  Copyright (c) 2015 Astha. All rights reserved.
//

#import "SearchResultTableViewController.h"

#import "SearchResultListViewModel.h"
#import "SearchResultTableViewCell.h"
#import "Utils.h"
#import "WikiService.h"

@interface SearchResultTableViewController ()

@property (nonatomic, strong) SearchResultListViewModel *searchResults;
@property (weak, nonatomic) IBOutlet UISearchBar *wikiSearchBar;

@end

@implementation SearchResultTableViewController

static NSString * const kCellIdentifier = @"SearchResultCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Wiki Search";
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_handleSearchDidCompleteNotification:)
                                                 name:kWikiServiceSearchResultsNotification
                                               object:nil];
    self.tableView.estimatedRowHeight = 72;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.searchResults.searchResultViewModels count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SearchResultTableViewCell *cell = (SearchResultTableViewCell *)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier
                                                                                                   forIndexPath:indexPath];
    [cell setupCellData:[self.searchResults.searchResultViewModels objectAtIndex:indexPath.row]];
    return cell;
}

#pragma mark - Search Bar Delegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self _searchTerm:searchBar.text];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.text = @"";
    [searchBar resignFirstResponder];
    
    self.searchResults.searchResultViewModels = @[];
    [self.tableView reloadData];
}

#pragma mark - Private Helper Methods

- (void)_handleSearchDidCompleteNotification:(NSNotification *)notif {
    NSDictionary *userInfo = notif.userInfo;
    NSString *errorString = userInfo[kErrorKey];
    if ([errorString length]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERROR" message:errorString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else {
        self.searchResults = [[WikiService sharedService] searchResultList];
        [self.tableView reloadData];
    }
}


- (void)_searchTerm:(NSString *)search {
    [[WikiService sharedService] wikiSearchForTerm:[search capitalizedString]];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
