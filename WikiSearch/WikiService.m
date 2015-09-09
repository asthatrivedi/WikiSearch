//
//  WikiService.m
//  WikiSearch
//
//  Created by Trivedi, Astha on 07/09/15.
//  Copyright (c) 2015 Astha. All rights reserved.
//

#import "WikiService.h"
#import <AFNetworking/AFNetworking.h>

#import "AppDelegate.h"
#import "SearchResult.h"
#import "SearchResultListViewModel.h"
#import "Utils.h"

NSString * const kWikiSearchAPI = @"https://en.wikipedia.org/w/api.php?action=query&list=search&format=json&srsearch=%@";

@interface WikiService ()

@property (nonatomic, strong) NSArray *searchResults;
@property (nonatomic, strong) SearchResultListViewModel *resultListModel;

@end

@implementation WikiService

#pragma mark - Singleton Initializer

+ (instancetype)sharedService {
    
    static dispatch_once_t dispatchOnce;
    static WikiService *sharedService;
    
    dispatch_once(&dispatchOnce, ^{
        sharedService = [[WikiService alloc] init];
    });
    
    return sharedService;
}

#pragma mark - Public Methods

- (SearchResultListViewModel *)searchResultList {
    return self.resultListModel;
}

- (void)wikiSearchForTerm:(NSString *)searchTerm {
    
    NSString *searchTermForUrl = [WikiService _makeSearchStringReadyForUrl:searchTerm];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:kWikiSearchAPI, searchTermForUrl]];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    __weak NSManagedObjectContext *managedContext =
        ((AppDelegate *)[[UIApplication sharedApplication] delegate]).managedObjectContext;
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *searchDict = responseObject[@"query"];
        self.searchResults = [SearchResult parseSearchResultJson:searchDict[@"search"]
                                                   manageContext:managedContext];
        
        NSError *error = nil;
        
        [managedContext save:&error];
        
        NSString *errorString;
        if (error) {
            NSLog(@"error %@", error.description);
            errorString = error.description;
        }
        else {
            NSLog(@"success");
            self.resultListModel = [SearchResultListViewModel viewModelWithResultFetchObjects:self.searchResults];
        }
        [self _contentAddedNotificationForError:errorString];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        
        [self _contentAddedNotificationForError:error.description];
    }];
    
    [operation start];
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

@end
