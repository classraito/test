//
//  FGPhotoVideoGallery.m
//  CSP
//
//  Created by Ryan Gong on 16/11/11.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGPhotoVideoGallery.h"
#import "Global.h"
@interface FGPhotoVideoGallery()
{
    AVPlayerLayer *sharedPlayerLayer;
}
@end


@implementation FGPhotoVideoGallery
@synthesize sv;
@synthesize pc;
@synthesize view_videoContainer;
@synthesize rect_showFrom;
@synthesize delegate;
#pragma mark - 生命周期
-(void)awakeFromNib
{
    [super awakeFromNib];
    [commond useDefaultRatioToScaleView:pc];
    [commond useDefaultRatioToScaleView:view_videoContainer];
    UITapGestureRecognizer *_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToCacncel:)];
    _tap.cancelsTouchesInView = NO;
    [self addGestureRecognizer:_tap];
    _tap = nil;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [self internalLayout];
}

-(void)internalLayout
{
    if(view_videoContainer)
    {
        sharedPlayerLayer.frame = view_videoContainer.bounds;
    }
    else
    {
        sv.frame = self.bounds;
        int index =0;
        for(UIView *_subView in sv.subviews)
        {
            
            if([_subView isKindOfClass:[UIImageView class]])
            {
                UIImageView *iv = (UIImageView *)_subView;
                CGRect _frame = iv.frame;
                _frame.origin.x = sv.frame.size.width * index;
                _frame.size = sv.frame.size;
                iv.frame = _frame;
                NSLog(@"iv.frame = %@",NSStringFromCGRect(iv.frame));
                index++;
            }
        }
        sv.contentSize = CGSizeMake(self.frame.size.width * pc.numberOfPages, self.frame.size.height);
        sv.contentOffset = CGPointMake(sv.frame.size.width * pc.currentPage, sv.contentOffset.y);
        sv.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
        NSLog(@"pc.currentPage = %ld",pc.currentPage);
        NSLog(@"sv.contentOffset = %@",NSStringFromCGPoint(sv.contentOffset));
    }
    
    
    
}

-(void)setupByImagUrls:(NSMutableArray *)_arr_imgUrls currentIndex:(NSInteger)_currentIndex videoUrl:(NSString *)_str_videoUrl
{
    if(_arr_imgUrls)
    {
        SAFE_RemoveSupreView(view_videoContainer);
        view_videoContainer = nil;
        pc.currentPage = _currentIndex;
        pc.numberOfPages = [_arr_imgUrls count];
        [self internalInitalImageURLs:_arr_imgUrls];
    }
    else if(_str_videoUrl)
    {
        SAFE_RemoveSupreView(sv);
        SAFE_RemoveSupreView(pc);

        [self internalInitalVideos:_str_videoUrl];
    }
}

-(void)setupByImags:(NSMutableArray *)_arr_imgs  currentIndex:(NSInteger)_currentIndex  videoUrl:(NSString *)_str_videoUrl
{
    if(_arr_imgs)
    {
        SAFE_RemoveSupreView(view_videoContainer);
        view_videoContainer = nil;
        pc.currentPage = _currentIndex;
        pc.numberOfPages = [_arr_imgs count];
        [self internalInitalImages:_arr_imgs];
    }
    else if(_str_videoUrl)
    {
        SAFE_RemoveSupreView(sv);
        SAFE_RemoveSupreView(pc);
        
        [self internalInitalVideos:_str_videoUrl];
    }
}

-(void)internalInitalImages:(NSMutableArray *)_arr_imgs
{
    
    int index = 0;
    for(UIImage *__img in _arr_imgs)
    {
        UIImageView *iv = [[UIImageView alloc] initWithImage:__img];
        iv.frame = sv.bounds;
        iv.contentMode = UIViewContentModeScaleAspectFit;
        iv.clipsToBounds = YES;
        iv.backgroundColor = [UIColor blackColor];
        CGRect _frame = iv.frame;
        _frame.origin.x = sv.frame.size.width * index;
        iv.frame = _frame;
        [sv addSubview:iv];
        index++;
        
    }
    [self internalLayout];
    
}


-(void)internalInitalImageURLs:(NSMutableArray *)_arr_imgUrls
{
    
    int index = 0;
    for(NSString *_str_url in _arr_imgUrls)
    {
        UIImageView *iv = [[UIImageView alloc] initWithFrame:sv.bounds];
        iv.contentMode = UIViewContentModeScaleAspectFit;
        
        iv.clipsToBounds = YES;
//        [iv setShowActivityIndicatorView:YES];
//        [iv setIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [iv sd_setImageWithURL:[NSURL URLWithString:_str_url] placeholderImage:IMG_PLACEHOLDER ];
        iv.backgroundColor = [UIColor blackColor];
        CGRect _frame = iv.frame;
        _frame.origin.x = sv.frame.size.width * index;
        iv.frame = _frame;
        [sv addSubview:iv];
        index++;
        
    }
    [self internalLayout];
    
}

-(void)setupAVAssetByPath:(NSString *)_str_videoPath
{
    sharedPlayerLayer = [commond getSharedPlayerLayer];
    [sharedPlayerLayer.player setMuted:NO];
    NSLog(@"_str_videoPath = %@",_str_videoPath);
    AVURLAsset *anAsset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:_str_videoPath] options:nil];
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:anAsset];
    [sharedPlayerLayer.player replaceCurrentItemWithPlayerItem:playerItem];
    
    [commond addPublicPlayerLayerToVideoContainerView:view_videoContainer];
    
}


- (void)playerItemDidReachEnd:(NSNotification *)notification {
    
    AVPlayerItem *_playerItem = [notification object];
    
    if(sharedPlayerLayer && [_playerItem isEqual:sharedPlayerLayer.player.currentItem])
    {
        if(sharedPlayerLayer.player.status == AVPlayerItemStatusReadyToPlay)
        {
            [sharedPlayerLayer.player.currentItem seekToTime: kCMTimeZero
                                             toleranceBefore: kCMTimeZero
                                              toleranceAfter: kCMTimeZero
                                           completionHandler: ^(BOOL finished)
             {
                 if(finished)
                 {
                     [sharedPlayerLayer.player play];
                 }
                 
             }];
        }
    }
}

-(void)internalInitalVideos:(NSString *)_str_videoUrl
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playerItemDidReachEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    [self setupAVAssetByPath:_str_videoUrl];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
{
    pc.currentPage = scrollView.contentOffset.x / sv.frame.size.width;
    
}

-(void)tapToCacncel:(id)_sender
{
    NSLog(@"tapToCancel");
    
    [commond removePhotoVideoGallery];
    if(delegate && [delegate respondsToSelector:@selector(didClickClose)])
    {
        [delegate didClickClose];
    }
}

-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
    if(view_videoContainer)
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
        [sharedPlayerLayer.player pause];
        [sharedPlayerLayer removeFromSuperlayer];
        
    }
}
@end
