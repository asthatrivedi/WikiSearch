//
//  SearchResultListViewModel.h
//  WikiSearch
//
//  Created by Trivedi, Astha on 08/09/15.
//  Copyright (c) 2015 Astha. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchResultListViewModel : NSObject

@property (nonatomic, strong) NSMutableArray *searchResultViewModels;

- (void)viewModelWithResultFetchObjects:(NSArray *)inFetchedObjects;

@end
