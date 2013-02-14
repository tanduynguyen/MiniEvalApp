//
//  KTNavigationBar.m
//  CustomNavBar
//
//  Created by Kirby Turner on 9/11/10.
//  Copyright 2010 White Peak Software Inc. All rights reserved.
//

#import "KTNavigationBar.h"
#import "UIColor+MEColor.h"


@implementation KTNavigationBar 

- (void) drawRect:(CGRect)rect
{
   [super drawRect:rect];   
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColor(context, CGColorGetComponents( [[UIColor kDarkOrganColor] CGColor]));
    CGContextFillRect(context, rect);
    self.tintColor = [UIColor kDarkOrganColor];
}

@end
