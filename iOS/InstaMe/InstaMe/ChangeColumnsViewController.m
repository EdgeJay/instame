//
//  ChangeColumnsViewController.m
//  InstaMe
//
//  Created by Huijie Wu on 10/8/14.
//  Copyright (c) 2014 Ackworx. All rights reserved.
//

#import "ChangeColumnsViewController.h"
#import "Global.h"

static NSString * const changeColumnCellReuseIdentifier = @"ChangeColumnCell";

@interface ChangeColumnsViewController ()
{
    NSInteger numberOfColumns;
}

@end

@implementation ChangeColumnsViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    
    numberOfColumns = [[Global sharedInstance] getNumberOfPhotoColumns];
    
    [self.tableView reloadData];
}

-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
// Return the number of rows in the section.
    return 4;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: changeColumnCellReuseIdentifier
                                                            forIndexPath: indexPath];
    
    [cell setAccessoryType: UITableViewCellAccessoryNone];
    
    switch (indexPath.item)
    {
        case 0:
            cell.textLabel.text = @"2 columns";
            if (numberOfColumns == 2) { [cell setAccessoryType: UITableViewCellAccessoryCheckmark]; }
            break;
        
        case 1:
            cell.textLabel.text = @"3 columns";
            if (numberOfColumns == 3) { [cell setAccessoryType: UITableViewCellAccessoryCheckmark]; }
            break;
            
        case 2:
            cell.textLabel.text = @"4 columns";
            if (numberOfColumns == 4) { [cell setAccessoryType: UITableViewCellAccessoryCheckmark]; }
            break;
        
        case 3:
            cell.textLabel.text = @"5 columns";
            if (numberOfColumns == 5) { [cell setAccessoryType: UITableViewCellAccessoryCheckmark]; }
            break;
            
        default:
            break;
    }
    
    return cell;
}

#pragma mark - Table view delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath: indexPath animated: YES];
    
    switch (indexPath.item)
    {
        case 0:
            numberOfColumns = 2;
            break;
            
        case 1:
            numberOfColumns = 3;
            break;
            
        case 2:
            numberOfColumns = 4;
            break;
            
        case 3:
            numberOfColumns = 5;
            break;
    }
    
    [[Global sharedInstance] saveNumberOfPhotoColumns: numberOfColumns];
    [self.tableView reloadData];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end
