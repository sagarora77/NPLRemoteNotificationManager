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
    BOOL valid = [notificationClass isSubclassOfClass:[NPLRemoteNotification class]] && !(notificationClass == [NPLRemoteNotification class]);
    
    NSAssert(valid, @"notificationClass must be a subclass of NPLRemoteNotification");
    
    BOOL exists = [[self classes] objectForKey:notificationClass] != nil;
    
    if (!exists) {
        NSHashTable *observers = [NSHashTable weakObjectsHashTable];
        [[self classes] setObject:observers forKey:notificationClass];
    }
}

#pragma mark - observer registration

- (NSHashTable *)observersForClass:(Class)class
{
    return [[self classes] objectForKey:class];
}

- (void)addObserver:(id<NPLRemoteNotificationObserver>)observer forNotificationClass:(Class)notificationClass
{
    NSHashTable *observers = [self observersForClass:notificationClass];
    [observers addObject:observer];
    printf("Num observers: %d\n", (int)observers.count);
}

- (void)removeObserver:(id<NPLRemoteNotificationObserver>)observer forNotificationClass:(Class)notificationClass
{
    NSHashTable *observers = [self observersForClass:notificationClass];
    [observers removeObject:observer];
}

#pragma mark - notification handling

- (Class)classForUserInfo:(NSDictionary *)userInfo
{
    Class klass = Nil;
    NSUInteger count = 0;
    
    NSArray *classes = [[self classes] allKeys];
    
    for (Class c in classes) {
        NSUInteger matches = [c matchingKeyPathCountForUserInfo:userInfo];
        if (matches > count) {
            count = matches;
            klass = c;
        }
    }
    
    return klass;
}

- (void)handleNotificationWithUserInfo:(NSDictionary *)userInfo
{
    Class c = [self classForUserInfo:userInfo];
    
    NSHashTable *observers = [self observersForClass:c];
    
    NSArray *allObservers = [observers allObjects];
    
    NPLRemoteNotification *notification = [c notificationWithUserInfo:userInfo];
    
    dispatch_apply([allObservers count], dispatch_get_main_queue(), ^(size_t i){
        
        id<NPLRemoteNotificationObserver> observer = [allObservers objectAtIndex:i];
        
        if ([observer respondsToSelector:@selector(notificationManager:receivedNotification:)]) {
            [observer notificationManager:self receivedNotification:notification];
        }
        
    });
}

@end
