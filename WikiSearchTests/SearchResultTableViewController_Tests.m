//
//  SearchResultTableViewController_Tests.m
//  WikiSearch
//
//  Created by Trivedi, Astha on 12/09/15.
//  Copyright (c) 2015 Astha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "JMRMockAlertView.h"
#import "JMRMockAlertViewVerifier.h"

#import "SearchResult.h"
#import "SearchResultViewModel.h"
#import "SearchResultListViewModel.h"
#import "SearchResultTableViewCell.h"
#import "SearchResultTableViewController.h"
#import "Utils.h"


@interface SearchResultTableViewController (UnitTests) <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (nonatomic, strong) Class alertViewClass;
@property (nonatomic, assign) BOOL isLoadingMoreResults;
@property (nonatomic, strong) SearchResultListViewModel *searchResults;
@property (nonatomic, strong) NSString *selectedTitle;
@property (nonatomic, strong) UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *wikiSearchBar;

- (void)_loadMoreSearchResults;
- (void)_test;
- (void)_searchTerm:(NSString *)search;
- (void)_handleSearchDidCompleteNotification:(NSNotification *)notif;

@end


@interface SearchResultTableViewController_Tests : XCTestCase

@property (nonatomic, strong) SearchResultTableViewController *searchResultView;

@end


@implementation SearchResultTableViewController_Tests

- (void)setUp {
    [super setUp];
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.searchResultView = [sb instantiateViewControllerWithIdentifier:@"WikiSearchScreen"];
    
    self.searchResultView.searchResults = [[SearchResultListViewModel alloc] init];
    SearchResultViewModel *vm = [SearchResultViewModel new];
    vm.title = @"title";
    vm.timestamp = @"timestamp";
    
    [self.searchResultView.searchResults.searchResultViewModels addObject:vm];
    
    self.searchResultView.alertViewClass = [JMRMockAlertView class];
}

- (void)tearDown {
    
    self.searchResultView.searchResults.searchResultViewModels = nil;
    self.searchResultView.searchResults = nil;
    self.searchResultView = nil;
    [super tearDown];
}


- (void)testViewIsNotNil {
    XCTAssertNotNil(self.searchResultView, @"view is not supposed to be nil.");
    XCTAssertNotNil(self.searchResultView.tableView, @"table view is not nil.");
}


- (void)testDelegate {
    XCTAssertNotNil(self.searchResultView.tableView.delegate, @"delegate should not be nil.");
    XCTAssertNotNil(self.searchResultView.tableView.dataSource, @"datasource should not be nil.");
}

- (void)testNumberOfRows {
    
    NSInteger numOfRows = [self.searchResultView tableView:self.searchResultView.tableView numberOfRowsInSection:0];
    
    XCTAssertTrue(numOfRows == [self.searchResultView.searchResults.searchResultViewModels count], @"number of rows should be equal to models");
}

- (void)testCellInitialization {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    id<UITableViewDataSource> dataSource = self.searchResultView;
    SearchResultTableViewCell *cell = (SearchResultTableViewCell *)[dataSource tableView:self.searchResultView.tableView cellForRowAtIndexPath:indexPath];
    
    XCTAssertNotNil(cell, @"cell should not be nil.");
}

- (void)testLoadMoreOnScroll {
    
    self.searchResultView.isLoadingMoreResults = NO;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    id<UITableViewDataSource> dataSource = self.searchResultView;
    [dataSource tableView:self.searchResultView.tableView cellForRowAtIndexPath:indexPath];
    
    XCTAssertTrue(self.searchResultView.isLoadingMoreResults, @"should start loading.");
}

- (void)testSearchBarClickedCancel {
    self.searchResultView.wikiSearchBar.text = @"foo fighters";
    
    self.searchResultView.selectedTitle = @"foo fighters";
    
    id <UISearchBarDelegate> delegate = self.searchResultView;
    
    [delegate searchBarCancelButtonClicked:self.searchResultView.wikiSearchBar];
    
    XCTAssertTrue([self.searchResultView.wikiSearchBar.text isEqualToString:@""], @"wiki search bar should be empty.");
    
    XCTAssertTrue([self.searchResultView.selectedTitle isEqualToString:@""], @"selected title should be empty");
    
    XCTAssertTrue([self.searchResultView.searchResults.searchResultViewModels count] == 0, @"search results should be cleared.");
}

- (void)testNotificationHandler {
    
    JMRMockAlertViewVerifier *verifier = [[JMRMockAlertViewVerifier alloc] init];
    
    NSNotification *notif = [[NSNotification alloc] initWithName:kWikiServiceSearchResultsNotification
                                                          object:nil
                                                        userInfo:@{kErrorKey : @"error"}];
    [self.searchResultView _handleSearchDidCompleteNotification:notif];
    
    XCTAssertEqual(verifier.showCount, 1, @"show count should be 1.");
    XCTAssertEqualObjects(verifier.title, @"ERROR", @"title is not correct.");
    XCTAssertNotNil(verifier.message, @"message should not be null");
    XCTAssertEqualObjects(verifier.cancelButtonTitle, @"OK");
    
    notif = nil;
    
    // No results test
    
    notif = [[NSNotification alloc] initWithName:kWikiServiceSearchResultsNotification
                                          object:nil
                                        userInfo:@{kErrorKey : @""}];
    
    [self.searchResultView.searchResults.searchResultViewModels removeAllObjects];
    
    [self.searchResultView _handleSearchDidCompleteNotification:notif];
    
    XCTAssertEqual(verifier.showCount, 2, @"show count should be 1.");
    XCTAssertEqualObjects(verifier.title, @"", @"title is not correct.");
    XCTAssertNotNil(verifier.message, @"No search results found.");
    XCTAssertEqualObjects(verifier.cancelButtonTitle, @"OK");
    
}

@end
