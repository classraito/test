//
//  FGBadgeCollectionViewCell.m
//  CSP
//
//  Created by JasonLu on 16/10/11.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGPostCollectionViewCell.h"
#import "SDImageCache.h"
#import "Global.h"

@interface FGPostCollectionViewCell ()


@end

@implementation FGPostCollectionViewCell
@synthesize iv_thumbnail;
@synthesize iv_play;
- (void)awakeFromNib {
  [super awakeFromNib];
  // Initialization code
    iv_play.hidden = YES;
    iv_play.userInteractionEnabled = NO;
    [commond useDefaultRatioToScaleView:iv_play];
    iv_thumbnail.tag = 1;
}

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    // 初始化时加载collectionCell.xib文件
    NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"FGPostCollectionViewCell" owner:self options:nil];

    // 如果路径不存在，return nil
    if (arrayOfViews.count < 1) {
      return nil;
    }
    // 如果xib中view不属于UICollectionViewCell类，return nil
    if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]]) {
      return nil;
    }
    // 加载nib
    self = [arrayOfViews objectAtIndex:0];
      
     
  }
  return self;
}

- (void)setupBadgeWithInfo:(NSDictionary *)info {
    NSLog(@"info = %@",info);
    
}

-(void)setupPostThumbnailByUrlPath:(NSMutableDictionary * )_dic_info
{
    NSLog(@"_dic_info = %@",_dic_info);
    NSString *_str_thumbnail = [_dic_info objectForKey:@"Thumbnail"];
    NSString *_str_videoUrl = [_dic_info objectForKey:@"Video"];
    
    if([_str_videoUrl isEmptyStr])
    {
        iv_play.hidden = YES;
    }
    else
    {
        iv_play.hidden = NO;
    }
    
    if([_str_thumbnail isEmptyStr])
    {
        NSMutableArray *_arr_imgs = [_dic_info objectForKey:@"Images"];
        if(_arr_imgs && [_arr_imgs count] > 0)
            _str_thumbnail = [_arr_imgs objectAtIndex:0];
    }
    [iv_thumbnail sd_setImageWithURL:[NSURL URLWithString:_str_thumbnail]  placeholderImage:IMG_PLACEHOLDER ];
    
//    [iv_thumbnail sd_setImageWithURL:nil  placeholderImage:IMG_PLACEHOLDER ];
}

-(void)setupPostImageByUrlPath:(NSString *)_str_url;
{
    [iv_thumbnail sd_setImageWithURL:[NSURL URLWithString:_str_url] placeholderImage:IMG_PLACEHOLDER];
//    [iv_thumbnail sd_setImageWithURL:nil placeholderImage:IMG_PLACEHOLDER];
}
@end
