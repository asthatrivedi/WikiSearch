//
//  SearchResult.m
//  WikiSearch
//
//  Created by Trivedi, Astha on 08/09/15.
//  Copyright (c) 2015 Astha. All rights reserved.
//

#import "SearchResult.h"

#import "Utils.h"

@implementation SearchResult

@dynamic resultId;
@dynamic title;
@dynamic timestamp;


NSString * const kTitle = @"title";
NSString * const kTimestamp = @"timestamp";
NSString * const kContainsPredicate = @"title contains[c] %@";
NSString * const kResultIDPredicate = @"resultId == %ld";

+ (NSArray *)getSearchResultFromCoreDataIfExists:(NSString *)title manageContext:(NSManagedObjectContext *)context {
    
    NSFetchRequest *fetch = [NSFetchRequest fetchRequestWithEntityName:@"SearchResult"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:kContainsPredicate, title];
    [fetch setPredicate:predicate];
    
    NSError *error = nil;
    
    return [context executeFetchRequest:fetch error:&error];
}

+ (NSArray *)parseSearchResultJson:(NSArray *)resultJson manageContext:(NSManagedObjectContext *)context {
    
    NSMutableArray *inResults = [NSMutableArray array];
    for (NSDictionary *inResult in resultJson) {
        [inResults addObject:[SearchResult _parseIndividualSearchResultJson:inResult manageContext:context]];
    }
    
    return inResults;
}


#pragma mark - Private Helper Methods


+ (SearchResult *)_parseIndividualSearchResultJson:(NSDictionary *)resultJson
                                   manageContext:(NSManagedObjectContext *)context {
    
    // Fetch first to ensure there are no duplicate entries.
    NSString *inTitle = resultJson[kTitle];

    NSFetchRequest *fetch = [NSFetchRequest fetchRequestWithEntityName:kSerachResultEntityKey];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:kResultIDPredicate, @(inTitle.hash)];
    [fetch setPredicate:predicate];
    
    NSError *error = nil;
    
    NSArray *results = [context executeFetchRequest:fetch error:&error];
    
    SearchResult *inResult;
    
    if ([results count] == 0) {
        
        // Add a new entry.
        inResult =
            (SearchResult *)[NSEntityDescription insertNewObjectForEntityForName:kSerachResultEntityKey
                                                         inManagedObjectContext:context];
        
        
        inResult.title = inTitle;
        inResult.resultId = @(inTitle.hash);
        inResult.timestamp = [Utils dateForString:resultJson[kTimestamp]];
    }
    else {
        inResult = [results firstObject];
    }
    
    return inResult;
}


@end
