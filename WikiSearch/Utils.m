//
//  Utils.m
//  WikiSearch
//
//  Created by Trivedi, Astha on 07/09/15.
//  Copyright (c) 2015 Astha. All rights reserved.
//

#import "Utils.h"

NSString * const kErrorKey = @"isError";
NSString * const kWikiServiceSearchResultsNotification = @"com.astha.WikiSearch.SearchResults";

@implementation Utils

+ (NSDate *)dateForString:(NSString *)dateString {
    
    NSString *readyString = [dateString stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ssZ"];
    
    return [formatter dateFromString:readyString];
}

+ (NSString *)stringForDate:(NSDate *)date {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ssZ"];
    
    return [formatter stringFromDate:date];
}

@end
