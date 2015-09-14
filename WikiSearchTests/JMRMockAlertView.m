//
//  JMRMockAlertView.m
//  Copyright 2013 Jonathan M. Reid. See LICENSE.txt
//

#import "JMRMockAlertView.h"

NSString *const JMRMockAlertViewShowNotification = @"JMRMockAlertViewShowNotification";


@implementation JMRMockAlertView

- (id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate
  cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    self = [super init];
    if (self)
    {
        _title = [title copy];
        _message = [message copy];
        _delegate = delegate;
        _cancelButtonTitle = [cancelButtonTitle copy];
        
        _otherButtonTitles = [[NSMutableArray alloc] init];
        va_list args;
        va_start(args, otherButtonTitles);
        for (NSString *title = otherButtonTitles; title != nil; title = va_arg(args, NSString *))
            [_otherButtonTitles addObject:title];
        va_end(args);
    }
    return self;
}

- (void)show
{
    [[NSNotificationCenter defaultCenter] postNotificationName:JMRMockAlertViewShowNotification
                                                        object:self
                                                      userInfo:nil];
}

- (NSInteger)addButtonWithTitle:(NSString *)title
{
	if (self.cancelButtonTitle.length == 0)
	{
		self.cancelButtonTitle = [title copy];
		return 0;
	}
	else
	{
		[self.otherButtonTitles addObject:title];
		return self.otherButtonTitles.count - 2;
	}
}

@end
