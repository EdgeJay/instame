//
//  GalleryViewController.m
//  InstaMe
//
//  Created by Huijie Wu on 10/8/14.
//  Copyright (c) 2014 Ackworx. All rights reserved.
//

#import "GalleryViewController.h"
#import <InstagramKit.h>
#import <MBHUDView.h>
#import <MODropAlertView.h>
#import <ALToastView.h>
#import "NavigationController.h"
#import "PhotoViewCell.h"
#import "PhotoViewController.h"
#import "Global.h"
#import "UIScrollView+SpiralPullToRefresh.h"

@interface GalleryViewController () <MODropAlertViewDelegate>
{
    MBHUDView *hudView;
    MODropAlertView *fetchPhotoAlert;
    
    InstagramPaginationInfo *currentPaginationInfo;
    NSMutableArray *loadedMedia;
    NSIndexPath *lastItemIndexPath;
    InstagramMedia *previewPhotoMedia;
    
    // Photo column settings
    NSInteger numOfColumns;
    BOOL numOfColumnsChanged;
}

@property (nonatomic, strong) IBOutlet UIBarButtonItem *settingsButton;

@end

@implementation GalleryViewController

@synthesize settingsButton=_settingsButton;

static NSString * const kSettingsSegueIdentifier = @"settings";
static NSString * const kShowPhotoSegueIdentifier = @"showPhoto";
static NSString * const reuseIdentifier = @"PhotoCell";
static NSInteger const kMaxItemPerPage = 32;
static NSInteger const kInitialItemsToLoad = 64;
static NSInteger const kNumberOfColumns = 4;
static CGFloat const kItemSpacing = 1.0f;

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    // Register cell classes
    [self.collectionView registerClass: [PhotoViewCell class] forCellWithReuseIdentifier: reuseIdentifier];
    
    // Do any additional setup after loading the view.
    
    __typeof (&*self) __weak weakSelf = self;
    [self.collectionView addPullToRefreshWithActionHandler: ^{
        
        int64_t delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [weakSelf refreshTriggered];
        });
    }];
    self.collectionView.pullToRefreshController.waitingAnimation = SpiralPullToRefreshWaitAnimationLinear;
    
    loadedMedia = [[NSMutableArray alloc] initWithCapacity: kMaxItemPerPage];
    
    // Add bar button item
    UIButton *iconButton = [UIButton buttonWithType: UIButtonTypeCustom];
    iconButton.frame = CGRectMake(0.0f, 0.0f, 20.0f, 20.0f);
    [iconButton setImage: [UIImage imageNamed: @"icon_settings.png"] forState: UIControlStateNormal];
    [iconButton setImage: [UIImage imageNamed: @"icon_settings_selected.png"] forState: UIControlStateHighlighted];
    [iconButton setImage: [UIImage imageNamed: @"icon_settings_selected.png"] forState: UIControlStateSelected];
    [iconButton addTarget: self action: @selector(onSettings:) forControlEvents: UIControlEventTouchUpInside];
    [self.settingsButton setCustomView: iconButton];
    [self.navigationItem setRightBarButtonItem: self.settingsButton];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear: animated];
    
    previewPhotoMedia = nil;
    
    // Make sure user is logged in
    if ([Global sharedInstance].currentUser == nil)
    {
        [(NavigationController *)self.navigationController exit];
        return;
    }
    
    // Fetch display settings
    [self updateDisplaySettings];
    
    if (loadedMedia.count == 0)
    {
        [self displayWaitDialog];
    
        // Fetch user photos
        [self fetchUserPhotos];
    }
    else
    {
        if (numOfColumnsChanged)
        {
            numOfColumnsChanged = NO;
            [self.collectionView reloadData];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateDisplaySettings
{
    NSInteger oldNumOfColumns = numOfColumns;
    
    // Check if default settings are saved
    if ([[Global sharedInstance] getNumberOfPhotoColumns] == 0)
    {
        [[Global sharedInstance] saveNumberOfPhotoColumns: kNumberOfColumns];
        numOfColumns = kNumberOfColumns;
    }
    else
    {
        numOfColumns = [[Global sharedInstance] getNumberOfPhotoColumns];
        numOfColumnsChanged = (oldNumOfColumns != numOfColumns);
    }
    
    // Tweak layout settings
    [(UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout setMinimumLineSpacing: kItemSpacing];
    [(UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout setMinimumInteritemSpacing: kItemSpacing];
    // Calculate cell size
    CGFloat cellSize = [self getPhotoCellSize];
    [(UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout setItemSize: CGSizeMake(cellSize, cellSize)];
}

-(CGFloat)getPhotoCellSize
{
    // Calculate cell size
    CGFloat cellSize = (self.collectionView.bounds.size.width - (kItemSpacing * (numOfColumns - 1))) / numOfColumns;
    return cellSize;
}

#pragma mark - Photo fetching methods

-(void)fetchUserPhotos
{
    [[InstagramEngine sharedEngine] getSelfFeedWithCount: kMaxItemPerPage
                                                   maxId: currentPaginationInfo.nextMaxId
                                                 success: ^(NSArray *media, InstagramPaginationInfo *paginationInfo) {
                                                     
                                                     [self dismissWaitDialog];
                                                     
                                                     [self.collectionView.pullToRefreshController didFinishRefresh];
                                                     
                                                     currentPaginationInfo = paginationInfo;
                                                     
                                                     [self addMorePhotos: media];
                                                     
                                                     if (loadedMedia.count < kInitialItemsToLoad) {
                                                         [self fetchUserPhotos];
                                                     }
                                                     
                                                 } failure: ^(NSError *error) {
                                                     
                                                     // Something went wrong, need to display error
                                                     [self dismissWaitDialog];
                                                     [self.collectionView.pullToRefreshController didFinishRefresh];
                                                     [self displayFetchPhotosErrorDialog];
                                                 }];
}

-(void)addMorePhotos: (NSArray *)list
{
    // Index to start inserting new items from
    NSInteger index = loadedMedia.count;
    
    // Update array of loaded media items
    [loadedMedia addObjectsFromArray: list];
    
    // Create list of index paths to instruct collection view to insert items into
    NSMutableArray *paths = [NSMutableArray arrayWithCapacity: list.count];
    while (index < loadedMedia.count)
    {
        [paths addObject: [NSIndexPath indexPathForItem: index inSection: 0]];
        index++;
    }
    
    lastItemIndexPath = [paths lastObject];
    
    [self.collectionView insertItemsAtIndexPaths: paths];
}

-(void)loadMorePhotosIfRequired
{
    // Load more photos when end of page is reached
    CGFloat bottomEdge = self.collectionView.contentOffset.y + self.collectionView.frame.size.height;
    if (bottomEdge >= self.collectionView.contentSize.height)
    {
        [ALToastView toastInView: [UIApplication sharedApplication].keyWindow
                        withText: @"Loading more photos"];
        
        [self fetchUserPhotos];
    }
}

-(void)refreshTriggered
{
    NSLog(@"refresh triggered!");
    [self performFullRefresh];
}

-(void)performFullRefresh
{
    loadedMedia = [[NSMutableArray alloc] initWithCapacity: kMaxItemPerPage];
    currentPaginationInfo = nil;
    [self.collectionView reloadData];
    
    [self fetchUserPhotos];
}

#pragma mark - Navigation

-(void)onSettings:(id)sender
{
    [self performSegueWithIdentifier: kSettingsSegueIdentifier sender: self];
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString: kShowPhotoSegueIdentifier])
    {
        PhotoViewController *photoViewController = (PhotoViewController *)segue.destinationViewController;
        [photoViewController setPhotoData: previewPhotoMedia];
    }
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

#pragma mark - Error dialogs

-(void)displayFetchPhotosErrorDialog
{
    fetchPhotoAlert = [[MODropAlertView alloc] initDropAlertWithTitle: @"Error"
                                                          description: @"Oops, an error occurred while fetching your photos. You will now be redirected to sign in screen."
                                                        okButtonTitle: @"OK"];
    fetchPhotoAlert.delegate = self;
    [fetchPhotoAlert show];
}

#pragma mark - MODropAlertViewDelegate methods

-(void)alertViewPressButton:(MODropAlertView *)alertView buttonType:(DropAlertButtonType)buttonType
{
    if (alertView == fetchPhotoAlert && buttonType == DropAlertButtonOK)
    {
        [alertView dismiss];
        [(NavigationController *)self.navigationController exit];
    }
}

#pragma mark - UICollectionViewDataSource methods

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return loadedMedia.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                 cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier: reuseIdentifier
                                                                    forIndexPath: indexPath];
    
    CGFloat cellSize = [self getPhotoCellSize];
    CGRect frame = cell.frame;
    frame.size = CGSizeMake(cellSize, cellSize);
    cell.frame = frame;
    
    // Get InstagramMedia object for cell
    InstagramMedia *media = [loadedMedia objectAtIndex: indexPath.item];
    [cell loadPhotoFromURL: media.thumbnailURL];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate methods

-(BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
	return YES;
}

-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath: indexPath animated: YES];
    
    // Get InstagramMedia object for cell
    previewPhotoMedia = [loadedMedia objectAtIndex: indexPath.item];
    
    if (previewPhotoMedia != nil)
    {
        [self performSegueWithIdentifier: kShowPhotoSegueIdentifier sender: self];
    }
}

#pragma mark - UIScrollViewDelegate methods
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
    {
        [self loadMorePhotosIfRequired];
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadMorePhotosIfRequired];
}

@end
