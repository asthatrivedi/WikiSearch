//
//  SearchResultViewModel.h
//  WikiSearch
//
//  Created by Trivedi, Astha on 08/09/15.
//  Copyright (c) 2015 Astha. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SearchResult.h"

@interface SearchResultViewModel : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *timestamp;

+ (SearchResultViewModel *)resultViewModelWithResult:(SearchResult *)result;

@end
