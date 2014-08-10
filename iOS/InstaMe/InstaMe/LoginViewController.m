//
//  LoginViewController.m
//  InstaMe
//
//  Created by Huijie Wu on 9/8/14.
//  Copyright (c) 2014 Ackworx. All rights reserved.
//

#import "LoginViewController.h"
#import <InstagramKit.h>
#import <MBHUDView.h>

@interface LoginViewController () <UIWebViewDelegate>
{
    MBHUDView *hudView;
}

@property (nonatomic, strong) IBOutlet UIWebView *loginWebView;

@end

@implementation LoginViewController

@synthesize loginWebView=_loginWebView;

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
    self.loginWebView.delegate = self;
    self.loginWebView.hidden = YES;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear: animated];
    
    [self performLogin];
}

-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)performLogin
{
    NSDictionary *config = [InstagramEngine sharedEngineConfiguration];
    NSURL *url = [NSURL URLWithString: [NSString stringWithFormat: @"%@?client_id=%@&redirect_uri=%@&response_type=token",
                                        config[kInstagramKitAuthorizationUrlConfigurationKey],
                                        config[kInstagramKitAppClientIdConfigurationKey],
                                        config[kInstagramKitAppRedirectUrlConfigurationKey]]];
    
    [self.loginWebView loadRequest:[NSURLRequest requestWithURL:url]];
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

#pragma mark - UIWebViewDelegate methods
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request
navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *URLString = [request.URL absoluteString];
    
    if ([URLString hasPrefix: [[InstagramEngine sharedEngine] appRedirectURL]])
    {
        NSString *delimiter = @"access_token=";
        NSArray *components = [URLString componentsSeparatedByString: delimiter];
        if (components.count > 1)
        {
            NSString *accessToken = [components lastObject];
            [[InstagramEngine sharedEngine] setAccessToken: accessToken];
            
            // Exit here
            UIViewController *viewController = self.presentingViewController;
            [viewController dismissViewControllerAnimated: YES completion: nil];
        }
        
        return NO;
    }
    
    [self displayWaitDialog];
    
    return YES;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.loginWebView.hidden = NO;
    [hudView dismiss];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [hudView dismiss];
}

@end
