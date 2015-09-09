//
//  SearchResultViewModel.m
//  WikiSearch
//
//  Created by Trivedi, Astha on 08/09/15.
//  Copyright (c) 2015 Astha. All rights reserved.
//

#import "SearchResultViewModel.h"

#import "Utils.h"

@implementation SearchResultViewModel

+ (SearchResultViewModel *)resultViewModelWithResult:(SearchResult *)result {
    
    SearchResultViewModel *viewModel = [[SearchResultViewModel alloc] init];
    viewModel.title = result.title;
    viewModel.timestamp = [Utils stringForDate:result.timestamp];
    
    return viewModel;
}

@end
