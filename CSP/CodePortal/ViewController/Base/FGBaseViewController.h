//
//  FGBaseViewController.h
//  DunkinDonuts
//
//  Created by Ryan Gong on 15/11/10.
//  Copyright © 2015年 Ryan Gong. All rights reserved.
//

#import "FGBottomPanelView.h"
#import "FGTopPanelView.h"
#import "TAlertView.h"
#import <UIKit/UIKit.h>
#import "FGWindowsStyleProgressView.h"
typedef enum : BOOL { Show = YES, Hidden = NO } EMStatus;

extern STPopupController *vc_popup;

@interface FGBaseViewController : UIViewController {
}
@property(nonatomic, assign) FGTopPanelView *view_topPanel;
@property(nonatomic, assign) FGBottomPanelView *view_bottomPanel;
@property(nonatomic, strong) UIImageView *iv_bg;

- (void)manullyFixSize;
-(void)setWhiteBGStyle;
-(void)setRedBgStyle;
- (void)receivedDataFromNetwork:(NSNotification *)_notification;
- (void)requestFailedFromNetwork:(NSNotification *)_notification;
- (void)buttonAction_left:(id)_sender;
- (void)buttonAction_right:(id)_sender;
- (void)buttonAction_right_inside1:(id)_sender;
#pragma mark - 隐藏底部导航栏
- (void)hideBottomPanelWithAnimtaion:(BOOL)_animation;
#pragma mark - 显示底部导航栏
- (void)showBottomPanelWithAnimation:(BOOL)_animation;

#pragma mark - 顶部导航栏
- (void)topPanelStatus:(EMStatus)status withAnimtaion:(BOOL)_animation;

- (void)buttonAction_home:(id)_sender;
- (void)buttonAction_traning:(id)_sender;
- (void)buttonAction_post:(id)_sender;
- (void)buttonAction_location:(id)_sender;
- (void)buttonAction_profile:(id)_sender;
@end
