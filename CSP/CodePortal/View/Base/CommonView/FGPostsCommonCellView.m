//
//  FGPostsCommonCellView.m
//  CSP
//
//  Created by Ryan Gong on 16/10/17.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGPostsCommonCellView.h"
#import "Global.h"
#import "FGPostCollectionViewCell.h"




static NSString *const cellId   = @"cellId";

@interface FGPostsCommonCellView()
{
    NSMutableArray *arr_images;
    NSMutableArray *arr_bigImages;
    CGFloat cellWidth;
    AVPlayer *player;
    FGPostedVideoDownloadModel *model_postedVideo;
    AVPlayerLayer *sharedPlayerLayer;
    
}
@end


@implementation FGPostsCommonCellView
@synthesize view_separator;
@synthesize iv_thumbnail;
@synthesize lb_username;
@synthesize ml_content;
@synthesize lb_time;
@synthesize cv_images;
@synthesize indexPathInTable;
@synthesize iv_videoThumbnail;
@synthesize view_videoContainer;
@synthesize iv_playVideoIcon;
@synthesize aiv_videoDownload;
@synthesize str_postId;
@synthesize str_videoUrl;
@synthesize str_userID;
@synthesize str_userIconURL;
-(void)awakeFromNib
{
    [super awakeFromNib];
    [commond useRatio:CGRectMake(ratioW, ratioH, ratioW, .5) toScaleView:view_separator];
    [commond useDefaultRatioToScaleView:iv_thumbnail];
    [commond useDefaultRatioToScaleView:lb_username];
    [commond useDefaultRatioToScaleView:ml_content];
    [commond useDefaultRatioToScaleView:lb_time];
    [commond useDefaultRatioToScaleView:cv_images];
    [commond useDefaultRatioToScaleView:iv_videoThumbnail];
    [commond useDefaultRatioToScaleView:view_videoContainer];
    [commond useDefaultRatioToScaleView:iv_playVideoIcon];
    [commond useDefaultRatioToScaleView:aiv_videoDownload];
    aiv_videoDownload.hidesWhenStopped = YES;
    aiv_videoDownload.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    
    model_postedVideo = [FGPostedVideoDownloadModel sharedModel];
    
    lb_username.font = font(FONT_TEXT_BOLD, 16);
    lb_time.font = font(FONT_TEXT_REGULAR, 14);
    ml_content.font = font(FONT_TEXT_REGULAR, 14);
    
    ml_content.numberOfLines = 0;
    
    lb_time.textColor = [UIColor lightGrayColor];
    lb_username.textColor = [UIColor blackColor];
    
    iv_thumbnail.layer.cornerRadius = iv_thumbnail.frame.size.width / 2;
    iv_thumbnail.layer.masksToBounds = YES;
    
    [self internalInitalCollectionView];
    
    view_videoContainer.hidden = YES;
    view_videoContainer.layer.cornerRadius = 8;
    view_videoContainer.layer.masksToBounds = YES;
    view_videoContainer.backgroundColor = [UIColor clearColor];
    
    iv_playVideoIcon.userInteractionEnabled = NO;
    iv_videoThumbnail.userInteractionEnabled = YES;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playerItemDidReachEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(postedVideoDidFinishDownload:) name:NOTIFICATION_POSTEDVIDEODOWNLOAD_FINISHED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(postedVideoDidFailedDownload:) name:NOTIFICATION_POSTEDVIDEODOWNLOAD_FAILED object:nil];
    UITapGestureRecognizer *_tap_download = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gesture_clickDownloadVideo:)];
    _tap_download.cancelsTouchesInView = NO;
    [iv_videoThumbnail addGestureRecognizer:_tap_download];
    _tap_download = nil;
    
    UITapGestureRecognizer *_tap_zoom = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gesture_clickZoomVideo:)];
    _tap_zoom.cancelsTouchesInView = NO;
    [view_videoContainer addGestureRecognizer:_tap_zoom];
    _tap_zoom = nil;
    
    self.ml_content.delegate = self;
    
    UITapGestureRecognizer *_tap_clickName = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gesture_clickName:)];
    lb_username.userInteractionEnabled = YES;
    _tap_clickName.cancelsTouchesInView = NO;
    [lb_username addGestureRecognizer:_tap_clickName];
    _tap_clickName = nil;
    
    UITapGestureRecognizer *_tap_openUserAvatar = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gesture_clickName:)];
    iv_thumbnail.userInteractionEnabled = YES;
    _tap_openUserAvatar.cancelsTouchesInView = NO;
    [iv_thumbnail addGestureRecognizer:_tap_openUserAvatar];
    _tap_openUserAvatar = nil;
    
}

-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
    ml_content.delegate = nil;
    arr_images = nil;
    arr_bigImages = nil;
    indexPathInTable = nil;
    iv_thumbnail = nil;
    view_videoContainer = nil;
    str_videoUrl = nil;
    str_postId = nil;
    str_userID = nil;
    str_userIconURL = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_POSTEDVIDEODOWNLOAD_FINISHED object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_POSTEDVIDEODOWNLOAD_FAILED object:nil];
}



- (void)internalInitalCollectionView {
    //创建一个layout布局类
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //设置布局方向为垂直流布局
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    //设置每个item的大小
    
    
    cv_images.collectionViewLayout = layout;
    
    cv_images.backgroundColor = [UIColor clearColor];
    cv_images.dataSource      = self;
    cv_images.delegate        = self;
    cv_images.scrollEnabled = NO;
    // 注册cell、sectionHeader、sectionFooter
    [cv_images registerClass:[FGPostCollectionViewCell class] forCellWithReuseIdentifier:cellId];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    NSInteger imageCount = [arr_images count];
    
    
    if(![str_videoUrl isEmptyStr] && !arr_images)
    {
        CGRect _frame =view_videoContainer.frame;
        _frame.origin.y = ml_content.frame.origin.y + ml_content.frame.size.height +  10 * ratioH;
        _frame.size.width = 180 * ratioW;
        _frame.size.height = _frame.size.width / 1.33;//宽:高 = 4:3
        view_videoContainer.frame = _frame;
        
        iv_videoThumbnail.frame = view_videoContainer.bounds;
        aiv_videoDownload.center = CGPointMake(view_videoContainer.frame.size.width/2, view_videoContainer.frame.size.height/2);
        iv_playVideoIcon.center = aiv_videoDownload.center;
        if(sharedPlayerLayer)
            sharedPlayerLayer.frame = view_videoContainer.bounds;
    }
    else
    {
        
        CGFloat collecionViewHeight =  cellWidth;
        /*重新定 lb_time的位置 因为 lb_comments是可变高度的*/
        CGRect _frame =cv_images.frame;
        _frame.origin.y = ml_content.frame.origin.y + ml_content.frame.size.height +  10 * ratioH;
        _frame.size.width = (cellWidth + cellPadding) * [arr_images count];
        _frame.size.height = collecionViewHeight ;
        cv_images.frame = _frame;
    }
}

-(void)updateCellViewWithInfo:(id)_dataInfo
{
    NSString *_str_content = [_dataInfo objectForKey:@"Content"];
    [self.ml_content OHLB_setupHTMLParserWithContent:_str_content width:223 * ratioW linkFont:font(FONT_TEXT_REGULAR, 17)];
    
    [self.ml_content OHALB_setupLineSpacing:1];
    [self.ml_content OHALB_setupLinkColor:rgb(64, 162, 158)];
    
    str_userID = [_dataInfo objectForKey:@"UserId"];
    lb_username.text = [_dataInfo objectForKey:@"UserName"];
    str_userIconURL = [_dataInfo objectForKey:@"UserIcon"];
    [iv_thumbnail sd_setImageWithURL:[NSURL URLWithString:str_userIconURL]];
    lb_time.text = [FGUtils intervalNowBeginWith1970SecondStr:[NSString stringWithFormat:@"%@", [_dataInfo objectForKey:@"PostTime"]]];
    str_videoUrl = [_dataInfo objectForKey:@"Video"];
    str_postId = [NSString stringWithFormat:@"%@",[_dataInfo objectForKey:@"PostId"]];
    
    [arr_images removeAllObjects];
    [arr_bigImages removeAllObjects];
    arr_images = nil;
    arr_bigImages = nil;
    if(![str_videoUrl isEmptyStr])
    {
        view_videoContainer.hidden = NO;
        cv_images.hidden = YES;
        NSString *_str_videoThumbnailUrl = [_dataInfo objectForKey:@"Thumbnail"];
        [iv_videoThumbnail sd_setImageWithURL:[NSURL URLWithString:_str_videoThumbnailUrl] placeholderImage:IMG_PLACEHOLDER];
        
        /*获得全局共享的“播放器”, 因为不能初始化太多 只支持16个 同时播放*/
        sharedPlayerLayer = [[FGSharedAVPlayerLayer sharedModel] giveMeSharedPlayerLayer];
       
        /*加载视频资源*/
        PostedVideoDownloadStatuts downloadStatus =  [model_postedVideo getDownloadStatusByVideoUrl:str_videoUrl];
        if(downloadStatus == PostedVideoDownloadStatuts_DOWNLOADED)
        {
            NSString *_str_filepath = [model_postedVideo getDownlaodPathByVideoUrl:str_videoUrl];
            [self setupAVAssetByPath:_str_filepath];
        }
        
        /*更新UI*/
        [self updateVideoUIStatus];
        
    }
    else
    {
        arr_images = [[_dataInfo objectForKey:@"ImageThumbnails"] mutableCopy];
        arr_bigImages = [[_dataInfo objectForKey:@"Images"] mutableCopy];
        NSInteger imageCount = [arr_images count];
        [cv_images reloadData];
        view_videoContainer.hidden = YES;
        cv_images.hidden = NO;
        cellWidth = CollectionWidth / imageCount;
        cellWidth = imageCount == 1 ? CollectionWidth * 0.8f : cellWidth;//略微缩小1张图的 大小
        UICollectionViewFlowLayout *_layout = (UICollectionViewFlowLayout *)cv_images.collectionViewLayout;
        _layout.itemSize = CELLSIZE(cellWidth,cellWidth);
    }
    [self sizeToFit];
}

-(void)removeVideoPlayerLayerIfNeeded
{
    AVPlayerLayer *_playerLayer = nil;
    for(CALayer *_sublayer in view_videoContainer.layer.sublayers)
    {
        if([_sublayer isKindOfClass:[AVPlayerLayer class]])
        {
            _playerLayer  = (AVPlayerLayer *)_sublayer;
            break;
        }
    }
    if(_playerLayer)
    {
        [_playerLayer removeFromSuperlayer];
    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
        if([str_videoUrl isEmptyStr] && arr_bigImages && [arr_bigImages count]>0)//判断cell里装的都是图片
        {
            NSMutableArray *_arr_imageViews = [NSMutableArray arrayWithCapacity:1];
            for(UIView *_subview in cv_images.subviews)
            {
                if([_subview isKindOfClass:[FGPostCollectionViewCell class]])
                {
                    FGPostCollectionViewCell *_cell = (FGPostCollectionViewCell *)_subview;
                    if([arr_images containsObject:_cell.iv_thumbnail.sd_imageURL.absoluteString])//对比图片url是否在数据数组中 过滤掉复用的imageview
                    {
                        [_arr_imageViews addObject:_cell.iv_thumbnail];
                    }
                    
                }
            }//收集collectionView里所有的 imageviews
            
            [_arr_imageViews sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                UIImageView *iv1 = (UIImageView *)obj1;
                UIImageView *iv2 = (UIImageView *)obj2;
                NSString *_str_sdUrl = iv1.sd_imageURL.absoluteString;
                NSString *_str_sdUrl2 = iv2.sd_imageURL.absoluteString;
                NSInteger index1 = [arr_images indexOfObject:_str_sdUrl] ;
                NSInteger index2 = [arr_images indexOfObject:_str_sdUrl2];
                if(index1 < index2)
                    return NSOrderedAscending;
                else
                    return NSOrderedDescending;
            }];//从cv_images中获取的imageview对象可能是无序的，这里需要根据arr_images有序url数据 对_arr_imageViews排序
            
            //===================以上代码纯属收集KNPhotoBrower需要获得的正确数据========================
            
            
            [[FGPhotoGalleryManager sharedManager] showPhotoGalleryFromSourceViews:_arr_imageViews imgUrls:arr_bigImages atIndex:(int)indexPath.row];
            //显示图片浏览界面
        }
    
}

#pragma mark - UICollectionViewDataSource
//返回分区个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
//返回每个分区的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [arr_images count];
}

//返回每个item
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FGPostCollectionViewCell *cell = (FGPostCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    NSString *_str_url       = arr_images[indexPath.row];
    [cell setupPostImageByUrlPath:_str_url];
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
//定义每个UICollectionViewCell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CELLSIZE(cellWidth, cellWidth);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return cellPadding;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return cellPadding;
}

#pragma mark - updateVideoStatus
-(void)updateVideoUIStatus
{
    PostedVideoDownloadStatuts downloadStatus =  [model_postedVideo getDownloadStatusByVideoUrl:str_videoUrl];
    switch (downloadStatus) {
        case PostedVideoDownloadStatuts_DOWNLOADED:
            iv_playVideoIcon.hidden = YES;
            iv_videoThumbnail.hidden = YES;
            aiv_videoDownload.hidden = YES;
            [aiv_videoDownload stopAnimating];
            break;
        case PostedVideoDownloadStatuts_DOWNLOADING:
            iv_playVideoIcon.hidden = YES;
            aiv_videoDownload.hidden = NO;
            iv_videoThumbnail.hidden = NO;
            [aiv_videoDownload startAnimating];
            break;
        case PostedVideoDownloadStatuts_NOTDOWNLOAD:
        case PostedVideoDownloadStatuts_UNKNOW:
            iv_playVideoIcon.hidden = NO;
            iv_videoThumbnail.hidden = NO;
            aiv_videoDownload.hidden = YES;
            [aiv_videoDownload stopAnimating];
            break;
        default:
            break;
    }
    
}

-(void)gesture_clickDownloadVideo:(UITapGestureRecognizer *)_tap
{
    if([str_videoUrl isEmptyStr])
        return;
    
    
    PostedVideoDownloadStatuts downloadStatus =  [model_postedVideo getDownloadStatusByVideoUrl:str_videoUrl];
    if(downloadStatus == PostedVideoDownloadStatuts_DOWNLOADED)
    {
        
        NSString *_str_filepath = [model_postedVideo getDownlaodPathByVideoUrl:str_videoUrl];
       
        [self setupAVAssetByPath:_str_filepath];
    }
    else if(downloadStatus == PostedVideoDownloadStatuts_NOTDOWNLOAD)
    {
        [model_postedVideo startDownloadByVideoUrl:str_videoUrl postId:str_postId notifyVC:[self viewController]];
    }
    [self updateVideoUIStatus];
}

-(void)gesture_clickZoomVideo:(UITapGestureRecognizer *)_tap
{
    NSString *_str_filepath = [model_postedVideo getDownlaodPathByVideoUrl:str_videoUrl];
    [commond showPhotoVideoGalleryToView:appDelegate.window fromView:view_videoContainer imgs:nil imgIndex:0 videoUrl:_str_filepath];
}

-(void)gesture_clickName:(UITapGestureRecognizer *)_tap
{
    NSLog(@"str_userId = %@",str_userID);
    FGControllerManager *manager = [FGControllerManager sharedManager];
    FGFriendProfileViewController *vc_friendProfile = [[FGFriendProfileViewController alloc] initWithNibName:@"FGFriendProfileViewController" bundle:nil withFriendId:str_userID];
    [manager pushController:vc_friendProfile navigationController:nav_current];
}

#pragma mark - video
#pragma mark - 初始化单个PlayerItem


-(void)setupAVAssetByPath:(NSString *)_str_videoPath
{
    AVURLAsset *anAsset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:_str_videoPath] options:nil];
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:anAsset];
    [sharedPlayerLayer.player replaceCurrentItemWithPlayerItem:playerItem];
    
    [self removeVideoPlayerLayerIfNeeded];
    [[FGSharedAVPlayerLayer sharedModel] addPlayerLayer:sharedPlayerLayer toVideoContainerView:view_videoContainer];

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

#pragma mark - FGPostedVideoDownloadDelegate
-(void)postedVideoDidFinishDownload:(NSNotification *)_notification
{
    
    NSMutableDictionary *_dic_info = _notification.object;
    NSString *_str_savedPath = [_dic_info objectForKey:KEY_POSTVIDEO_DOWNLOADED_PATH];
    NSString *_str_postId = [_dic_info objectForKey:KEY_POSTVIDEO_POSTID];
    NSString *_str_videoUrl = [_dic_info objectForKey:KEY_POSTVIDEO_VIDEOURL];
    NSUInteger viewControllerHashCode = [[_dic_info objectForKey:KEY_POSTVIDEO_VIEWCONTROLLER_HASHCODE] longValue];//保证当前viewController才处理通知
    if([[self viewController] hash] != viewControllerHashCode)
        return;
    if([str_videoUrl isEmptyStr])
        return;
    if(!str_postId)
        return;
    if(![str_videoUrl isEqualToString:_str_videoUrl])
        return;
    if(![str_postId isEqualToString:_str_postId])
        return;
    
    [self setupAVAssetByPath:_str_savedPath];
    [self updateVideoUIStatus];
    
    
    
}

-(void)postedVideoDidFailedDownload:(NSNotification *)_notification
{
    NSMutableDictionary *_dic_info = _notification.object;
    NSString *_str_savedPath = [_dic_info objectForKey:KEY_POSTVIDEO_DOWNLOADED_PATH];
    NSString *_str_postId = [_dic_info objectForKey:KEY_POSTVIDEO_POSTID];
    NSString *_str_videoUrl = [_dic_info objectForKey:KEY_POSTVIDEO_VIDEOURL];
    NSUInteger viewControllerHashCode = [[_dic_info objectForKey:KEY_POSTVIDEO_VIEWCONTROLLER_HASHCODE] longValue];//保证当前viewController才处理通知
        return;
    if([str_videoUrl isEmptyStr])
        return;
    if(!str_postId)
        return;
    if(![str_videoUrl isEqualToString:_str_videoUrl])
        return;
    if(![str_postId isEqualToString:_str_postId])
        return;
    
    [self setupAVAssetByPath:_str_savedPath];
    [self updateVideoUIStatus];
}

#pragma mark - OHAttributedLabelDelegate
-(BOOL)attributedLabel:(OHAttributedLabel*)attributedLabel shouldFollowLink:(NSTextCheckingResult*)linkInfo;
{
    NSLog(@":::::>%s %d",__FUNCTION__,__LINE__);
    NSString *_str_jumpUrl = linkInfo.URL.absoluteString;
    NSLog(@"_str_jumpUrl = %@",_str_jumpUrl);
    if(_str_jumpUrl && ![_str_jumpUrl isEmptyStr])
    {
        if([_str_jumpUrl containsString:@"topicid"])
        {
            NSString *_topicid = [_str_jumpUrl stringByReplacingOccurrencesOfString:@"topicid:" withString:@""];
            NSString *_str_fulltext = attributedLabel.attributedText.string;
            NSString *_str_topicName = [_str_fulltext substringWithRange:linkInfo.range];
            NSLog(@"_str_topicName = %@",_str_topicName);
            NSLog(@"_topicid = %@",_topicid);
            FGControllerManager *manager = [FGControllerManager sharedManager];
            FGTopicViewController *vc_topic = [[FGTopicViewController alloc] initWithNibName:@"FGTopicViewController" bundle:nil topicId:_topicid topicName:_str_topicName];
            [manager pushController:vc_topic navigationController:nav_current];
        }
        else if([_str_jumpUrl containsString:@"userid"])
        {
            NSString *_str_userid = [_str_jumpUrl stringByReplacingOccurrencesOfString:@"userid:" withString:@""];
            if(![_str_userid isEmptyStr])
            {
                NSString *_str_fulltext = attributedLabel.attributedText.string;
                NSString *_str_userName = [_str_fulltext substringWithRange:linkInfo.range];
                NSLog(@"_str_userid = %@",_str_userid);
                NSLog(@"_str_userName = %@",_str_userName);
                
                
                FGControllerManager *manager = [FGControllerManager sharedManager];
                FGFriendProfileViewController *vc_friendProfile = [[FGFriendProfileViewController alloc] initWithNibName:@"FGFriendProfileViewController" bundle:nil withFriendId:_str_userid];
                [manager pushController:vc_friendProfile navigationController:nav_current];
            }
        }//yang.lu 连接到user profile
    }
    
    return YES;
}

@end
