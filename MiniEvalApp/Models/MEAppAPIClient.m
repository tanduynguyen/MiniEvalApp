//
//  MEAppAPIClient.m
//  MiniEvalApp
//
//  Created by viet on 1/21/13.
//  Copyright (c) 2013 2359media. All rights reserved.
//

#import "MEAppAPIClient.h"

@implementation MEAppAPIClient

+ (id)sharedInstance {
    static MEAppAPIClient *__sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __sharedInstance = [[MEAppAPIClient alloc] initWithBaseURL:
                            [NSURL URLWithString:kAppAPIBaseURLString]];
    });
    
    return __sharedInstance;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (self) {
        //custom settings
        [self setDefaultHeader:@"x-api-token" value:kAppAPIToken];
        
        
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    }
    
    return self;
}


@end
