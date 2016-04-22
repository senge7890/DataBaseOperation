//
//  AppDelegate.m
//  DataBaseOperation
//
//  Created by 键盘上的舞者 on 4/7/16.
//  Copyright © 2016 键盘上的舞者. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - CoreData Stack
#pragma mark 获取存储目录
- (NSURL *)currentDocumentPath {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark 懒加载相关
- (NSManagedObjectModel *)model {
    if (!_model) {
        NSURL *modelUrl = [[NSBundle mainBundle] URLForResource:@"CoreDb" withExtension:@"momd"];
        _model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelUrl];
    }
    return _model;
}

- (NSPersistentStoreCoordinator *)cordinator {
    if (!_cordinator) {
        _cordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.model];
        //Doc存储目录
        NSURL *path = [[self currentDocumentPath] URLByAppendingPathComponent:@"CoreDb.sqlite"];
        NSError *error = nil;
        //关联
        if (![_cordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:path options:nil error:&error]) {
            NSLog(@"error:%@",error);
            abort();
        }
    }
    return _cordinator;
}

- (NSManagedObjectContext *)context {
    if (!_context) {
        _context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_context setPersistentStoreCoordinator:self.cordinator];
    }
    return _context;
}


@end
