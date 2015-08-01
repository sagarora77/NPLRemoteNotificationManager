//
//  NPLRemoteNotificationManager.m
//  Pods
//
//  Created by Nick Lee on 8/31/14.
//
//

#import "NPLRemoteNotificationManager.h"

@interface NPLRemoteNotificationManager ()

@property (nonatomic, strong) NSMutableDictionary *classes;

- (NSHashTable *)observersForClass:(Class)class;
- (Class)classForUserInfo:(NSDictionary *)userInfo;

@end

@implementation NPLRemoteNotificationManager

#pragma mark - singleton

+ (instancetype)sharedManager
{
    static NPLRemoteNotificationManager *sharedManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[NPLRemoteNotificationManager alloc] init];
    });
    return sharedManager;
}

#pragma mark - object lifecycle

- (id)init
{
    if (self = [super init]) {
        _classes = [[NSMutableDictionary alloc] init];
    }
    return self;
}

#pragma mark - class registration

- (void)registerNotificationClass:(Class)notificationClass
{
    NSAssert([notificationClass isSubclassOfClass:[NPLRemoteNotification class]] && !(notificationClass == [NPLRemoteNotification class]), @"notificationClass must be a subclass of NPLRemoteNotification");
    
    BOOL exists = [[self classes] objectForKey:NSStringFromClass(notificationClass)] != nil;
    
    if (!exists) {
        NSHashTable *observers = [NSHashTable weakObjectsHashTable];
        [[self classes] setObject:observers forKey:NSStringFromClass(notificationClass)];
    }
}

#pragma mark - observer registration

- (NSHashTable *)observersForClass:(Class)class
{
    return [[self classes] objectForKey:NSStringFromClass(class)];
}

- (void)addObserver:(id<NPLRemoteNotificationObserver>)observer forNotificationClass:(Class)notificationClass
{
    NSHashTable *observers = [self observersForClass:notificationClass];
    [observers addObject:observer];
}

- (void)removeObserver:(id<NPLRemoteNotificationObserver>)observer forNotificationClass:(Class)notificationClass
{
    NSHashTable *observers = [self observersForClass:notificationClass];
    [observers removeObject:observer];
}

- (void)removeObserver:(id<NPLRemoteNotificationObserver>)observer
{
    NSArray *tables = [[self classes] allValues];

    for (NSHashTable *observers in tables) {
        [observers removeObject:observer];
    }
}

#pragma mark - notification handling

- (Class)classForUserInfo:(NSDictionary *)userInfo
{
    Class klass = Nil;
    NSUInteger count = 0;
    
    NSArray *classes = [[self classes] allKeys];
    
    for (NSString *className in classes) {
        Class c = NSClassFromString(className);
        NSUInteger matches = [c matchingKeyPathCountForUserInfo:userInfo];
        if (matches > count) {
            count = matches;
            klass = c;
        }
    }
    
    return klass;
}

- (BOOL)handleNotificationWithUserInfo:(NSDictionary *)userInfo applicationState:(UIApplicationState)applicationState
{
    return [self handleNotificationWithUserInfo:userInfo fetchCompletionHandler:nil applicationState:applicationState];
}

- (BOOL)handleNotificationWithUserInfo:(NSDictionary *)userInfo fetchCompletionHandler:(void(^)(UIBackgroundFetchResult))fetchCompletionHandler applicationState:(UIApplicationState)applicationState
{
    Class c = [self classForUserInfo:userInfo];
    
    if (c) {
        
        NSHashTable *observers = [self observersForClass:c];
        
        NPLRemoteNotification *notification = [c notificationWithUserInfo:userInfo];
        
        [notification setBackgroundFetchHandler:fetchCompletionHandler];
        
        for (id<NPLRemoteNotificationObserver> observer in observers) {
            if ([observer respondsToSelector:@selector(notificationManager:receivedNotification:applicationState:)]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [observer notificationManager:self receivedNotification:notification applicationState:applicationState];
                });
            }
        }
        
        return YES;
    }
    else {
        
        return NO;
        
    }
}

@end
