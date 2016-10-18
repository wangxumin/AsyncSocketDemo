//
//  AppDelegate.m
//  AsyncSocketDemo
//
//  Created by 王续敏 on 16/10/18.
//  Copyright © 2016年 王续敏. All rights reserved.
//

#import "AppDelegate.h"
#import "XMSocketManager.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
//    连接服务器
    [self connectToserver];
    
    return YES;
}


/**
 连接到服务器
 */
- (void)connectToserver{
    if (![[XMSocketManager sharedInstance].socket isConnected]) {
        [XMSocketManager sharedInstance].socketHost = @"socketHost";//服务器的host
        [XMSocketManager sharedInstance].socketPort = 1111;//服务器端口
        [[XMSocketManager sharedInstance] cutOffSocket];//为了避免重复连接时导致的崩溃，在调用连接方法时先手动断开一次
        [[XMSocketManager sharedInstance] socketConnectHost];//连接到服务器
    }
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
