//
//  AppDelegate.m
//  daily Expenses
//
//  Created by renan veloso silva on 17/05/13.
//  Copyright (c) 2013 renan veloso silva. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "Config.h"


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self config];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    MainViewController *mainView = [[MainViewController alloc]init];
    
    self.window.rootViewController = mainView;
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [self.window makeKeyAndVisible];
    
    return YES;
}

-(void)config{
    [[Config sharedInstance] setHasLog:YES];
}


@end
