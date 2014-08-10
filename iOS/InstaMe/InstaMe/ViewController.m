//
//  ViewController.m
//  InstaMe
//
//  Created by Huijie Wu on 8/8/14.
//  Copyright (c) 2014 Ackworx. All rights reserved.
//

#import "ViewController.h"
#import "Global.h"
#import <InstagramKit.h>
#import <MBHUDView.h>
#import <MODropAlertView.h>

static NSString * const kLoginSegueIdentifier = @"login";
static NSString * const kGallerySegueIdentifier = @"gallery";

@interface ViewController ()
{
    MBHUDView *hudView;
}

@end

@implementation ViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear: animated];
    
    if (![self verifyLogin])
    {
        // Goto login view
        [self performSegueWithIdentifier: kLoginSegueIdentifier sender: self];
    }
    else
    {
        [self displayWaitDialog];
        [self fetchUserDetails];
    }
}

-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)verifyLogin
{
    return ([InstagramEngine sharedEngine].accessToken != nil);
}

-(void)fetchUserDetails
{
    [[InstagramEngine sharedEngine] getSelfUserDetailsWithSuccess: ^(InstagramUser *userDetail) {
        
        [[Global sharedInstance] setCurrentUser: userDetail];
        
        [self dismissWaitDialog];
        
        // Goto gallery
        [self performSegueWithIdentifier: kGallerySegueIdentifier sender: self];
        
    } failure: ^(NSError *error) {
        
        [self dismissWaitDialog];
        //TODO display error message here
    }];
}

-(void)displayWaitDialog
{
    if ([MBHUDView alertIsVisible])
    {
        return;
    }
    
    hudView = [[MBHUDView alloc] init];
    hudView.bodyText = @"";
    hudView.hudType = MBAlertViewHUDTypeActivityIndicator;
    hudView.hudHideDelay = 9999.0f;
    hudView.backgroundColor = [UIColor colorWithWhite: 0.0 alpha: 0.9];
    [hudView addToDisplayQueue];
}

-(void)dismissWaitDialog
{
    [hudView dismiss];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString: kLoginSegueIdentifier])
    {
    }
}

@end
