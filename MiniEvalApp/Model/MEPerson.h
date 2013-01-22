//
//  MEPerson.h
//  MiniEvalApp
//
//  Created by viet on 1/21/13.
//  Copyright (c) 2013 2359media. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MEPerson : NSObject

@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *userName;
@property (nonatomic,strong) NSDate *timeStamp;
@property (nonatomic,strong) NSString *role;
@property (nonatomic,strong) NSString *like;
@property (nonatomic,strong) NSString *dislike;

@property (nonatomic) int visitedCount;

- (id)initWithDictionary:(NSDictionary *)personDictionary;


@end
