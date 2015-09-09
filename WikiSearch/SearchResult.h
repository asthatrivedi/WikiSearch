//
//  SearchResult.h
//  WikiSearch
//
//  Created by Trivedi, Astha on 08/09/15.
//  Copyright (c) 2015 Astha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SearchResult : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSDate * timestamp;
@property (nonatomic, retain) NSNumber *resultId;

+ (NSArray *)getSearchResultFromCoreDataIfExists:(NSString *)title manageContext:(NSManagedObjectContext *)context;
+ (NSArray *)parseSearchResultJson:(NSArray *)resultJson manageContext:(NSManagedObjectContext *)context;

@end
