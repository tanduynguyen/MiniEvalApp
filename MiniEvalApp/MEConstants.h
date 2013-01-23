//
//  MEConstants.h
//  MiniEvalApp
//
//  Created by viet on 1/21/13.
//  Copyright (c) 2013 2359media. All rights reserved.
//

#import <Foundation/Foundation.h>


#define STAFFS_KEY @"MEExtendStaffTableViewController.2359Staffs"

#define UIColorFromRGBWithAlpha(rgbValue, alphaValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:alphaValue];

#define UIColorFromRGB(rgbValue) UIColorFromRGBWithAlpha(rgbValue, 1.0);

@interface MEConstants : NSObject

extern NSString * const kAppAPIBaseURLString;
extern NSString * const kAppAPIPath;
extern NSString * const kAppAPIToken;
extern NSString * const kAppJSONPath;
extern int const kLightOrganColor;
extern int const kDarkOrganColor;
extern int const kMainColor;
extern int const kLightBlueColor;
extern int const kDarkBlueColor;

@end
