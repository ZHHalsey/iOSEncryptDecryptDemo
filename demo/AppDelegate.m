//
//  AppDelegate.m
//  demo
//
//  Created by ZH on 2020/4/14.
//  Copyright © 2020 张豪. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    ViewController *vc = [ViewController new];
    self.window.rootViewController = vc;
    return YES;
}




@end
