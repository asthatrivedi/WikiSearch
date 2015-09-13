//
//  NetworkService.h
//  WikiSearch
//
//  Created by Trivedi, Astha on 09/09/15.
//  Copyright (c) 2015 Astha. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkService : NSObject

+ (instancetype)sharedService;

- (void)operationWith:(NSURL *)url
        completionWithSuccess:(void (^)(id responseObject))completionBlock
        withFailure:(void (^)(NSError *error))errorBlock;

@end
