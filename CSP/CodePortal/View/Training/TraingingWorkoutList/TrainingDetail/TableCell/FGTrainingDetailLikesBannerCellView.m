//
//  FGTrainingDetailLikesBannerCellView.m
//  CSP
//
//  Created by Ryan Gong on 16/9/20.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGTrainingDetailLikesBannerCellView.h"
#import "Global.h"
@interface FGTrainingDetailLikesBannerCellView()
{
    NSMutableArray *arr_imageViews;
}
@end

@implementation FGTrainingDetailLikesBannerCellView
@synthesize qv_imagesQueue;
@synthesize lb_likes;
@synthesize iv_dot;
@synthesize view_whiteBg;
#pragma mark - 生命周期
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [commond useDefaultRatioToScaleView:view_whiteBg];
    [commond useDefaultRatioToScaleView:qv_imagesQueue];
    [commond useDefaultRatioToScaleView:lb_likes];
    [commond useDefaultRatioToScaleView:iv_dot];
    
    lb_likes.font = font(FONT_TEXT_REGULAR, 13);
    
}

-(void)updateCellViewWithInfo:(id)_dataInfo
{
    NSLog(@"FGTrainingDetailLikesBannerCellView _dataInfo = %@",_dataInfo);
    
    NSMutableArray *arr_likes = [((NSMutableDictionary *)_dataInfo) objectForKey:@"Likes"];
    NSMutableArray *_arr_imgs = [NSMutableArray arrayWithCapacity:1];
    for(NSMutableDictionary * _dic_single in arr_likes)
    {
        NSString *_str_imgUrl = [_dic_single objectForKey:@"UserIcon"];
        [_arr_imgs addObject:_str_imgUrl];
    }
    CGRect imgBounds = CGRectMake(0, 0, 22 * ratioW, 22 * ratioH);
    NSMutableArray *arr_ivs = [qv_imagesQueue initalQueueByImageNames:_arr_imgs highlightedImageNames:nil padding:6 imgBounds:imgBounds increaseMode:ViewsQueueIncreaseMode_LEFT];
    for(UIImageView *iv in arr_ivs)
    {
        iv.layer.cornerRadius = iv.frame.size.width / 2;
        iv.layer.masksToBounds = YES;
    }
    int totalLikesCount = [[((NSMutableDictionary *)_dataInfo) objectForKey:@"TotalCount"] intValue];
    lb_likes.text = [NSString stringWithFormat:@"%d%@",totalLikesCount,multiLanguage(@"   LIKES")];
}

-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
}
@end
