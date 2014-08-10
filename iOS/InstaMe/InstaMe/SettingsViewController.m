//
//  SettingsViewController.m
//  InstaMe
//
//  Created by Huijie Wu on 10/8/14.
//  Copyright (c) 2014 Ackworx. All rights reserved.
//

#import "SettingsViewController.h"
#import <InstagramKit.h>
#import "Global.h"

static NSString * const kLoginSegueIdentifier = @"returnToLogin";
static NSString * const photoSettingCellReuseIdentifier = @"PhotoSettingCell";
static NSString * const userSettingCellReuseIdentifier = @"UserSettingCell";
static NSInteger const kSettingsPhotoSection = 0;
static NSInteger const kSettingsUserSection = 1;

@interface SettingsViewController ()

@end

@implementation SettingsViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Logout
-(void)performLogout
{
    [InstagramEngine sharedEngine].accessToken = nil;
    [[Global sharedInstance] removeUserAccessToken];
    [[Global sharedInstance] setCurrentUser: nil];
    [[Global sharedInstance] clearUserSession];
    
    NSLog(@"Logged out");
    
    [self.tableView reloadData];
}

-(void)performLogin
{
    NSLog(@"do login");
}

#pragma mark - Table view data source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    InstagramUser *user = [Global sharedInstance].currentUser;
    
    switch (section)
    {
        case kSettingsUserSection:
            
            if (user != nil)
            {
                return 2;
            }
            else
            {
                return 1;
            }
            
            break;
            
        default:
            return 0;
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section)
    {
        case kSettingsPhotoSection:
            return @"Photos";
            
        case kSettingsUserSection:
            return @"Your Account";
            
        default:
            return 0;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    if (indexPath.section == kSettingsPhotoSection)
    {
        cell = [tableView dequeueReusableCellWithIdentifier: photoSettingCellReuseIdentifier
                                               forIndexPath: indexPath];
    }
    else if (indexPath.section == kSettingsUserSection)
    {
        cell = [tableView dequeueReusableCellWithIdentifier: userSettingCellReuseIdentifier
                                               forIndexPath: indexPath];
        
        InstagramUser *user = [Global sharedInstance].currentUser;
        
        if (user != nil)
        {
            if (indexPath.item == 0)
            {
                [cell.textLabel setText: user.fullName];
                [cell.detailTextLabel setText: @"Your Account Name"];
            }
            else if (indexPath.item == 1)
            {
                [cell.textLabel setText: @"Sign Out"];
                [cell.detailTextLabel setText: @"Tap here to sign out"];
            }
        }
        else
        {
            if (indexPath.item == 0)
            {
                [cell.textLabel setText: @"Sign In"];
                [cell.detailTextLabel setText: @"Tap here to sign in"];
            }
        }
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    InstagramUser *user = [Global sharedInstance].currentUser;
    
    if (indexPath.section == kSettingsUserSection)
    {
        if (user != nil)
        {
            if (indexPath.item == 0)
            {
                return NO;
            }
        }
    }
    
    return YES;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath: indexPath animated: YES];
    
    InstagramUser *user = [Global sharedInstance].currentUser;
    
    if (indexPath.section == kSettingsUserSection)
    {
        if (user != nil)
        {
            if (indexPath.item == 1)
            {
                [self performLogout];
            }
        }
        else
        {
            if (indexPath.item == 0)
            {
                [self performLogin];
            }
        }
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end
