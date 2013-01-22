//
//  MENews.m
//  MiniEvalApp
//
//  Created by viet on 1/21/13.
//  Copyright (c) 2013 2359media. All rights reserved.
//

#import "MENews.h"

@implementation MENews



- (id)initWithDictionary:(NSDictionary *)newsDictionary
{
    self = [super init];
    if (self) {
        self.title = [newsDictionary objectForKey:@"title"];
        self.content = [newsDictionary objectForKey:@"content"];
        self.content = [self.content stringByReplacingOccurrencesOfString:@"<src=\"//" withString:@"<src=\"http://"];
        self.publishedDate = [newsDictionary objectForKey:@"publishedDate"];
        self.link = [newsDictionary objectForKey:@"link"];
        self.categories = [newsDictionary objectForKey:@"categories"];
        self.author = [newsDictionary objectForKey:@"link"];
        self.contentSnippet = [newsDictionary objectForKey:@"contentSnippet"];
    }
    
    return self;
}


@end
