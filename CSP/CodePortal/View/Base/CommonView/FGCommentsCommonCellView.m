//
//  FGCommentsCommonView.m
//  CSP
//
//  Created by Ryan Gong on 16/9/20.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGCommentsCommonCellView.h"
#import "Global.h"
@implementation FGCommentsCommonCellView
@synthesize iv_thumbnail;
@synthesize lb_time;
@synthesize ml_comments;
@synthesize lb_username;
@synthesize view_separator;
@synthesize str_userId;
#pragma mark - 生命周期
- (void)awakeFromNib {
  [super awakeFromNib];
  [commond useDefaultRatioToScaleView:iv_thumbnail];
  [commond useDefaultRatioToScaleView:lb_username];
  [commond useDefaultRatioToScaleView:ml_comments];
  [commond useDefaultRatioToScaleView:lb_time];
  [commond useRatio:CGRectMake(ratioW, ratioH, ratioW, 1) toScaleView:view_separator];

  self.ml_comments.numberOfLines = 0;
    self.ml_comments.delegate = self;
  lb_username.font               = font(FONT_TEXT_REGULAR, 18);
  lb_time.font                   = font(FONT_TEXT_REGULAR, 16);

  lb_time.textColor     = [UIColor lightGrayColor];
  lb_username.textColor = [UIColor blackColor];

  iv_thumbnail.layer.cornerRadius  = iv_thumbnail.frame.size.width / 2;
  iv_thumbnail.layer.masksToBounds = YES;
    
    iv_thumbnail.userInteractionEnabled = YES;
    lb_username.userInteractionEnabled = YES;
    UITapGestureRecognizer *_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gesture_click:)];
    _tap.cancelsTouchesInView = NO;
    [iv_thumbnail addGestureRecognizer:_tap];
    _tap = nil;
    
    UITapGestureRecognizer *_tap_username = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gesture_click:)];
    _tap_username.cancelsTouchesInView = NO;
    [lb_username addGestureRecognizer:_tap_username];
    _tap_username = nil;
}

-(void)gesture_click:(id)_sender
{
    FGControllerManager *manager = [FGControllerManager sharedManager];
    FGFriendProfileViewController *vc_friendProfile = [[FGFriendProfileViewController alloc] initWithNibName:@"FGFriendProfileViewController" bundle:nil withFriendId:str_userId];
    [manager pushController:vc_friendProfile navigationController:nav_current];
}

- (void)layoutSubviews {
  [super layoutSubviews];

  //重新定 lb_time的位置 因为 lb_comments是可变高度的
  CGRect _frame   = lb_time.frame;
  _frame.origin.y = self.frame.size.height - lb_time.frame.size.height - 5 * ratioH;
  lb_time.frame   = _frame;
}

- (void)updateCellViewWithInfo:(id)_dataInfo {
  [self.ml_comments OHLB_setupHTMLParserWithContent:_dataInfo[@"Content"] width:223 * ratioW linkFont:font(FONT_TEXT_REGULAR, 17) normalFont:font(FONT_TEXT_REGULAR, 16)];
  [self.ml_comments OHALB_setupLineSpacing:1];
  [self.ml_comments OHALB_setupLinkColor:rgb(64, 162, 158)];
  [self.ml_comments OHALB_setupTextColor:rgb(120, 139, 140)];

  NSString *str_url = [_dataInfo objectForKey:@"UserIcon"];
    str_userId = [_dataInfo objectForKey:@"UserId"];
  [self.iv_thumbnail sd_setImageWithURL:[NSURL URLWithString:str_url] placeholderImage:IMG_PLACEHOLDER];
  self.lb_username.text = [_dataInfo objectForKey:@"UserName"];
  NSString *_str_formattedTime = [FGUtils intervalNowBeginWith1970SecondStr:[NSString stringWithFormat:@"%@", [_dataInfo objectForKey:@"CommandTime"]]];
  self.lb_time.text            = _str_formattedTime;
  [self sizeToFit];
}

- (void)dealloc {
  NSLog(@":::::>dealloc %s %d", __FUNCTION__, __LINE__);
    self.ml_comments.delegate = nil;
}

-(BOOL)attributedLabel:(OHAttributedLabel*)attributedLabel shouldFollowLink:(NSTextCheckingResult*)linkInfo;
{
    NSString *_str_jumpUrl = linkInfo.URL.absoluteString;
    if(_str_jumpUrl && ![_str_jumpUrl isEmptyStr])
    {
        if([_str_jumpUrl containsString:@"topicid"])
        {
            NSString *_topicid = [_str_jumpUrl stringByReplacingOccurrencesOfString:@"topicid:" withString:@""];
            NSString *_str_fulltext = attributedLabel.attributedText.string;
            NSString *_str_topicName = [_str_fulltext substringWithRange:linkInfo.range];
            
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
                
                FGControllerManager *manager = [FGControllerManager sharedManager];
                FGFriendProfileViewController *vc_friendProfile = [[FGFriendProfileViewController alloc] initWithNibName:@"FGFriendProfileViewController" bundle:nil withFriendId:_str_userid];
                [manager pushController:vc_friendProfile navigationController:nav_current];
            }
        }//yang.lu 连接到user profile
    }
    return YES;
}
@end
