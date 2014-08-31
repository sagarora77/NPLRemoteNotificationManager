//
//  NPLRemoteNotificationManager.h
//  Pods
//
//  Created by Nick Lee on 8/31/14.
//
//

#import <Foundation/Foundation.h>
#import "NPLRemoteNotification.h"

@class NPLRemoteNotificationManager;

@protocol NPLRemoteNotificationObserver <NSObject>

@optional

- (void)notificationManager:(NPLRemoteNotificationManager *)manager receivedNotification:(NPLRemoteNotification *)notification applicationState:(UIApplicationState)applicationState;

@end

@interface NPLRemoteNotificationManager : NSObject

+ (instancetype)sharedManager;

- (void)registerNotificationClass:(Class)notificationClass;

- (void)addObserver:(id<NPLRemoteNotificationObserver>)observer forNotificationClass:(Class)notificationClass;
- (void)removeObserver:(id<NPLRemoteNotificationObserver>)observer forNotificationClass:(Class)notificationClass;
- (void)removeObserver:(id<NPLRemoteNotificationObserver>)observer;

- (BOOL)handleNotificationWithUserInfo:(NSDictionary *)userInfo applicationState:(UIApplicationState)applicationState;

@end
