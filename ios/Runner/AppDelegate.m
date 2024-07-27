#import "AppDelegate.h"
#import "GeneratedPluginRegistrant.h"

#import <FlutterLocalNotificationsPlugin.h>
@implementation AppDelegate

void registerPlugins(NSObject<FlutterPluginRegistry>* registry) {
    [GeneratedPluginRegistrant registerWithRegistry:registry];
}

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [GeneratedPluginRegistrant registerWithRegistry:self];
  // Override point for customization after application launch.

  if (@available(iOS 10.0, *)) {
    [UNUserNotificationCenter currentNotificationCenter].delegate = (id<UNUserNotificationCenterDelegate>) self;
  }
  
  [FlutterLocalNotificationsPlugin setPluginRegistrantCallback:registerPlugins];

  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end
