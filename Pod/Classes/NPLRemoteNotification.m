//
//  NPLRemoteNotification.m
//  Pods
//
//  Created by Nick Lee on 8/31/14.
//
//

#import "NPLRemoteNotification.h"
#import <Mantle/Mantle.h>

@interface NPLRemoteNotification () <MTLJSONSerializing>

@end

@implementation NPLRemoteNotification

#pragma mark - mapping

+ (NSDictionary *)keyPathsToNotificationKeys
{
    return @{};
}

+ (NSUInteger)matchingKeyPathCountForUserInfo:(NSDictionary *)userInfo
{
    NSUInteger count = 0;
    
    NSArray *keyPaths = [[self keyPathsToNotificationKeys] allValues];
    
    for (NSString *keyPath in keyPaths) {
        if ([userInfo valueForKeyPath:keyPath]) {
            count++;
        }
    }
    
    return count;
}

+ (instancetype)notificationWithUserInfo:(NSDictionary *)userInfo
{
    return [MTLJSONAdapter modelOfClass:self fromJSONDictionary:userInfo error:NULL];
}

#pragma mark - MTLJSONSerializing

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return [self keyPathsToNotificationKeys];
}

@end
