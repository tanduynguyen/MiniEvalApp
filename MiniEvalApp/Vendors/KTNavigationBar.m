//
//  KTNavigationBar.m
//  CustomNavBar
//
//  Created by Kirby Turner on 9/11/10.
//  Copyright 2010 White Peak Software Inc. All rights reserved.
//

#import "KTNavigationBar.h"


@implementation KTNavigationBar 

- (void) drawRect:(CGRect)rect
{
   [super drawRect:rect];   
    
    UIColor *DarkOrganColor = UIColorFromRGB(kDarkOrganColor);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColor(context, CGColorGetComponents( [DarkOrganColor CGColor]));
    CGContextFillRect(context, rect);
    self.tintColor = DarkOrganColor;
}

@end
