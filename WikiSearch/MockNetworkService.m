//
//  MockNetworkService.m
//  WikiSearch
//
//  Created by Trivedi, Astha on 11/09/15.
//  Copyright (c) 2015 Astha. All rights reserved.
//

#import "MockNetworkService.h"

#import "Utils.h"


@implementation MockNetworkService

//+ (id)getMockResponseIsReload:(BOOL)isReload {
//    
//    NSDictionary *dict;
////    if (isReload) {
////        dict = [MockNetworkService responseReloadDictionary];
////    }
////    else {
////        dict = [MockNetworkService responseDictionary];
////    }
//    return dict;
//}

+ (NSArray *)responseDictionaries {
    
    return @[@{@"title" : @"Foo Fighters",
             @"timestamp" : [Utils stringForDate:[NSDate date]]}];
}

+ (NSDictionary *)responseReloadDictionary {
    
    return @{@"title" : @"Nirvana",
             @"timestamp" : [Utils stringForDate:[NSDate date]]};
}


@end
