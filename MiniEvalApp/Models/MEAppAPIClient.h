//
//  MEAppAPIClient.h
//  MiniEvalApp
//
//  Created by viet on 1/21/13.
//  Copyright (c) 2013 2359media. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface MEAppAPIClient : AFHTTPClient

+ (id) sharedInstance;

@end
