//
//  Global.m
//  InstaMe
//
//  Created by Huijie Wu on 10/8/14.
//  Copyright (c) 2014 Ackworx. All rights reserved.
//

#import "Global.h"
#import <InstagramKit.h>


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

@end
