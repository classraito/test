//
//  FGPostsCommonCellView.h
//  CSP
//
//  Created by Ryan Gong on 16/10/17.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OHAttributedLabel.h"
#import "FGPostedVideoDownloadModel.h"
#import "OHAttributedLabel.h"
#define cellPadding 4 * ratioH
#define CELLSIZE(width, height) CGSizeMake(width, height);
#define CollectionWidth 180 * ratioW

@interface FGPostsCommonCellView : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource,AVAssetDownloadDelegate,OHAttributedLabelDelegate>
{
    
}
@property(nonatomic,weak)IBOutlet UIView *view_separator;
@property(nonatomic,weak)IBOutlet UIImageView *iv_thumbnail;
@property(nonatomic,weak)IBOutlet UILabel *lb_username;
@property(nonatomic,weak)IBOutlet UILabel *lb_time;
@property(nonatomic,weak)IBOutlet OHAttributedLabel *ml_content;
@property(nonatomic,weak)IBOutlet UICollectionView *cv_images;
@property(nonatomic,weak)IBOutlet UIImageView *iv_videoThumbnail;
@property(nonatomic,weak)IBOutlet UIView *view_videoContainer;
@property(nonatomic,weak)IBOutlet UIImageView *iv_playVideoIcon;
@property(nonatomic,weak)IBOutlet UIActivityIndicatorView *aiv_videoDownload;
@property(nonatomic,strong)NSIndexPath *indexPathInTable;
@property(nonatomic,strong)NSString *str_postId;
@property(nonatomic,strong)NSString *str_videoUrl;
@property(nonatomic,strong)NSString *str_userID;
@property(nonatomic,strong)NSString *str_userIconURL;
-(void)setupAVAssetByPath:(NSString *)_str_videoPath;
-(void)removeVideoPlayerLayerIfNeeded;
@end
