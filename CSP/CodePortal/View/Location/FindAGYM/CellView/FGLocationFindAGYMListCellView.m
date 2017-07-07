//
//  FGLocationFindAGYMListCellView.m
//  CSP
//
//  Created by Ryan Gong on 16/11/24.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGLocationFindAGYMListCellView.h"
#import "Global.h"
@implementation FGLocationFindAGYMListCellView
@synthesize view_container;
@synthesize lb_gymTitle;
@synthesize lb_distance;
@synthesize queueView_rating;
@synthesize lb_address;
@synthesize iv_gymThumbnail;
#pragma mark - 生命周期
-(void)awakeFromNib
{
    [super awakeFromNib];
    [commond useDefaultRatioToScaleView:view_container];
    [commond useDefaultRatioToScaleView:lb_gymTitle];
    [commond useDefaultRatioToScaleView:lb_distance];
    [commond useDefaultRatioToScaleView:queueView_rating];
    [commond useDefaultRatioToScaleView:lb_address];
    [commond useDefaultRatioToScaleView:iv_gymThumbnail];
    
    lb_gymTitle.font = font(FONT_TEXT_REGULAR, 16);
    lb_distance.font = font(FONT_TEXT_REGULAR, 14);
    lb_address.font = font(FONT_TEXT_REGULAR, 14);
    lb_address.numberOfLines = 0;
    
    [self setupRating];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
}

-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
}

-(void)setupRating
{
    NSMutableArray *_arr_imgs = (NSMutableArray *)@[@"popup_star_stoke.png",@"popup_star_stoke.png",@"popup_star_stoke.png",@"popup_star_stoke.png",@"popup_star_stoke.png"];
    NSMutableArray *_arr_imgs_highlighted = (NSMutableArray *)@[@"popup_star_filled.png",@"popup_star_filled.png",@"popup_star_filled.png",@"popup_star_filled.png",@"popup_star_filled.png"];
    CGRect imgBounds = CGRectMake(0, 0, 15 * ratioW, 15 * ratioH);
    [queueView_rating initalQueueByImageNames:_arr_imgs highlightedImageNames:_arr_imgs_highlighted padding:5 imgBounds:imgBounds increaseMode:ViewsQueueIncreaseMode_CENTER];
}

-(void)updateCellViewWithInfo:(id)_dataInfo
{
    lb_gymTitle.text = [_dataInfo objectForKey:@"ScreenName"];
    int level = [[_dataInfo objectForKey:@"Level"] intValue];
    [queueView_rating updateHighliteByCount:level];
    [iv_gymThumbnail sd_setImageWithURL:[NSURL URLWithString:[_dataInfo objectForKey:@"Thumbnail"]] placeholderImage:IMG_PLACEHOLDER];
    lb_address.text = [_dataInfo objectForKey:@"Address"];
    lb_distance.text = [_dataInfo objectForKey:@"Distance"];
    
}
@end
