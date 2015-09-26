//
//  APImanager.m
//  API_II
//
//  Created by Natalia Estrella on 9/20/15.
//  Copyright © 2015 Natalia Estrella. All rights reserved.
//

#import "APImanager.h"

@implementation APImanager

//creating a method
+ (void)GETRequestWithURL:(NSURL *)URL
        completionHandler:(void(^)(NSData *data, NSURLResponse *response, NSError *error)) completionHandler {
    
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *task = [session dataTaskWithURL:URL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completionHandler(data, response, error);
        });
    }];
    
    [task resume];
    
}


@end
