//
//  AKSL_SUPER_CONTACTS_SUFFIXAppDelegate.h
//  SuperContacts
//
//  Created by wlpiaoyi on 13-12-31.
//  Copyright (c) 2013年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AKSL_SUPER_CONTACTS_SUFFIXAppDelegate : UIResponder <UIApplicationDelegate,UIAlertViewDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
