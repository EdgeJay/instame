//
//  PhotoViewCell.h
//  InstaMe
//
//  Created by Huijie Wu on 10/8/14.
//  Copyright (c) 2014 Ackworx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoViewCell : UICollectionViewCell

@property (nonatomic, readonly) UIImageView *imageView;

-(void)loadPhotoFromURL:(NSURL *)url;
@end
