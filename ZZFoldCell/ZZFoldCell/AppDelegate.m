//
//  AppDelegate.m
//  ZZFoldCell
//
//  Created by 郭旭赞 on 2017/7/6.
//  Copyright © 2017年 郭旭赞. All rights reserved.
//

#import "AppDelegate.h"
#import "ZZTableViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    ZZTableViewController *tableViewController = [ZZTableViewController new];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:tableViewController];
    self.window.rootViewController = navigationController;
    
    return YES;
}

@end
