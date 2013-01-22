//
//  MEPerson.m
//  MiniEvalApp
//
//  Created by viet on 1/21/13.
//  Copyright (c) 2013 2359media. All rights reserved.
//

#import "MEPerson.h"

@implementation MEPerson

@synthesize timeStamp = _timeStamp;

- (void) setTimeStamp:(NSDate *)timeStamp
{
    if (!_timeStamp) {
        _timeStamp = [[NSDate alloc] init];
    }
    _timeStamp = timeStamp;
}

- (id)initWithDictionary:(NSDictionary *)personDictionary
{
    self = [super init];
    
    if (self) {
        self.userId = [[personDictionary objectForKey:@"_id"] objectForKey:@"$oid"];
        self.name = [personDictionary objectForKey:@"name"];
        self.userName = [personDictionary objectForKey:@"userName"];
        self.role = [personDictionary objectForKey:@"role"];
        self.like = [personDictionary objectForKey:@"like"];
        self.dislike = [personDictionary objectForKey:@"dislike"];
        self.timeStamp = [personDictionary objectForKey:@"timeStamp"];        
    }
    
    return self;
}


@end
