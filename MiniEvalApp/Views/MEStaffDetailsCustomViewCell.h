//
//  MEStaffDetailsCustomViewCell.h
//  MiniEvalApp
//
//  Created by viet on 1/23/13.
//  Copyright (c) 2013 2359media. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MEStaffDetailsCustomViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *imageCell;

@property (strong, nonatomic) IBOutlet UILabel *textCell;

- (void)setContentData :(NSDictionary *)dictionary
                atIndex:(NSIndexPath *)indexPath;

- (void)resetDefaultFrame;


@end
