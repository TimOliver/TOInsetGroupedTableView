//
//  AppDelegate.m
//  TOGroupInsetTableView
//
//  Created by Tim Oliver on 2020/04/08.
//  Copyright © 2020 Tim Oliver. All rights reserved.
//

#import "TOAppDelegate.h"
#import "TOViewController.h"

@implementation TOAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[TOViewController new]];
    [self.window makeKeyAndVisible];

    return YES;
}

@end
