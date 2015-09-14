//
//  MockNetworkService.h
//  WikiSearch
//
//  Created by Trivedi, Astha on 11/09/15.
//  Copyright (c) 2015 Astha. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MockNetworkService : NSObject

+ (NSArray *)responseDictionaries;
+ (NSError *)serverError;
+ (NSDictionary *)serverSuccessResponse;

@end
