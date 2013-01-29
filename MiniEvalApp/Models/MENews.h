//
//  MENews.h
//  MiniEvalApp
//
//  Created by viet on 1/21/13.
//  Copyright (c) 2013 2359media. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MENews : NSObject

@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *publishedDate;
@property (nonatomic,strong) NSString *link;
@property (nonatomic,strong) NSString *content;
@property (nonatomic,strong) NSString *categories;
@property (nonatomic,strong) NSString *author;
@property (nonatomic,strong) NSString *contentSnippet;

- (id)initWithDictionary:(NSDictionary *)newsDictionary;

@end
