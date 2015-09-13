//
//  NetworkService.m
//  WikiSearch
//
//  Created by Trivedi, Astha on 09/09/15.
//  Copyright (c) 2015 Astha. All rights reserved.
//

#import "NetworkService.h"

@interface NetworkService ()

@end

@implementation NetworkService

#pragma mark - Singleton Initializer

+ (instancetype)sharedService {
    
    static dispatch_once_t dispatchOnce;
    static NetworkService *sharedService;
    
    dispatch_once(&dispatchOnce, ^{
        sharedService = [[NetworkService alloc] init];
    });
    
    return sharedService;
}

- (void)operationWith:(NSURL *)url
        completionWithSuccess:(void (^)(id responseObject))completionBlock
        withFailure:(void (^)(NSError *error))errorBlock
{
    
    NSURLSession *session = [NSURLSession sharedSession];
    
        [[session dataTaskWithURL:url
                completionHandler:^(NSData *data,
                                    NSURLResponse *response,
                                    NSError *error) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (data && !error) {
                            
                            NSError *parseError = nil;
                            
                            id responseObject = [NSJSONSerialization JSONObjectWithData:data
                                                                                options:kNilOptions
                                                                                  error:&parseError];
                            if (parseError) {
                                errorBlock(parseError);
                            }
                            else {
                                completionBlock(responseObject);
                            }
                        }
                        else if (error) {
                            errorBlock(error);
                        }
                    });
                    
                }] resume];
}

@end
