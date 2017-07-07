//
//  FGProfileInfoCellView.h
//  CSP
//
//  Created by JasonLu on 16/10/8.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FGCircluarForUserIconButton;
@class FGCircluarWithBottomTitleButton;
@interface FGProfileInfoCellView : UITableViewCell
@property (weak, nonatomic) IBOutlet FGCircluarForUserIconButton *view_useIconAndname;
@property (weak, nonatomic) IBOutlet UILabel *lb_username;
@property (weak, nonatomic) IBOutlet UILabel *lb_youhuiCode;
@property (weak, nonatomic) IBOutlet UIView *view_youhuibg;

@property (weak, nonatomic) IBOutlet UIButton *btn_follower;
@property (weak, nonatomic) IBOutlet UIButton *btn_post;
@property (weak, nonatomic) IBOutlet UIButton *btn_follow;
@property (weak, nonatomic) IBOutlet UIButton *btn_copyYouhui;

@property (weak, nonatomic) IBOutlet UILabel *lb_edit;
@property (weak, nonatomic) IBOutlet UIImageView *iv_bg;

- (void)setupPostBtnTitle:(NSString *)postTitle followBtnTitle:(NSString *)followTitle followerBtnTitle:(NSString *)followerTitle;
@end
