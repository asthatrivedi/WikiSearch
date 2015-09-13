//
//  Utils_Tests.m
//  WikiSearch
//
//  Created by Trivedi, Astha on 12/09/15.
//  Copyright (c) 2015 Astha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "Utils.h"

@interface Utils_Tests : XCTestCase

@end

@implementation Utils_Tests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testStringForDate {
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = 9;
    dateComponents.year = 2015;
    dateComponents.day = 8;
    dateComponents.hour = 13;
    dateComponents.second = 1;
    dateComponents.minute = 12;
    
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDate *date = [gregorian dateFromComponents:dateComponents];
    NSString *dateString = @"Sep 08, 2015 13:12 PM";
    NSString *string = [Utils stringForDate:date];
    
    XCTAssertTrue([dateString isEqualToString:string], @"date format is not correct.");
}

//- (void)testDateForString {
//    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
//    dateComponents.month = 9;
//    dateComponents.year = 2015;
//    dateComponents.day = 8;
//    dateComponents.hour = 13;
//    dateComponents.second = 1;
//    dateComponents.minute = 12;
//    
//    NSCalendar *gregorian = [[NSCalendar alloc]
//                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
//    
//    NSDate *date = [gregorian dateFromComponents:dateComponents];
//    NSString *dateString = @"2015-09-08 13:12:1Z";
//    NSDate *resultDate = [Utils dateForString:dateString];
//    
//    XCTAssertTrue([date isEqualToDate:resultDate], @"date format is not correct.");
//}

@end
