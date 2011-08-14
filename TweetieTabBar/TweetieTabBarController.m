//
//  TweetieTabBarController.m
//  TweetieTabBar
//
//  Created by Julius Parishy on 8/13/11.
//  Copyright 2011 DiDev Studios. All rights reserved.
//

#import "TweetieTabBarController.h"

@implementation TweetieTabBarController

@synthesize customTabBar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(void)customTabBarChangedDelegateMethod
{
    // Just calls the delegate method because it won't do it otherwise with the custom tab bar
    if(self.delegate && [self.delegate respondsToSelector:@selector(tabBarController:didSelectViewController:)])
    {
        [self.delegate tabBarController:self didSelectViewController:self.selectedViewController];
    }
}

-(BOOL)customCanSelectViewControllerDelegateMethod:(UIViewController *)viewController
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(tabBarController:shouldSelectViewController:)])
    {
        return [self.delegate tabBarController:self shouldSelectViewController:viewController];
    }
    
    return YES;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Make the built in tab bar invisible
    self.tabBar.hidden = YES;
    
    // Allocate the custom tab bar and add it to the view
    float viewHeight = self.view.frame.size.height;
    customTabBar = [[TweetieTabBar alloc] initWithFrame:CGRectMake(0.0f, viewHeight - (kTweetieTabBarHeight + kTweetieTabBarIndicatorHeight), 320.0f, kTweetieTabBarHeight + kTweetieTabBarIndicatorHeight) tabBarController:self];
    
    [self.view addSubview:self.customTabBar];
    [self.view bringSubviewToFront:self.customTabBar];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)viewDidAppear:(BOOL)animated
{
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
