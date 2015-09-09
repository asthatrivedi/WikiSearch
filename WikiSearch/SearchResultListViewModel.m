//
//  SearchResultListViewModel.m
//  WikiSearch
//
//  Created by Trivedi, Astha on 08/09/15.
//  Copyright (c) 2015 Astha. All rights reserved.
//

#import "SearchResultListViewModel.h"

#import "SearchResult.h"
#import "SearchResultViewModel.h"

@implementation SearchResultListViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _searchResultViewModels = [NSMutableArray array];
    }
    return self;
}

- (void)viewModelWithResultFetchObjects:(NSArray *)inFetchedObjects {
    [self.searchResultViewModels addObjectsFromArray:[SearchResultListViewModel _parseFetchObjectsIntoViewModel:inFetchedObjects]];
}

#pragma mark - Private Helper Methods

+ (NSArray  *)_parseFetchObjectsIntoViewModel:(NSArray *)fetchObjects {
    
    NSMutableArray *viewModels = [NSMutableArray array];
    for (SearchResult *result in fetchObjects) {
        [viewModels addObject:[SearchResultViewModel resultViewModelWithResult:result]];
    }
    
    return viewModels;
}


@end
