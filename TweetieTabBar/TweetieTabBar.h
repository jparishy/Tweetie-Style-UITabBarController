//
//  TweetieTabBar.h
//  TweetieTabBar
//
//  Created by Julius Parishy on 8/13/11.
//  Copyright 2011 DiDev Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TweetieTabBarController;

@interface TweetieTabBar : UIView {
    
}

@property (nonatomic, assign) TweetieTabBarController* tabBarController;
@property (nonatomic, assign) CGPoint tabBarIndicatorPosition;

-(id)initWithFrame:(CGRect)frame tabBarController:(TweetieTabBarController*)theTabBarController;

-(void)moveIndicatorToPoint:(CGPoint)point animated:(BOOL)animated;
-(void)moveIndicatorToViewControllerIndex:(NSUInteger)index animated:(BOOL)animated;

-(void)setupButtons;
-(void)tabBarButtonPressed:(UIButton*)sender;

@end
