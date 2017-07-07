//
//  FGUserPickupTableViewCell.m
//  CSP
//
//  Created by Ryan Gong on 16/11/16.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGUserPickupTableViewCell.h"
#import "FGUserPickupViewController.h"
@implementation FGUserPickupTableViewCell
@synthesize iv_thumbnail;
@synthesize lb_title;
@synthesize lb_topicTitle;
@synthesize str_userid;
@synthesize listType;
#pragma mark - 生命周期
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [commond useDefaultRatioToScaleView:iv_thumbnail];
    [commond useDefaultRatioToScaleView:lb_title];
    [commond useDefaultRatioToScaleView:lb_topicTitle];
    lb_title.font = font(FONT_TEXT_BOLD, 16);
    lb_topicTitle.font = font(FONT_TEXT_BOLD, 18);
    lb_topicTitle.textAlignment = NSTextAlignmentCenter;
    
    iv_thumbnail.layer.cornerRadius = iv_thumbnail.frame.size.width / 2;
    iv_thumbnail.layer.masksToBounds = YES;
}

-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
}

-(void)updateCellViewWithInfo:(id)_dataInfo
{
    if(listType == ListType_User)
    {
        [iv_thumbnail sd_setImageWithURL:[_dataInfo objectForKey:@"UserIcon"] placeholderImage:IMG_PLACEHOLDER];
        lb_title.text = [_dataInfo objectForKey:@"UserName"];
        lb_title.textAlignment = NSTextAlignmentRight;
        lb_title.font = font(FONT_TEXT_BOLD, 16);
        str_userid = [NSString stringWithFormat:@"%@",[_dataInfo objectForKey:@"UserId"]] ;
    }
    else if(listType == ListType_Topic)
    {
        iv_thumbnail.hidden = YES;
        lb_topicTitle.text = [_dataInfo objectForKey:@"topical"];
        str_userid = [NSString stringWithFormat:@"%@",[_dataInfo objectForKey:@"id"]] ;
        if([str_userid isEqualToString:@"NewTopic"])
        {
            lb_topicTitle.textColor = color_red_panel;
        }
        else
            lb_topicTitle.textColor = [UIColor blackColor];
    }
    else if(listType == ListType_Contacts)
    {
      [iv_thumbnail setImage:_dataInfo[@"UserIcon"]];
      lb_title.text = [_dataInfo objectForKey:@"UserName"];
      lb_title.textAlignment = NSTextAlignmentRight;
      lb_title.font = font(FONT_TEXT_BOLD, 16);
      str_userid = [NSString stringWithFormat:@"%@",[_dataInfo objectForKey:@"UserId"]] ;
    }

  
}
@end
