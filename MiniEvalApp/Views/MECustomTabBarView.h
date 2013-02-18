//
//  MECustomTabBarView.h
//  MiniEvalApp
//
//  Created by viet on 1/25/13.
//  Copyright (c) 2013 2359media. All rights reserved.
//

#import <UIKit/UIKit.h>


//Delegate methods for responding to TabBar events
@protocol MECustomTabBarDelegate <NSObject>

//Handle tab bar touch events, sending the index of the selected tab
-(void)tabWasSelected:(NSInteger)index;

@end


@interface MECustomTabBarView : UIView

@property (nonatomic, assign) NSObject<MECustomTabBarDelegate> *delegate;


@end
