//
//  APImanager.h
//  API_II
//
//  Created by Natalia Estrella on 9/20/15.
//  Copyright © 2015 Natalia Estrella. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APImanager : NSObject

+ (void)GETRequestWithURL:(NSURL *)URL
        completionHandler:(void(^)(NSData *data, NSURLResponse *response, NSError *error)) completionHandler ;

@end
