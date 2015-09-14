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
#import "WikiPageViewController.h"
#import "WikiPageViewModel.h"
#import "WikiService.h"

@interface SearchResultTableViewController ()

@property (nonatomic, strong) Class alertViewClass;
@property (nonatomic, strong) SearchResultListViewModel *searchResults;
@property (nonatomic, strong) NSString *selectedTitle;
@property (weak, nonatomic) IBOutlet UISearchBar *wikiSearchBar;
@property (nonatomic, assign) BOOL isLoadingMoreResults;

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
    
    self.alertViewClass = [UIAlertView class];
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
    
    if (!self.isLoadingMoreResults && indexPath.row == [self.searchResults.searchResultViewModels count] - 1) {
        
        [self _loadMoreSearchResults];
        self.isLoadingMoreResults = YES;
    }
    
    return cell;
}


#pragma mark - Table View Delegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SearchResultViewModel *inViewModel = [self.searchResults.searchResultViewModels objectAtIndex:indexPath.row];
    self.selectedTitle = inViewModel.title;
    [self performSegueWithIdentifier:@"pushWebView" sender:self];
}

#pragma mark - Search Bar Delegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self _searchTerm:searchBar.text];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.text = @"";
    [searchBar resignFirstResponder];
    self.selectedTitle = @"";
    [self.searchResults.searchResultViewModels removeAllObjects];
    [self.tableView reloadData];
}

#pragma mark - Private Helper Methods

- (void)_handleSearchDidCompleteNotification:(NSNotification *)notif {
    NSDictionary *userInfo = notif.userInfo;
    NSString *errorString = userInfo[kErrorKey];
    
    self.isLoadingMoreResults = NO;
    
    if ([errorString length]) {
        UIAlertView *alert = [[self.alertViewClass alloc] initWithTitle:@"ERROR"
                                                        message:errorString
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    else {
        self.searchResults = [[WikiService sharedService] searchResultList];
        [self.wikiSearchBar resignFirstResponder];
        if ([self.searchResults.searchResultViewModels count] == 0) {
            UIAlertView *alert = [[self.alertViewClass alloc] initWithTitle:@""
                                                            message:@"No search results found."
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
        [self.tableView reloadData];
    }
}

- (void)_loadMoreSearchResults {
    [[WikiService sharedService] loadMoreSearchResultsForTerm:[self.wikiSearchBar.text capitalizedString]];
}

- (void)_searchTerm:(NSString *)search {
    [[WikiService sharedService] wikiSearchForTerm:[search capitalizedString]];
}

#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"pushWebView"] &&
        [[segue destinationViewController] isKindOfClass:[WikiPageViewController class]])
    {
        WikiPageViewController *controller = [segue destinationViewController];
        WikiPageViewModel *viewModel = [[WikiPageViewModel alloc] init];
        [viewModel setupUrlString:self.selectedTitle];
        [controller setupViewModel:viewModel];
    }
}


@end
