//
//  FGLocationFindAGroupDetailViewController.h
//  CSP
//
//  Created by Ryan Gong on 16/11/24.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGBaseViewController.h"
#import "FGViewsQueueCustomView.h"
#import "FGCustomButton.h"
#import "FGPopupViewController.h"
@interface FGLocationFindAGroupDetailViewController : FGBaseViewController
{
    
}
@property(nonatomic,weak)IBOutlet UILabel *lb_groupname;
@property(nonatomic,weak)IBOutlet UILabel *lb_time;
@property(nonatomic,weak)IBOutlet UILabel *lb_location;
@property(nonatomic,weak)IBOutlet UITextView *tv_instruction;
@property(nonatomic,weak)IBOutlet UILabel *lb_participant;
@property(nonatomic,weak)IBOutlet FGViewsQueueCustomView *queueView_participants;
@property(nonatomic,weak)IBOutlet UIImageView *iv_orgnizer;
@property(nonatomic,weak)IBOutlet UILabel *lb_orgnizerName;
@property(nonatomic,weak)IBOutlet FGViewsQueueCustomView *queueView_rating;
@property(nonatomic,weak)IBOutlet UIView *view_groupInstruction;
@property(nonatomic,weak)IBOutlet UIView *view_pariciapnts;
@property(nonatomic,weak)IBOutlet UIView *view_oranizer;
@property(nonatomic,weak)IBOutlet UIButton *btn_join;
@property(nonatomic,weak)IBOutlet UIView *view_container;
@property(nonatomic,weak)IBOutlet UIImageView *iv_more;
@property(nonatomic,strong)FGPopupViewController *vc_popup_joinGroup;
#pragma mark - 按钮事件
-(IBAction)buttonAction_join:(id)_sender;
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil datas:(NSMutableDictionary *)_dic_datas;
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil datas:(NSMutableDictionary *)_dic_datas isMyGroup:(BOOL)_isMyGroup;
-(void)afterJoinGroup;
-(void)hideJoinButton;
@end
