//
//  Utils.h
//  WikiSearch
//
//  Created by Trivedi, Astha on 07/09/15.
//  Copyright (c) 2015 Astha. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const kErrorKey;
extern NSString * const kWikiServiceSearchResultsNotification;
extern NSString * const kWikiPageUrlString;

@interface Utils : NSObject

+ (NSDate *)dateForString:(NSString *)dateString;
+ (NSString *)stringForDate:(NSDate *)date;

@end
