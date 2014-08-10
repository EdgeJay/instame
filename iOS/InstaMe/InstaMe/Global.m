//
//  Global.m
//  InstaMe
//
//  Created by Huijie Wu on 10/8/14.
//  Copyright (c) 2014 Ackworx. All rights reserved.
//

#import "Global.h"
#import <InstagramKit.h>

static NSString * const kUserAccessTokenKey = @"InstagramUserAccessToken";

@implementation Global

+(Global *)sharedInstance
{
    static Global *instance = nil;
    static dispatch_once_t onceToken;
    
    if (instance)
    {
        return instance;
    }
    
    dispatch_once(&onceToken, ^{
        instance = [[Global alloc] init];
    });
    
    return instance;
}

-(void)saveUserAccessToken:(NSString *)accessToken
{
    [[NSUserDefaults standardUserDefaults] setObject: accessToken forKey: kUserAccessTokenKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSString *)getUserAccessToken
{
    return (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey: kUserAccessTokenKey];
}

-(void)removeUserAccessToken
{
    [self saveUserAccessToken: nil];
}

-(void)clearUserSession
{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    // Clear all cookies
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in storage.cookies)
    {
        [storage deleteCookie: cookie];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
