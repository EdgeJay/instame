//
//  PhotoViewController.m
//  InstaMe
//
//  Created by Huijie Wu on 10/8/14.
//  Copyright (c) 2014 Ackworx. All rights reserved.
//

#import "PhotoViewController.h"
#import <UIImageView+AFNetworking.h>
#import <MBHUDView.h>

@interface PhotoViewController ()
{
    MBHUDView *hudView;
}

@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) IBOutlet UILabel *captionLabel;
@property (nonatomic, strong) IBOutlet UILabel *fullNameLabel;
@property (nonatomic, strong) IBOutlet UILabel *likesLabel;

@end

@implementation PhotoViewController

@synthesize photoData=_photoData;

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    
    if (self.photoData == nil)
    {
        return;
    }
    
    // Formatter for number
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.usesGroupingSeparator = YES;
    formatter.groupingSeparator = @",";
    
    self.captionLabel.text = self.photoData.caption.text;
    self.fullNameLabel.text = [NSString stringWithFormat: @"Taken by %@", self.photoData.user.fullName];
    self.likesLabel.text = [NSString stringWithFormat: @"%@ likes", [formatter stringFromNumber: [NSNumber numberWithInteger: self.photoData.likesCount]]];
    
    [self displayWaitDialog];
    
    __weak PhotoViewController *viewController = self;
    NSLog(@"%@", self.photoData.standardResolutionImageURL);
    
    [self.imageView setImageWithURLRequest: [NSURLRequest requestWithURL: self.photoData.standardResolutionImageURL]
                          placeholderImage: nil
                                   success: ^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                       
                                       [viewController dismissWaitDialog];
                                       [viewController.imageView setImage: image];
                                       
                                   } failure: ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                       
                                       [viewController dismissWaitDialog];
                                       [viewController.imageView setImage: nil];
                                       
                                       NSLog(@"%@", error);
                                   }];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear: animated];
    self.photoData = nil;
}

-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Wait dialog

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
    hudView.backgroundColor = [UIColor colorWithWhite: 1.0f alpha: 0.5f];
    [hudView addToDisplayQueue];
}

-(void)dismissWaitDialog
{
    [hudView dismiss];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end
