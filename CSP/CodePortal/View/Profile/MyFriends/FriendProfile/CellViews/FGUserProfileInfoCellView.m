//
//  FGUserProfileInfoCellView.m
//  CSP
//
//  Created by JasonLu on 16/11/15.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//
#import "FGCircluarForUserIconButton.h"
#import "FGCircluarWithRightTitleButton.h"
#import "FGUserProfileInfoCellView.h"
#import "UIImage+BlurEffect.h"

@implementation FGUserProfileInfoCellView
@synthesize btn_addFriend;

#pragma mark - 生命周期
- (void)awakeFromNib {
  [super awakeFromNib];
  
  [commond useDefaultRatioToScaleView:btn_addFriend];
  
  [self.btn_addFriend setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
  [self.btn_addFriend.titleLabel setFont:font(FONT_TEXT_REGULAR, 14)];
  self.btn_addFriend.layer.borderColor = [UIColor redColor].CGColor;
  self.btn_addFriend.layer.borderWidth = 1.0;
  self.btn_addFriend.backgroundColor   = [UIColor clearColor];
  self.btn_addFriend.layer.cornerRadius = 5.0;

  [self.view_useIconAndname setIconButtonTouchWhenHighlighted:NO];
    [self.view_useIconAndname.btn addTarget:self action:@selector(buttonAction_clickAvatar:) forControlEvents:UIControlEventTouchUpInside];
  
  self.lb_username.font      = font(FONT_TEXT_REGULAR, 16);
  self.lb_username.textColor = [UIColor whiteColor];
  self.backgroundColor    = [UIColor clearColor];
  [self.lb_username setTextAlignment:NSTextAlignmentLeft];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

- (void)dealloc {
  NSLog(@":::::>dealloc %s %d", __FUNCTION__, __LINE__);
}

-(void)buttonAction_clickAvatar:(id)_sender
{
    [[FGPhotoGalleryManager sharedManager] showPhotoGalleryFromSourceViews:(NSMutableArray *)@[self.view_useIconAndname.vi_icon] imgUrls:nil atIndex:0];
}

#pragma mark - 成员方法
- (void)updateCellViewWithInfo:(id)_dataInfo {
  if (_dataInfo == nil)
    return;
  
  NSString * _str_post = _dataInfo[@"post"];
  NSString * _str_follow = _dataInfo[@"follow"];
  NSString * _str_follower = _dataInfo[@"follower"];
  [self setupPostBtnTitle:_str_post followBtnTitle:_str_follow followerBtnTitle:_str_follower];
  self.backgroundColor    = [UIColor clearColor];
  
  NSString *username = _dataInfo[@"username"];
  NSString *title    = [NSString stringWithFormat:@"%@",username];
  UIImage *blurImage = _dataInfo[@"imgbg"];
  UIImage *tmpImage  = _dataInfo[@"img"];

  [self.iv_bg setImage:blurImage];
  [self.view_useIconAndname setupButtonInfoWithTitle:title titleColor:[UIColor whiteColor] titleAlignment:VerticalAlignmentBottom textAlignment:NSTextAlignmentCenter buttonImage:tmpImage];
  [self.view_useIconAndname setProcessPercent:0.3];
  [self.view_useIconAndname setupStatusWithShowProcessBg:YES showProcess:NO];
  
  //判断是否是自己，如果是自己就隐藏按钮
  NSString *_str_id = _dataInfo[@"id"];
  NSString *_str_currentId = [NSString stringWithFormat:@"%@",[commond getUserDefaults:KEY_API_USER_USERID]];
  if ([_str_id isEqualToString:_str_currentId]) {
    self.btn_addFriend.hidden = YES;
  } else {
    self.btn_addFriend.hidden = NO;
  }
  BOOL bool_isFollowed = [_dataInfo[@"isFollowed"] boolValue];
  NSString * _str_tmp = @"";
  if (bool_isFollowed) {
    _str_tmp = multiLanguage(@"UNFOLLOW");
  } else {
    _str_tmp = multiLanguage(@"FOLLOW");
  }
  [self.btn_addFriend setTitle:_str_tmp forState:UIControlStateNormal];
  self.btn_addFriend.showsTouchWhenHighlighted = YES;
  
  self.lb_username.text = username;
}

- (void)setupPostBtnTitle:(NSString *)postTitle followBtnTitle:(NSString *)followTitle followerBtnTitle:(NSString *)followerTitle {
  [super setupPostBtnTitle:postTitle followBtnTitle:followTitle followerBtnTitle:followerTitle];
}
@end
