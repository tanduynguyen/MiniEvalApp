//
//  MEPerson.h
//  MiniEvalApp
//
//  Created by viet on 1/21/13.
//  Copyright (c) 2013 2359media. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MEPerson : NSObject

@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSDate *timeStamp;
@property (nonatomic, strong) NSString *role;
@property (nonatomic, strong) NSString *like;
@property (nonatomic, strong) NSString *dislike;
@property (nonatomic, strong) NSString *gender;
@property (nonatomic, strong) NSString *image;
@property (nonatomic, strong) NSString *contact;

@property (nonatomic, strong) NSNumber *visitedCount;
@property (nonatomic) BOOL highestVisitedCount;
@property (unsafe_unretained, readonly) NSURL *avatarImageURL;
@property (nonatomic, strong) UIImage *avatar;

- (id)initWithDictionary:(NSDictionary *)personDictionary;

- (void)encodeWithCoder:(NSCoder *)aCoder;

- (id)initWithCoder:(NSCoder *)aDecoder;

+ (void)findHighestVisitedCount:(NSArray *)persons;

+ (void)globalTimelineContactsWithBlock:(void (^)(NSMutableArray *results, NSError *error))block;

@end
