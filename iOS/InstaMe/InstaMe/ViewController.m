//
//  ViewController.m
//  InstaMe
//
//  Created by Huijie Wu on 8/8/14.
//  Copyright (c) 2014 Ackworx. All rights reserved.
//

#import "ViewController.h"
#import <InstagramKit.h>
#import <MODropAlertView.h>

@interface ViewController ()

@property (nonatomic, strong) IBOutlet UITextField *usernameTxt;
@property (nonatomic, strong) IBOutlet UITextField *passwordTxt;

@end

@implementation ViewController

@synthesize usernameTxt=_usernameTxt, passwordTxt=_passwordTxt;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSDictionary *config = [InstagramEngine sharedEngineConfiguration];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)onLogin:(id)sender
{
    if ([self verifyLoginFields])
    {
        
    }
}

-(BOOL)verifyLoginFields
{
    NSString *username = self.usernameTxt.text;
    NSString *password = self.passwordTxt.text;
    
    if ((username != nil && [username stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]].length > 0) &&
        (password != nil && [password stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]].length > 0))
    {
        return YES;
    }
    
    MODropAlertView *alertView = [[MODropAlertView alloc] initDropAlertWithTitle: @"Login"
                                                                     description: @"Oops, seemed that you missed out some fields. Please fill in all of them."
                                                                   okButtonTitle: @"OK"];
    [alertView show];
    
    return NO;
}

@end
