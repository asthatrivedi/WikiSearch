//
//  JMRMockAlertViewViewVerifier.h
//  Copyright 2013 Jonathan M. Reid. See LICENSE.txt
//

@import Foundation;


/**
    Captures JMRMockAlertView arguments.
 */
@interface JMRMockAlertViewVerifier : NSObject

@property (nonatomic, assign) NSUInteger showCount;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, strong) id delegate;
@property (nonatomic, copy) NSString *cancelButtonTitle;
@property (nonatomic, copy) NSArray *otherButtonTitles;
@property (nonatomic, assign) NSInteger tag;

- (id)init;

@end
