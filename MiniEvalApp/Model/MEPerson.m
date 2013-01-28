//
//  MEPerson.m
//  MiniEvalApp
//
//  Created by viet on 1/21/13.
//  Copyright (c) 2013 2359media. All rights reserved.
//

#import "MEPerson.h"
#import "MEAppAPIClient.h"

#import "AFImageRequestOperation.h"

NSString * const kUserProfileImageDidLoadNotification = @"com.alamofire.user.profile-image.loaded";

#ifdef __MAC_OS_X_VERSION_MIN_REQUIRED
@interface MEPerson ()
+ (NSOperationQueue *)sharedProfileImageRequestOperationQueue;
@end
#endif


@implementation MEPerson{
@private
    NSString *_avatarImageURLString;
    AFImageRequestOperation *_avatarImageRequestOperation;
}


- (void) setTimeStamp:(NSDate *)timeStamp
{
    if (!_timeStamp) {
        _timeStamp = [[NSDate alloc] init];
    }
    _timeStamp = timeStamp;
}

- (void) setAvatar:(UIImage *)avatar
{
    if (!_avatar) {
        _avatar = [[UIImage alloc] init];
    }
    _avatar = avatar;
}

- (id)initWithDictionary:(NSDictionary *)personDictionary
{
    self = [super init];
    
    if (self) {
        self.userId = [[personDictionary objectForKey:@"_id"] objectForKey:@"$oid"];
        self.name = [NSString stringWithUTF8String:[(NSString *)[personDictionary objectForKey:@"name"] UTF8String]];
        self.userName = [personDictionary objectForKey:@"userName"];
        self.role = [personDictionary objectForKey:@"role"];
        self.like = [personDictionary objectForKey:@"like"];
        self.dislike = [personDictionary objectForKey:@"dislike"];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"M/d/yy HH:mm";
        self.timeStamp = [dateFormatter dateFromString:[personDictionary objectForKey:@"timeStamp"]];
        self.gender = [personDictionary objectForKey:@"gender"];
        self.image = [personDictionary objectForKey:@"image"];
        self.contact = [personDictionary objectForKey:@"contact"];
    }
    
    return self;
}

+ (void)globalTimelineContactsWithBlock:(void (^)(NSMutableArray *results, NSError *error))block
{
    [[MEAppAPIClient sharedInstance] getPath:kAppAPIPath parameters:nil
                                     success:^(AFHTTPRequestOperation *operation, id response) {
                                         
                                         NSMutableArray *persons = [NSMutableArray arrayWithCapacity:[response count]];
                                         
                                         for (id obj in response)
                                         {
                                             if ([obj isKindOfClass:[NSDictionary class]]) {
                                                 MEPerson *person = [[MEPerson alloc] initWithDictionary:(NSDictionary *)obj];
                                                 [persons addObject:person];
                                             }
                                         }                                         
                                         
                                         if (block) {
                                             block([NSMutableArray arrayWithArray:persons], nil);
                                         }
                                     }
                                     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         if (block) {
                                             block([NSMutableArray array], error);
                                         }
                                     }];
}


- (NSURL *)avatarImageURL
{
    return [NSURL URLWithString:_avatarImageURLString];
}

- (void)encodeWithCoder:(NSCoder *)Coder
{
    [Coder encodeObject:self.userName forKey:@"userName"];
    [Coder encodeObject:self.visitedCount forKey:@"visitedCount"];
}

- (id)initWithCoder:(NSCoder *)Decoder
{
    self = [super init];
    if (self) {
        _userName = [Decoder decodeObjectForKey:@"userName"];
        _visitedCount = [Decoder decodeObjectForKey:@"visitedCount"];
    }
    return self;
}

+ (void)findHighestVisitedCount:(NSArray *)persons
{
    MEPerson *p = [[MEPerson alloc] init];
    for (MEPerson *person in persons) {
        if ([p.visitedCount unsignedIntValue] < [person.visitedCount unsignedIntValue]) {
            p = person;
        }
    }
    p.highestVisitedCount = YES;
}

#ifdef __MAC_OS_X_VERSION_MIN_REQUIRED

@synthesize profileImage = _profileImage;

+ (NSOperationQueue *)sharedProfileImageRequestOperationQueue {
    static NSOperationQueue *_sharedProfileImageRequestOperationQueue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedProfileImageRequestOperationQueue = [[NSOperationQueue alloc] init];
        [_sharedProfileImageRequestOperationQueue setMaxConcurrentOperationCount:8];
    });
    
    return _sharedProfileImageRequestOperationQueue;
}

- (NSImage *)profileImage {
	if (!_profileImage && !_avatarImageRequestOperation) {
		_avatarImageRequestOperation = [AFImageRequestOperation imageRequestOperationWithRequest:[NSURLRequest requestWithURL:self.avatarImageURL] success:^(NSImage *image) {
			self.profileImage = image;
            
			_avatarImageRequestOperation = nil;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kUserProfileImageDidLoadNotification object:self userInfo:nil];
		}];
        
		[_avatarImageRequestOperation setCacheResponseBlock:^NSCachedURLResponse *(NSURLConnection *connection, NSCachedURLResponse *cachedResponse) {
			return [[NSCachedURLResponse alloc] initWithResponse:cachedResponse.response data:cachedResponse.data userInfo:cachedResponse.userInfo storagePolicy:NSURLCacheStorageAllowed];
		}];
		
        [[[self class] sharedProfileImageRequestOperationQueue] addOperation:_avatarImageRequestOperation];
	}
	
	return _profileImage;
}

#endif

@end
