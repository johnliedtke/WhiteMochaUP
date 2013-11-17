@class ParseStarterProjectViewController;
@class WMNewLoginViewController;
#include <Parse/Parse.h>

@interface WhiteMochaUPAppDelegate : NSObject <UIApplicationDelegate>
{
    UITabBarController *tabBarController;
}

@property (nonatomic, strong) IBOutlet UIWindow *window;

@property (nonatomic, strong) IBOutlet ParseStarterProjectViewController *viewController;


@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) PFObject *john;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end
