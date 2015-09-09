//
//  WikiPageViewModel.m
//  WikiSearch
//
//  Created by Trivedi, Astha on 09/09/15.
//  Copyright (c) 2015 Astha. All rights reserved.
//

#import "WikiPageViewModel.h"

#import "Utils.h"

@implementation WikiPageViewModel

- (void)setupUrlString:(NSString *)urlSearchTerm {
    
    NSString *preparedString = [urlSearchTerm stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    self.urlString = [NSString stringWithFormat:kWikiPageUrlString,preparedString];
}

@end
