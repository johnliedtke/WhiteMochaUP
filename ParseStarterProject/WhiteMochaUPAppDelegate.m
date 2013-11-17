#import <Parse/Parse.h>
#import "WhiteMochaUPAppDelegate.h"
#import "WMMarketPlaceHomeViewController.h"
#import "WMWebViewController.h"
#import "WMEventsViewController.h"
#import "WMTextbookCourseViewController.h"
#import "WMTextbookSubjects.h"
#import "WMClubFormViewController.h"
#import "WMConstants.h"
#import "WMHomeViewController.h"
#import <CoreData/CoreData.h>
#import "RootTableViewController.h"
#import "WMFoodSectionViewController.h"
#import "WMNavigationBar.h"
#import "WMNavigationController.h"


@implementation WhiteMochaUPAppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

#pragma mark - UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // ****************************************************************************
    // Uncomment and fill in with your Parse credentials:
    
    // Register our subclasses
    //[WMUser registerSubclass];


    
    [Parse setApplicationId:@"FiAFviJalDgCeyLR5xLxju31oDiUEPrn0QN2tjST"
                  clientKey:@"XJW3euNbZb1H8X5mdBnA6TOSEhjk3OK4vTLAs3t5"];
    //
    // If you are using Facebook, uncomment and add your FacebookAppID to your bundle's plist as
    // described here: https://developers.facebook.com/docs/getting-started/facebook-sdk-for-ios/
    // [PFFacebookUtils initializeFacebook];
    // ****************************************************************************

    //[PFUser enableAutomaticUser];

    
    PFACL *defaultACL = [PFACL ACL];

    // If you would like all objects to be private by default, remove this line.
    [defaultACL setPublicReadAccess:YES];
    
    // Navigation bar
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Museo Slab" size:22],UITextAttributeFont, [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName,nil]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

//    // Admin Roles
//    PFACL *roleACL = [PFACL ACL];
//    [roleACL setPublicReadAccess:YES];
//    PFRole *role = [PFRole roleWithName:@"Admin" acl:roleACL];
//    
//    
//    // John
//    NSString *objectID = @"TP1zH9PHeJ";
//    PFObject *john;
//    [[PFUser query] getObjectInBackgroundWithId:objectID block:^(PFObject *object, NSError *error) {
//        [self setJohn:object];
//    }];
//
//    [[role users] addObject:john];
//    [role saveInBackground];
//    
    
    [PFACL setDefaultACL:defaultACL withAccessForCurrentUser:YES];
    
    // Override point for customization after application launch.
    
    // Create marketplace
    UIStoryboard *marketStory = [UIStoryboard storyboardWithName:@"WMMarketPlaceHome" bundle:nil];
    WMMarketPlaceHomeViewController *marketplaceHomeController= [marketStory instantiateViewControllerWithIdentifier:@"WMMarketPlaceHome"];
    UITabBarItem *market = [[UITabBarItem alloc] initWithTitle:@"Market" image:[UIImage imageNamed:@"market.png"] tag:1];
    [marketplaceHomeController setTabBarItem:market];
    
    // Push marketplace onto a navigation controller
    WMNavigationController *marketNavigation = [[WMNavigationController alloc] initWithRootViewController:marketplaceHomeController];
    
    // Create Events Section
    WMEventsViewController *evc = [[WMEventsViewController alloc] init];
    UITabBarItem *events = [[UITabBarItem alloc] initWithTitle:@"Events" image:[UIImage imageNamed:@"events.png"] tag:2];
    [evc setTabBarItem:events];
    WMWebViewController *wvc = [[WMWebViewController alloc] init];
    [evc setWebViewController:wvc];
    WMNavigationController *eventsNavigation = [[WMNavigationController alloc] initWithRootViewController:evc];

    
    // Create class crap
    RootTableViewController *classes = [[RootTableViewController alloc] init];
    WMNavigationController *classNavigation = [[WMNavigationController alloc] initWithRootViewController:classes];
    [classes setManagedObjectContext:self.managedObjectContext];
   
    UITabBarItem *eventsItem = [[UITabBarItem alloc] initWithTitle:@"Classes" image:[UIImage imageNamed:@"class.png"] tag:3];
    [classNavigation setTabBarItem:eventsItem];
    
    // Create food section
    UIStoryboard *storyFood = [UIStoryboard storyboardWithName:@"WMFoodSection" bundle:nil];
    WMFoodSectionViewController *food = [storyFood instantiateViewControllerWithIdentifier:@"WMFoodSection"];

    UITabBarItem *foodItem = [[UITabBarItem alloc] initWithTitle:@"Food" image:[UIImage imageNamed:@"food.png"] tag:5];
    [food setTabBarItem:foodItem];
    
    WMNavigationController *foodNavigation = [[WMNavigationController alloc] initWithRootViewController:food];

    
    // Home Navigation
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"WMHome" bundle:nil];
    WMHomeViewController *homeViewController = [story instantiateViewControllerWithIdentifier:@"WMHome"];
    UITabBarItem *homeItem = [[UITabBarItem alloc] initWithTitle:@"Home" image:[UIImage imageNamed:@"home.png"] tag:0];
    [homeViewController setTabBarItem:homeItem];
    WMNavigationController *homeNavigation = [[WMNavigationController alloc] initWithRootViewController:homeViewController];
    
    

    // Create the navigation for the app
    tabBarController = [[UITabBarController alloc] init];
    UIColor *grayColor = [[UIColor alloc] initWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0];

    [[tabBarController tabBar] setTranslucent:NO];
    [[tabBarController tabBar] setBarTintColor:grayColor];
    [[tabBarController tabBar] setSelectedImageTintColor:PURPLECOLOR];
    [[tabBarController tabBar] setBarStyle:UIBarStyleBlack];
    [[tabBarController tabBar] setTintColor:[UIColor whiteColor]];

    
    // View Controllers Array
    NSArray *controllers = [NSArray arrayWithObjects:homeNavigation, classNavigation, eventsNavigation, foodNavigation, marketNavigation, nil];
    
    [tabBarController setViewControllers:controllers];
    
    [[self window] setRootViewController:tabBarController];
    [self.window makeKeyAndVisible];

    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge|
                                                    UIRemoteNotificationTypeAlert|
                                                    UIRemoteNotificationTypeSound];
    return YES;
}

/*
 
///////////////////////////////////////////////////////////
// Uncomment this method if you are using Facebook
///////////////////////////////////////////////////////////
 
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
    sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [PFFacebookUtils handleOpenURL:url];
} 
 
*/

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)newDeviceToken {
    [PFPush storeDeviceToken:newDeviceToken];
    [PFPush subscribeToChannelInBackground:@"" target:self selector:@selector(subscribeFinished:error:)];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    if (error.code == 3010) {
        NSLog(@"Push notifications are not supported in the iOS Simulator.");
    } else {
        // show some alert or otherwise handle the failure to register.
        NSLog(@"application:didFailToRegisterForRemoteNotificationsWithError: %@", error);
	}
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];

    if (application.applicationState != UIApplicationStateActive) {
        [PFAnalytics trackAppOpenedWithRemoteNotificationPayload:userInfo];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
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
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"ParseStarterProject" withExtension:@"momd"];
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
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"ParseStarterProject.sqlite"];
    
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
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
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

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


#pragma mark - ()

- (void)subscribeFinished:(NSNumber *)result error:(NSError *)error {
    if ([result boolValue]) {
        NSLog(@"ParseStarterProject successfully subscribed to push notifications on the broadcast channel.");
    } else {
        NSLog(@"ParseStarterProject failed to subscribe to push notifications on the broadcast channel.");
    }
}


@end
