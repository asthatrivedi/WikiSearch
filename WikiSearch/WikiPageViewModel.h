//
//  WikiPageViewModel.h
//  WikiSearch
//
//  Created by Trivedi, Astha on 09/09/15.
//  Copyright (c) 2015 Astha. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WikiPageViewModel : NSObject

@property (nonatomic, strong) NSString *urlString;

- (void)setupUrlString:(NSString *)urlSearchTerm;

@end
