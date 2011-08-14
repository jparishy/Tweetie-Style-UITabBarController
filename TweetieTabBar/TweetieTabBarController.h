//
//  TweetieTabBarController.h
//  TweetieTabBar
//
//  Created by Julius Parishy on 8/13/11.
//  Copyright 2011 DiDev Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TweetieTabBar.h"

#define kTweetieTabBarIndicatorHeight (5.0f)
#define kTweetieTabBarHeight (44.0f)

@interface TweetieTabBarController : UITabBarController {
}

@property (nonatomic, retain) TweetieTabBar* customTabBar;

-(void)customTabBarChangedDelegateMethod;
-(BOOL)customCanSelectViewControllerDelegateMethod:(UIViewController*)viewController;

@end
