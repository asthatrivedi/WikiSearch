//
//  WikiPageViewController.m
//  WikiSearch
//
//  Created by Trivedi, Astha on 09/09/15.
//  Copyright (c) 2015 Astha. All rights reserved.
//

#import "WikiPageViewController.h"


@interface WikiPageViewController ()

@property (nonatomic, strong) WikiPageViewModel *viewModel;
@property (nonatomic, strong) WKWebView *webView;

@end

@implementation WikiPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Wikipedia";
    
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc]
                                             init];
    WKUserContentController *controller = [[WKUserContentController alloc]
                                           init];
    configuration.userContentController = controller;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.viewModel.urlString]];
    self.webView = [[WKWebView alloc] initWithFrame:[[UIScreen mainScreen] bounds] configuration:configuration];
    self.webView.navigationDelegate = self;
    [self.view addSubview:self.webView];
    
    [self.webView loadRequest:request];
}

- (void)setupViewModel:(WikiPageViewModel *)inViewModel {
    self.viewModel = inViewModel;
}

#pragma mark - WKWebView Delegate

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERROR"
                                                    message:error.description
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}


@end
