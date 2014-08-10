//
//  PhotoViewCell.m
//  InstaMe
//
//  Created by Huijie Wu on 10/8/14.
//  Copyright (c) 2014 Ackworx. All rights reserved.
//

#import "PhotoViewCell.h"
#import <UIImageView+AFNetworking.h>

@implementation PhotoViewCell

@synthesize imageView=_imageView;

-(instancetype)initWithFrame:(CGRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if (self)
    {
        //self.backgroundColor = [UIColor whiteColor];
        
        CGRect rect = CGRectInset(self.bounds, 2.0f, 2.0f);
        _imageView = [[UIImageView alloc] initWithFrame: rect];
        _imageView.backgroundColor = [UIColor darkGrayColor];
        [self addSubview: _imageView];
        
        // Set selected background view
        UIView *selectedBgView = [[UIView alloc] initWithFrame: self.bounds];
        selectedBgView.backgroundColor = [UIColor whiteColor];
        self.selectedBackgroundView = selectedBgView;
    }
    
    return self;
}

-(void)loadPhotoFromURL:(NSURL *)url
{
    [_imageView setImage: nil];
    
    if (url != nil)
    {
        [_imageView setImageWithURL: url];
    }
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame: frame];
    
    if (_imageView != nil)
    {
        CGRect rect = CGRectInset(self.bounds, 2.0f, 2.0f);
        _imageView.frame = rect;
    }
}

@end
