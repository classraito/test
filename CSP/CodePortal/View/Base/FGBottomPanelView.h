//
//  FGBottomPanelView.h
//  CSP
//
//  Created by Ryan Gong on 16/9/12.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FGControllerManager.h"

@interface FGBottomPanelView : UIView
{
    
}

@property(nonatomic,assign)IBOutlet UIImageView *iv_home;
@property(nonatomic,assign)IBOutlet UIImageView *iv_traning;
@property(nonatomic,assign)IBOutlet UIImageView *iv_post;
@property(nonatomic,assign)IBOutlet UIImageView *iv_location;
@property(nonatomic,assign)IBOutlet UIImageView *iv_profile;

@property(nonatomic,assign)IBOutlet UILabel *lb_home;
@property(nonatomic,assign)IBOutlet UILabel *lb_training;
@property(nonatomic,assign)IBOutlet UILabel *lb_post;
@property(nonatomic,assign)IBOutlet UILabel *lb_locations;
@property(nonatomic,assign)IBOutlet UILabel *lb_profile;

@property(nonatomic,assign)IBOutlet UIButton *btn_home;
@property(nonatomic,assign)IBOutlet UIButton *btn_traning;
@property(nonatomic,assign)IBOutlet UIButton *btn_post;
@property(nonatomic,assign)IBOutlet UIButton *btn_location;
@property(nonatomic,assign)IBOutlet UIButton *btn_profile;


#pragma mark - 切换按钮状态
-(void)setAllButtonNormalStatus;
#pragma mark - 设置按钮高亮
-(void)setButtonHighlightedByStatus:(int)_navigationStatus;
@end
