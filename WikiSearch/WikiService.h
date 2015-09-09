//
//  WikiService.h
//  WikiSearch
//
//  Created by Trivedi, Astha on 07/09/15.
//  Copyright (c) 2015 Astha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SearchResultListViewModel.h"


@interface WikiService : NSObject

+ (instancetype)sharedService;

- (SearchResultListViewModel *)searchResultList;
- (void)wikiSearchForTerm:(NSString *)searchTerm;

@end
