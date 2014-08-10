//
//  Global.h
//  InstaMe
//
//  Created by Huijie Wu on 10/8/14.
//  Copyright (c) 2014 Ackworx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <InstagramKit.h>

@interface Global : NSObject

+(Global *)sharedInstance;

@property (nonatomic, strong) InstagramUser *currentUser;

@end
