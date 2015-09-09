//
//  WikiPageViewController.h
//  WikiSearch
//
//  Created by Trivedi, Astha on 09/09/15.
//  Copyright (c) 2015 Astha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

#import "WikiPageViewModel.h"

@interface WikiPageViewController : UIViewController <WKNavigationDelegate>

- (void)setupViewModel:(WikiPageViewModel *)inViewModel;

@end
