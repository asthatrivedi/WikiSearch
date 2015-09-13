//
//  WikiService.m
//  WikiSearch
//
//  Created by Trivedi, Astha on 07/09/15.
//  Copyright (c) 2015 Astha. All rights reserved.
//

#import "WikiService.h"

#import "AppDelegate.h"
#import "NetworkService.h"
#import "SearchResult.h"
#import "SearchResultListViewModel.h"
#import "Utils.h"

NSString * const kWikiSearchAPI = @"https://en.wikipedia.org/w/api.php?action=query&list=search&format=json&srsearch=%@";
NSString * const kWikiSearchMoreAPI = @"https://en.wikipedia.org/w/api.php?action=query&list=search&format=json&srsearch=%@&srprop=timestamp&sroffset=%ld";

@interface WikiService ()

@property (nonatomic, strong) NSMutableArray *searchResults;
@property (nonatomic, strong) SearchResultListViewModel *resultListModel;

@end

@implementation WikiService

#pragma mark - Singleton Initializer

+ (instancetype)sharedService {
    
    static dispatch_once_t dispatchOnce;
    static WikiService *sharedService;
    
    dispatch_once(&dispatchOnce, ^{
        sharedService = [[WikiService alloc] init];
        sharedService.searchResults = [[NSMutableArray alloc] init];
    });
    
    return sharedService;
}

#pragma mark - Public Methods

- (SearchResultListViewModel *)searchResultList {
    return self.resultListModel;
}

- (void)wikiSearchForTerm:(NSString *)searchTerm {
    
    __weak NSManagedObjectContext *managedContext =
        ((AppDelegate *)[[UIApplication sharedApplication] delegate]).managedObjectContext;
    
    [self.searchResults removeAllObjects];
    [self.searchResults addObjectsFromArray:[SearchResult getSearchResultFromCoreDataIfExists:searchTerm manageContext:managedContext]];
    
    if ([self.searchResults count] > 0) {
        if (!self.resultListModel) {
            self.resultListModel = [[SearchResultListViewModel alloc] init];
        }
        [self.resultListModel viewModelWithResultFetchObjects:self.searchResults];
        [self _contentAddedNotificationForError:nil];
    }
    else {
        [self _searchTermFromServer:searchTerm isReload:NO];
    }
}

- (void)loadMoreSearchResultsForTerm:(NSString *)searchTerm {
    [self _searchTermFromServer:searchTerm isReload:YES];
}


#pragma mark - Private Helper Methods

+ (NSString *)_makeSearchStringReadyForUrl:(NSString *)searchString {
    return [searchString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
}

- (void)_contentAddedNotificationForError:(NSString *)errorDescription {
    static NSNotification *notification = nil;
    static dispatch_once_t onceToken;
    
    if (!errorDescription)
        errorDescription = @"";
    
    dispatch_once(&onceToken, ^{
        
        notification = [NSNotification notificationWithName:kWikiServiceSearchResultsNotification
                                                     object:nil
                                                   userInfo:@{kErrorKey : errorDescription}];
    });
    
    [[NSNotificationQueue defaultQueue] enqueueNotification:notification
                                               postingStyle:NSPostASAP
                                               coalesceMask:NSNotificationCoalescingOnName
                                                   forModes:nil];
}

// added for testing and future use.
- (void)_deleteAllEntities:(NSString *)nameEntity
{
    __weak NSManagedObjectContext *managedContext =
        ((AppDelegate *)[[UIApplication sharedApplication] delegate]).managedObjectContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:nameEntity];
    [fetchRequest setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    
    NSError *error;
    NSArray *fetchedObjects = [managedContext executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *object in fetchedObjects)
    {
        [managedContext deleteObject:object];
    }
    
    error = nil;
    [managedContext save:&error];
}

- (void)_searchTermFromServer:(NSString *)searchTerm isReload:(BOOL)isReload {
    
    NSString *searchTermForUrl = [WikiService _makeSearchStringReadyForUrl:searchTerm];
    NSString *searchUrlString = [NSString stringWithFormat:kWikiSearchAPI, searchTermForUrl];
    if (isReload) {
        NSInteger offset = [self.searchResults count];
        searchUrlString = [NSString stringWithFormat:kWikiSearchMoreAPI, searchTermForUrl, (long)offset];
    }

    NSURL *url = [NSURL URLWithString:searchUrlString];
    
    __weak NSManagedObjectContext *managedContext =
    ((AppDelegate *)[[UIApplication sharedApplication] delegate]).managedObjectContext;
    
    [[NetworkService sharedService] operationWith:url completionWithSuccess:^(id responseObject) {
        NSDictionary *searchDict = responseObject[kQueryKey];
        NSArray *tempArray = [SearchResult parseSearchResultJson:searchDict[kSearchKey]
                                                   manageContext:managedContext];
        [self.searchResults addObjectsFromArray:tempArray];
        
        NSError *error = nil;
        
        [managedContext save:&error];
        
        NSString *errorString;
        if (error) {
            NSLog(@"error %@", error.description);
            errorString = error.description;
        }
        else {
            NSLog(@"success");
            if (!self.resultListModel) {
                self.resultListModel = [[SearchResultListViewModel alloc] init];
            }
            [self.resultListModel viewModelWithResultFetchObjects:self.searchResults];
        }
        [self _contentAddedNotificationForError:errorString];
        
    } withFailure:^(NSError *error) {
        NSLog(@"Error: %@", error);
        
        [self _contentAddedNotificationForError:error.description];
    }];
}

@end
