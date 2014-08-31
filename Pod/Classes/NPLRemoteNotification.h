//
//  NPLRemoteNotification.h
//  Pods
//
//  Created by Nick Lee on 8/31/14.
//
//

#import <Mantle/MTLModel.h>

@interface NPLRemoteNotification : MTLModel

/**
 * Override this method in subclasses of NPLRemoteNotification.  The default implementation returns the empty dictionary.
 */
+ (NSDictionary *)keyPathsToNotificationKeys;


/**
 * Returns the number of key paths that occur in both your implementation
 * of +keyPathsToNotificationKeys and the passed userInfo dictionary.
 *
 * This method probably doesn't need to be overridden.
 */
+ (NSUInteger)matchingKeyPathCountForUserInfo:(NSDictionary *)userInfo;

/**
 * Returns an instance of this class populated with data from the notification's userInfo dictionary.
 */
+ (instancetype)notificationWithUserInfo:(NSDictionary *)userInfo;

@end
