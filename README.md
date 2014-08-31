# NPLRemoteNotificationManager

Responding to push notifications in an iOS app usually requires either a) the usage of NSNotificationCenter or b) the maintenance of references to unrelated parts of an application in its delegate.  This is probably better because you don't need to do either of those, nor do you have to pass dictionaries around.

## Usage

### Subclassing NPLRemoteNotification

You must create a subclass of `NPLRemoteNotification` for each type of notification you wish to handle.  Overriding `+keyPathsToNotificationKeys` informs the mapping of the notification's `userInfo` to your subclass's properties.

MyNotification.h:

	#import <NPLRemoteNotificationManager/NPLRemoteNotification.h>
	
	@interface MyNotification : NPLRemoteNotification
	
	@property (nonatomic, strong) NSString *myProperty;
	
	@end

MyNotification.m:

	#import "MyNotification.h"
	
	@implementation MyNotification
	
	+ (NSDictionary *)keyPathsToNotificationKeys
	{
	    return @{
		    		@"myProperty" : @"server_property"
	             };
	}
	
	@end

### Configuring Your Application

#### Registering your subclass

For notification handling to work correctly, you must register your subclasses of `NPLRemoteNotification` with the `NPLRemoteNotificationManager` singleton.

Example app delegate:

	- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
	{
		
		...
		
		[[NPLRemoteNotificationManager sharedManager] registerNotificationClass:[MyNotification class]];
		
		...
		
	}

#### Handling Notifications

Simply forward your notifications to the `NPLRemoteNotificationManager` singleton.  The notification's class will be automatically inferred based on the key paths provided in `+keyPathsToNotificationKeys` on your `NPLRemoteNotification` subclass.

	- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
	{
	    
	    BOOL result = [[NPLRemoteNotificationManager sharedManager] handleNotificationWithUserInfo:userInfo applicationState:[application applicationState]];
	    
	    if (!result) {
	        NSLog(@"Received unknown notification");
	    }
	}

### Adding Observers

Responding to these notifications is very easy.  Simply implement the `NPLRemoteNotificationObserver` on the class(es) in which the notification is needed and register them with the `NPLRemoteNotificationManager` singleton.

Example View Controller:
	
	#import "MyViewController.h"
	#import <NPLRemoteNotificationManager/NPLRemoteNotificationManager.h>
	#import "MyNotification.h"
	
	@implementation MyViewController
	
	- (void)viewDidLoad 
	{
		[super viewDidLoad];
		
		[[NPLRemoteNotificationManager sharedManager] addObserver:self forNotificationClass:[MyNotification class]];
	}
	
	- (void)dealloc
	{
		[[NPLRemoteNotificationManager sharedManager] removeObserver:self];
	}
	
	@end
	
	#pragma mark - NPLRemoteNotificationObserver
	
	- (void)notificationManager:(NPLRemoteNotificationManager *)manager 
		   receivedNotification:(NPLRemoteNotification *)notification 
		       applicationState:(UIApplicationState)applicationState
	{
		if ([notification isKindOfClass:[MyNotification class]]) {
			MyNotification *myNotification = (MyNotification *)notification;
			
			// Do what you want with it
			
			NSLog(@"lulzzzzzz: %@", [myNotification myProperty]);
		}
	}


## Installation

NPLRemoteNotificationManager is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

    pod "NPLRemoteNotificationManager"

## Author

Nick Lee, nick@nickplee.com

## License

NPLRemoteNotificationManager is available under the MIT license. See the LICENSE file for more info.
