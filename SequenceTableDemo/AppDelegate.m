#import "AppDelegate.h"
#import "SequenceTableController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    UIWindow *window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    SequenceTableController *controller = [[SequenceTableController alloc] init];
    [window addSubview:controller.view];
    [window makeKeyAndVisible];
    return YES;
}

@end
