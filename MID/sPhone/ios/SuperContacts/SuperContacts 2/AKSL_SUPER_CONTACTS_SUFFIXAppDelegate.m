
//
//  AKSL_SUPER_CONTACTS_SUFFIXAppDelegate.m
//  SuperContacts
//
//  Created by wlpiaoyi on 13-12-31.
//  Copyright (c) 2013年 wlpiaoyi. All rights reserved.
//

#import "AKSL_SUPER_CONTACTS_SUFFIXAppDelegate.h"
#import "TelephonyCenterListner.h"
#import "SerCallService.h"
#import "MMDrawerController.h"
#import "SSY_Contants.h"
#import "HT_CheckHttp.h"
#import "CTM_LeftController.h"
#import "CTM_RightController.h"
#import "CTM_MainController.h"
@interface AKSL_SUPER_CONTACTS_SUFFIXAppDelegate(){
    HT_CheckHttp  *ht;
}
@end
@implementation AKSL_SUPER_CONTACTS_SUFFIXAppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Override point for customization after application launch.
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent];
    
    [TelephonyCenterListner startExcu];
    [TelephonyCenterListner setTLOInterface:[[SerCallService alloc] init]];
    
    CTM_MainController *main = [CTM_MainController getSingleInstance];
    UINavigationController *navMain = [[UINavigationController alloc]initWithRootViewController:main];
    navMain.navigationBarHidden = YES;
    CTM_LeftController *left=[CTM_LeftController getSingleInstance];
    CTM_RightController *right=[CTM_RightController getSingleInstance];
    MMDrawerController *viewcontroller = [[MMDrawerController alloc]initWithCenterViewController:navMain leftDrawerViewController:left rightDrawerViewController:right];
    [viewcontroller setMaximumLeftDrawerWidth:106];
    [viewcontroller setMaximumRightDrawerWidth:255];
    [viewcontroller setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    [viewcontroller setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    viewcontroller.centerHiddenInteractionMode = 0;
    [viewcontroller setShouldStretchDrawer:NO];
    UINavigationController *navnext = [[UINavigationController alloc]initWithRootViewController:viewcontroller];
    [navnext setNavigationBarHidden:YES];
//    [UIApplication sharedApplication].keyWindow.rootViewController = navnext;
    self.window.rootViewController=navnext;
    self.window.backgroundColor = COMMON_SYSTEM_BGCOLOR;
    [self.window makeKeyAndVisible];
    COMMON_ADDROOTCONTROLLER(navnext);

    id syn_contents =  [ConfigManage getConfigPublic:@"syn_contents"];
    if(!syn_contents){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"询问" message:@"是否从本地同步通信录?" delegate:self cancelButtonTitle:@"下次提醒" otherButtonTitles:@"不再提醒",@"开始同步",nil];
        [alert show];
    }
    ht = [HT_CheckHttp new];
    [ht checkOnLine:nil methodResult:nil];
    return YES;
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 1:
        {
            [ConfigManage setConfigPublic:@"syn_contents" Value:@"f"];
        }
            break;
        case 2:
        {
            NSThread *t = [[NSThread alloc] initWithTarget:self selector:@selector(synData) object:nil];
            [t start];
        }
            break;
            
        default:
            break;
    }
}
-(void) synData{
    SSY_Contants *c = [[SSY_Contants alloc]init];
    [c synchrozeLocationAllData];
    [ConfigManage setConfigPublic:@"syn_contents" Value:@"f"];
//    COMMON_SHOWALERT(@"同步成功!");
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"SuperContacts" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"SuperContacts.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable director  y.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


@end
