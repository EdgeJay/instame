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
#import <ALToastView.h>
#import "PhotoViewCell.h"

@interface GalleryViewController ()
{
    MBHUDView *hudView;
    UIBarButtonItem *settingsButton;
    
    InstagramPaginationInfo *currentPaginationInfo;
    NSMutableArray *loadedMedia;
    NSIndexPath *lastItemIndexPath;
}

@end

@implementation GalleryViewController

static NSString * const reuseIdentifier = @"PhotoCell";
static NSInteger const kMaxItemPerPage = 32;
static NSInteger const kInitialItemsToLoad = 64;
static NSInteger const kNumberOfColumns = 4;
static CGFloat const kItemSpacing = 1.0f;

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass: [PhotoViewCell class] forCellWithReuseIdentifier: reuseIdentifier];
    
    // Do any additional setup after loading the view.
    
    loadedMedia = [[NSMutableArray alloc] initWithCapacity: kMaxItemPerPage];
    
    // Tweak layout settings
    [(UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout setMinimumLineSpacing: kItemSpacing];
    [(UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout setMinimumInteritemSpacing: kItemSpacing];
    // Calculate cell size
    CGFloat cellSize = (self.collectionView.bounds.size.width - (kItemSpacing * (kNumberOfColumns - 1))) / kNumberOfColumns;
    [(UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout setItemSize: CGSizeMake(cellSize, cellSize)];
    
    // Add bar button item
    UIButton *iconButton = [UIButton buttonWithType: UIButtonTypeCustom];
    iconButton.frame = CGRectMake(0.0f, 0.0f, 20.0f, 20.0f);
    [iconButton setImage: [UIImage imageNamed: @"icon_settings.png"] forState: UIControlStateNormal];
    [iconButton setImage: [UIImage imageNamed: @"icon_settings_selected.png"] forState: UIControlStateHighlighted];
    [iconButton setImage: [UIImage imageNamed: @"icon_settings_selected.png"] forState: UIControlStateSelected];
    [iconButton addTarget: self action: @selector(onSettings:) forControlEvents: UIControlEventTouchUpInside];
    settingsButton = [[UIBarButtonItem alloc] initWithCustomView: iconButton];
    [self.navigationItem setRightBarButtonItem: settingsButton];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear: animated];
    
    [self displayWaitDialog];
    
    // Fetch user photos
    [self fetchUserPhotos];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI components handler methods
-(void)onSettings:(id)sender
{
    NSLog(@"settings!");
}

#pragma mark - Photo fetching methods

-(void)fetchUserPhotos
{
    [[InstagramEngine sharedEngine] getSelfFeedWithCount: kMaxItemPerPage
                                                   maxId: currentPaginationInfo.nextMaxId
                                                 success: ^(NSArray *media, InstagramPaginationInfo *paginationInfo) {
                                                     
                                                     [self dismissWaitDialog];
                                                     
                                                     currentPaginationInfo = paginationInfo;
                                                     
                                                     [self addMorePhotos: media];
                                                     
                                                     if (loadedMedia.count < kInitialItemsToLoad) {
                                                         [self fetchUserPhotos];
                                                     }
                                                     
                                                 } failure: ^(NSError *error) {
                                                     
                                                     [self dismissWaitDialog];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
    hudView.backgroundColor = [UIColor colorWithWhite: 1.0 alpha: 0.5];
    [hudView addToDisplayQueue];
}

-(void)dismissWaitDialog
{
    [hudView dismiss];
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
    
    // Get InstagramMedia object for cell
    InstagramMedia *media = [loadedMedia objectAtIndex: indexPath.item];
    [cell loadPhotoFromURL: media.thumbnailURL];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate methods

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

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
