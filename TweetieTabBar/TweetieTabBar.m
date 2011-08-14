//
//  TweetieTabBar.m
//  TweetieTabBar
//
//  Created by Julius Parishy on 8/13/11.
//  Copyright 2011 DiDev Studios. All rights reserved.
//

#import "TweetieTabBar.h"
#import "TweetieTabBarController.h"

#import <QuartzCore/QuartzCore.h>

@interface TweetieTabBarLayer : CALayer 

@property CGPoint animatableTabBarIndicatorPosition;

@end

@implementation TweetieTabBarLayer
@synthesize animatableTabBarIndicatorPosition;

+(BOOL)needsDisplayForKey:(NSString *)key
{
    if([key isEqualToString:@"animatableTabBarIndicatorPosition"])
    {
        return YES;
    }
    
    return [super needsDisplayForKey:key];
}

-(void)drawInContext:(CGContextRef)context
{
    //NSLog(@"drawInContext:");
    
    CGContextClearRect(context, self.bounds);
    
    CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
    CGRect bottomRect;
    bottomRect.origin.x = 0.0f;
    bottomRect.origin.y = kTweetieTabBarIndicatorHeight;
    bottomRect.size.width = 320.0f;
    bottomRect.size.height = kTweetieTabBarHeight;
    CGContextFillRect(context, bottomRect);
    
    // Draw the overlay (rect, but with the indicator popping out of the top
    
    //CGContextBeginPath(context);
    CGContextMoveToPoint(context, 0.0f, kTweetieTabBarIndicatorHeight);
    CGContextAddLineToPoint(context, animatableTabBarIndicatorPosition.x - kTweetieTabBarIndicatorHeight, kTweetieTabBarIndicatorHeight);
    CGContextAddLineToPoint(context, animatableTabBarIndicatorPosition.x, 1.0f);
    CGContextAddLineToPoint(context, animatableTabBarIndicatorPosition.x + kTweetieTabBarIndicatorHeight, kTweetieTabBarIndicatorHeight);
    CGContextAddLineToPoint(context, 320.0f, kTweetieTabBarIndicatorHeight);
    CGContextAddLineToPoint(context, 320.0f, kTweetieTabBarIndicatorHeight + (kTweetieTabBarHeight / 2.0f));
    CGContextAddLineToPoint(context, 0.0f, kTweetieTabBarIndicatorHeight + (kTweetieTabBarHeight / 2.0f));
    CGContextAddLineToPoint(context, 0.0f, kTweetieTabBarIndicatorHeight);
    CGContextClosePath(context);
    
    CGContextSetFillColorWithColor(context, [UIColor colorWithWhite:0.15 alpha:1.0f].CGColor);
    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    
    CGContextDrawPath(context, kCGPathFillStroke);
    
    [super drawInContext:context];
}

@end


@implementation TweetieTabBar

@synthesize tabBarController;
@synthesize tabBarIndicatorPosition;

- (id)initWithFrame:(CGRect)frame tabBarController:(TweetieTabBarController *)theTabBarController
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        TweetieTabBarLayer* layer = (TweetieTabBarLayer*)self.layer;
        layer.backgroundColor = [UIColor clearColor].CGColor;
        layer.opaque = NO;
        
        self.tabBarController = theTabBarController;
        
        [self setupButtons];
        
        [self moveIndicatorToViewControllerIndex:0 animated:NO];
    }
    return self;
}

+(Class)layerClass
{
    return [TweetieTabBarLayer class];
}

-(void)setupButtons
{
    NSUInteger numViewControllers = [self.tabBarController.viewControllers count];
    CGFloat buttonWidth = self.bounds.size.width / (float)numViewControllers;
    
    for(int i = 0; i < numViewControllers; ++i)
    {
        CGRect buttonRect = CGRectMake(buttonWidth * (float)i, kTweetieTabBarIndicatorHeight, buttonWidth, kTweetieTabBarHeight);
        
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(tabBarButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        button.frame = buttonRect;
        button.tag = i;
        
        [self addSubview:button];
    }
}

-(void)tabBarButtonPressed:(UIButton*)sender
{
    UIViewController* viewController = [self.tabBarController.viewControllers objectAtIndex:sender.tag];
    if([self.tabBarController customCanSelectViewControllerDelegateMethod:viewController])
    {
        [self.tabBarController setSelectedViewController:viewController];
        [self.tabBarController customTabBarChangedDelegateMethod];
        [self moveIndicatorToViewControllerIndex:sender.tag animated:YES];
    }
}

-(void)moveIndicatorToPoint:(CGPoint)point animated:(BOOL)animated
{
    TweetieTabBarLayer* layer = (TweetieTabBarLayer*)self.layer;
    
    if(animated)
    {
        CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"animatableTabBarIndicatorPosition"];
        [animation setDuration:0.25f];
        [animation setFromValue:[NSValue valueWithCGPoint:layer.animatableTabBarIndicatorPosition]];
        [animation setToValue:[NSValue valueWithCGPoint:point]];
        [animation setAutoreverses:NO];
        
        [layer addAnimation:animation forKey:@"IndicatorAnimation"];
    }
    
    [layer setAnimatableTabBarIndicatorPosition:point];
    [layer setNeedsDisplay];
}

-(void)moveIndicatorToViewControllerIndex:(NSUInteger)index animated:(BOOL)animated
{
    NSUInteger numViewControllers = [self.tabBarController.viewControllers count];
    CGFloat buttonWidth = self.bounds.size.width / (float)numViewControllers;
    
    float position = (buttonWidth * (float)index) + (buttonWidth / 2.0f);
    [self moveIndicatorToPoint:CGPointMake(position, 0.0f) animated:animated];
}

- (void)drawRect:(CGRect)rect
{
    NSUInteger numViewControllers = [self.tabBarController.viewControllers count];
    CGFloat buttonWidth = self.bounds.size.width / (float)numViewControllers;
    
    for(int i = 0; i < numViewControllers; ++i)
    {
        UIViewController* viewController = [self.tabBarController.viewControllers objectAtIndex:i];
        UITabBarItem* item = viewController.tabBarItem;
        
        if(item.image == nil)
        {
            //NSLog(@"Please set the image for your UITabBarItem at index %i, yo.", i);
            continue;
        }
        
        UIImage* image = nil;
        
        if(self.tabBarController.selectedIndex == i)
            image = [item performSelector:@selector(selectedImage)];
        else
            image = [item performSelector:@selector(unselectedImage)];
        
        float imageCenter = (buttonWidth * (float)(i + 1)) - (buttonWidth / 2.0f);
        float imageOffsetX = imageCenter - (image.size.width / 2.0f);
        
        float imageOffsetY = kTweetieTabBarIndicatorHeight + ((kTweetieTabBarHeight - image.size.height) / 2.0f);
        
        [image drawAtPoint:CGPointMake(imageOffsetX, imageOffsetY)];
    }
}


@end
