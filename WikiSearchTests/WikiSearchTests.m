//
//  WikiSearchTests.m
//  WikiSearchTests
//
//  Created by Trivedi, Astha on 07/09/15.
//  Copyright (c) 2015 Astha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <CoreData/CoreData.h>
#import <OCMock/OCMock.h>

#import "AppDelegate.h"
#import "MockNetworkService.h"
#import "SearchResult.h"
#import "Utils.h"
#import "WikiService.h"

@interface WikiService (UnitTests)

@property (nonatomic, strong) NSMutableArray *searchResults;
@property (nonatomic, strong) SearchResultListViewModel *resultListModel;

- (void)_contentAddedNotificationForError:(NSString *)errorDescription;
- (void)_deleteAllEntities:(NSString *)nameEntity;
- (void)_searchTermFromServer:(NSString *)searchTerm isReload:(BOOL)isReload;
+ (NSString *)_makeSearchStringReadyForUrl:(NSString *)searchString;

@end

@interface WikiSearchTests : XCTestCase

@property (nonatomic, strong) id mockWikiService;


@end

@implementation WikiSearchTests

- (void)setUp {
    [super setUp];
    
    self.mockWikiService = OCMPartialMock([WikiService sharedService]);
}

- (void)tearDown {
    [self.mockWikiService stopMocking];
    [super tearDown];
}

- (void)testIfweSearchCoreDataIfDataPresent {
    
    __weak NSManagedObjectContext *managedContext =
        ((AppDelegate *)[[UIApplication sharedApplication] delegate]).managedObjectContext;
    
    [SearchResult parseSearchResultJson:[MockNetworkService responseDictionaries] manageContext:managedContext];
    
    [[self.mockWikiService expect] _contentAddedNotificationForError:nil];
    
    [self.mockWikiService wikiSearchForTerm:@"foo fighters"];
    
    [self.mockWikiService verify];
}

- (void)testIfWeCallServerIfDataNotPresent {
    
    [self.mockWikiService _deleteAllEntities:kSerachResultEntityKey];
    
    [[self.mockWikiService expect] _searchTermFromServer:@"foo fighters" isReload:NO];
    
    [self.mockWikiService wikiSearchForTerm:@"foo fighters"];
    
    [self.mockWikiService verify];
}

- (void)testDeletingAllEntries {
    
    __weak NSManagedObjectContext *managedContext =
        ((AppDelegate *)[[UIApplication sharedApplication] delegate]).managedObjectContext;
    
    [SearchResult parseSearchResultJson:[MockNetworkService responseDictionaries] manageContext:managedContext];
    
    [self.mockWikiService _deleteAllEntities:kSerachResultEntityKey];
    
    NSArray *results = [SearchResult getSearchResultFromCoreDataIfExists:@"foo fighters" manageContext:managedContext];
    
    XCTAssertTrue([results count] == 0, @"there should be no data in Core Data");
}

- (void)testUrlPrepMethod {
    NSString *testString = @"foo fighters";
    NSString *resultString = @"foo%20fighters";
    
    NSString *preppedString = [WikiService _makeSearchStringReadyForUrl:testString];
    
    XCTAssertTrue([resultString isEqualToString:preppedString],@"strings not getting prepped properly.");
    
    testString = @"foofighters";
    
    XCTAssertTrue([testString isEqualToString:[WikiService _makeSearchStringReadyForUrl:testString]], @"strings not getting prepped properly.");
}



@end
