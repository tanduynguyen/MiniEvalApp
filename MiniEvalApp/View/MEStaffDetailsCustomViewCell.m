//
//  MEStaffDetailsCustomViewCell.m
//  MiniEvalApp
//
//  Created by viet on 1/23/13.
//  Copyright (c) 2013 2359media. All rights reserved.
//

#import "MEStaffDetailsCustomViewCell.h"


@implementation MEStaffDetailsCustomViewCell

- (void)setContentData :(NSDictionary *)dictionary
{    
    if (self) {
        if ([dictionary objectForKey:@"imageCell"]) {
            [self.imageCell setImage:[UIImage imageNamed:[dictionary objectForKey:@"imageCell"]]];
        }
        
        self.textCell.text = [dictionary objectForKey:@"textCell"];
        
        if ([dictionary objectForKey:@"sizeAmount"]) {
            CGRect customframe = self.imageCell.frame;
            customframe.origin.x = customframe.origin.y = [(NSNumber *)[dictionary objectForKey:@"topleft"] intValue];            
            customframe.size.height = customframe.size.width = [(NSNumber *)[dictionary objectForKey:@"sizeAmount"] intValue];            
            [self.imageCell setFrame:customframe];
        }
       
        if ([dictionary objectForKey:@"tag"]) {
            [self setTag:[(NSNumber *)[dictionary objectForKey:@"tag"] intValue]];
        }
        
        [self.textCell setNumberOfLines:0];
        [self.textCell setLineBreakMode:NSLineBreakByWordWrapping];
    }    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
