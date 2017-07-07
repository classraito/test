//
//  FGLocationFindAGroupDetailViewController.m
//  CSP
//
//  Created by Ryan Gong on 16/11/24.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGLocationFindAGroupDetailViewController.h"
#import "Global.h"
@interface FGLocationFindAGroupDetailViewController ()
{
    NSMutableDictionary *dic_datas;
    NSString *str_groupID;
    BOOL isMyGroup;
}
@end

@implementation FGLocationFindAGroupDetailViewController
@synthesize lb_groupname;
@synthesize lb_location;
@synthesize lb_time;
@synthesize tv_instruction;
@synthesize lb_participant;
@synthesize queueView_participants;
@synthesize iv_orgnizer;
@synthesize lb_orgnizerName;
@synthesize queueView_rating;
@synthesize view_groupInstruction;
@synthesize view_pariciapnts;
@synthesize view_oranizer;
@synthesize btn_join;
@synthesize view_container;
@synthesize iv_more;
@synthesize vc_popup_joinGroup;
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil datas:(NSMutableDictionary *)_dic_datas
{
    if(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        dic_datas = [_dic_datas mutableCopy];
    }
    return self;
}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil datas:(NSMutableDictionary *)_dic_datas isMyGroup:(BOOL)_isMyGroup
{
    if(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        dic_datas = [_dic_datas mutableCopy];
        isMyGroup = _isMyGroup;
    }
    return self;
}

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [commond useDefaultRatioToScaleView:lb_groupname];
    [commond useDefaultRatioToScaleView:tv_instruction];
    [commond useDefaultRatioToScaleView:lb_participant];
    [commond useDefaultRatioToScaleView:queueView_participants];
    [commond useDefaultRatioToScaleView:iv_orgnizer];
    [commond useDefaultRatioToScaleView:lb_orgnizerName];
    [commond useDefaultRatioToScaleView:queueView_rating];
    [commond useDefaultRatioToScaleView:view_groupInstruction];
    [commond useDefaultRatioToScaleView:view_pariciapnts];
    [commond useDefaultRatioToScaleView:view_oranizer];
    [commond useDefaultRatioToScaleView:btn_join];
    [commond useDefaultRatioToScaleView:view_container];
    [commond useDefaultRatioToScaleView:iv_more];
    [commond useDefaultRatioToScaleView:lb_time];
    [commond useDefaultRatioToScaleView:lb_location];
    
    iv_orgnizer.layer.cornerRadius = iv_orgnizer.frame.size.width / 2;
    iv_orgnizer.layer.masksToBounds = YES;
    
    lb_groupname.font = font(FONT_TEXT_REGULAR, 16);
    tv_instruction.font = font(FONT_TEXT_REGULAR, 12);
    lb_participant.font = font(FONT_TEXT_REGULAR, 12);
    lb_orgnizerName.font = font(FONT_TEXT_REGULAR, 12);
    lb_time.font = font(FONT_TEXT_REGULAR, 12);
    lb_location.font = font(FONT_TEXT_REGULAR, 12);
    
    btn_join.titleLabel.font = font(FONT_TEXT_REGULAR, 18);
    
    // Do any additional setup after loading the view from its nib.
    self.view_topPanel.str_title = multiLanguage(@"GROUP DETAIL");
    [btn_join setTitle:multiLanguage(@"Join Group") forState:UIControlStateNormal];
    [btn_join setTitle:multiLanguage(@"Join Group") forState:UIControlStateHighlighted];
    
    [self hideBottomPanelWithAnimtaion:NO];

    [self bindDataToUI];
    
    [self postRequest_groupDetailPage];
    
    if(isMyGroup)
        [self hideJoinButton];
    
    UITapGestureRecognizer *_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gesture_clickPariciapnts:)];
    _tap.cancelsTouchesInView = NO;
    [view_pariciapnts addGestureRecognizer:_tap];
    _tap = nil;
    
    self.btn_join.hidden = YES;
    
}

-(void)hideJoinButton
{
    [self.btn_join removeFromSuperview];
    self.btn_join = nil;
}

-(void)changeJoinButtonToLeave
{
    [self.btn_join setTitle:multiLanguage(@"LEAVE") forState:UIControlStateNormal];
    [self.btn_join setTitle:multiLanguage(@"LEAVE") forState:UIControlStateHighlighted];
}

-(void)setupPariciapnts:(NSMutableArray *)_arr_participantsData
{
  
    NSMutableArray *_arr_imgs = [NSMutableArray arrayWithCapacity:1];
    for(NSMutableDictionary * _dic_single in _arr_participantsData)
    {
        if([_arr_imgs count] < 7)
        {
            NSString *_str_imgUrl = [_dic_single objectForKey:@"UserIcon"];
            [_arr_imgs addObject:_str_imgUrl];
        }//最多显示7个
        
    }
    CGRect imgBounds = CGRectMake(0, 0, 22 * ratioW, 22 * ratioH);
    NSMutableArray *arr_images =  [queueView_participants initalQueueByImageNames:_arr_imgs highlightedImageNames:nil padding:6 imgBounds:imgBounds increaseMode:ViewsQueueIncreaseMode_LEFT];
    for(UIImageView *iv in arr_images)
    {
        iv.layer.cornerRadius = iv.frame.size.width / 2;
        iv.layer.masksToBounds = YES;
    }//把图片设成圆形
}

-(void)setupRating
{
    NSMutableArray *_arr_imgs = (NSMutableArray *)@[@"popup_star_stoke.png",@"popup_star_stoke.png",@"popup_star_stoke.png",@"popup_star_stoke.png",@"popup_star_stoke.png"];
    NSMutableArray *_arr_imgs_highlighted = (NSMutableArray *)@[@"popup_star_filled.png",@"popup_star_filled.png",@"popup_star_filled.png",@"popup_star_filled.png",@"popup_star_filled.png"];
    CGRect imgBounds = CGRectMake(0, 0, 15 * ratioW, 15 * ratioH);
    [queueView_rating initalQueueByImageNames:_arr_imgs highlightedImageNames:_arr_imgs_highlighted padding:5 imgBounds:imgBounds increaseMode:ViewsQueueIncreaseMode_RIGHT];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setWhiteBGStyle];
}

-(void)manullyFixSize
{
    [super manullyFixSize];
}

-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
    dic_datas = nil;
    vc_popup_joinGroup = nil;
}

-(void)internalInitalJoinGroup
{
    if(vc_popup_joinGroup)
        return;
    vc_popup_joinGroup = [[FGPopupViewController alloc] initWithNibName:@"FGPopupViewController" bundle:nil];
    [vc_popup_joinGroup inital_joinGroup];
    [nav_current presentViewController:vc_popup_joinGroup animated:NO completion:nil];
}

#pragma mark - 从父类继承的
-(void)receivedDataFromNetwork:(NSNotification *)_notification
{
    [super receivedDataFromNetwork:_notification];
    NSMutableDictionary *_dic_requestInfo = _notification.object;
    NSLog(@"_dic_requestInfo = %@",_dic_requestInfo);
    NSString *_str_url                    = [_dic_requestInfo objectForKey:@"url"];
    if ([HOST(URL_LOCATION_GroupDetailPage) isEqualToString:_str_url]) {
        [self bindDataToUI_Participant_Organizer];
    }
    if([HOST(URL_LOCATION_JoinGroup) isEqualToString:_str_url])
    {
        [self afterJoinGroup];
        [self internalInitalJoinGroup];
        
        NSMutableDictionary *_dic_attrs = [NSMutableDictionary dictionaryWithCapacity:1];
        [_dic_attrs setObject:str_groupID forKey:KEY_TRACK_ATTRID_JOINGROUP_GROUPID];
        [NetworkEventTrack track:KEY_TRACK_EVENTID_JOINGROUP attrs:_dic_attrs];  //追踪  加入一个小组
       
    }
    if ([HOST(URL_LOCATION_LeaveGroup) isEqualToString:_str_url])
    {
        [self afterJoinGroup];
    }

}

-(void)requestFailedFromNetwork:(NSNotification *)_notification
{
    [super requestFailedFromNetwork:_notification];
}

#pragma mark - post
-(void)postRequest_groupDetailPage
{
    NetworkRequestInfo *_dic_info = [NetworkRequestInfo infoWithURLAlias:@"" notifyOnVC:self];
    NetworkManager_Location *manager = [NetworkManager_Location sharedManager];
    [manager postRequest_Locations_groupDetailPage:str_groupID userinfo:_dic_info];
}

-(void)postRequest_joinGroup
{
     NetworkRequestInfo *_dic_info = [NetworkRequestInfo infoWithURLAlias:@"" notifyOnVC:self];
    NetworkManager_Location *manager = [NetworkManager_Location sharedManager];
    [manager postRequest_Locations_joinGroup:str_groupID userinfo:_dic_info];
}

-(void)postRequest_leave
{
    NetworkRequestInfo *_dic_info = [NetworkRequestInfo infoWithURLAlias:nil notifyOnVC:self ];
    NetworkManager_Location *manager = [NetworkManager_Location sharedManager];
    [manager postRequest_Locations_leaveGroup:str_groupID userinfo:_dic_info];
    [commond alert:multiLanguage(@"ALERT") message:multiLanguage(@"You left from this group") callback:^(FGCustomAlertView *alertView, NSInteger buttonIndex) {}];
}

#pragma mark - 数据绑定
-(void)bindDataToUI
{
    [self setupRating];
    
    str_groupID = [NSString stringWithFormat:@"%@",[dic_datas objectForKey:@"GroupId"]];
    
    lb_groupname.text = [NSString stringWithFormat:@"%@: %@",multiLanguage(@"Group name"),[dic_datas objectForKey:@"ScreenName"]];
    long time = [[dic_datas objectForKey:@"Time"] longValue];
    NSString *str_dateFormat = @"MM / dd / YYYY";
    if([commond isChinese])
        str_dateFormat = @"yyyy年MM月dd日";
    lb_time.text = [NSString stringWithFormat:@"%@ %@",[commond dateStringBySince1970:time dateFormat:str_dateFormat],[dic_datas objectForKey:@"ScreenTime"] ] ;
    lb_location.text = [NSString stringWithFormat:@"%@ : %@",multiLanguage(@"GroupLocation"),[dic_datas objectForKey:@"Location"]];
    tv_instruction.text = [dic_datas objectForKey:@"Introduction"];
}

-(void)bindDataToUI_Participant_Organizer
{
    
    NSMutableDictionary *_dic_groupParticipant = [self giveMeResponseContentByResponseName:@"GroupParticipant"];
    NSMutableDictionary *_dic_groupOrganizer = [self giveMeResponseContentByResponseName:@"GroupOrganizer"];
    NSMutableArray *_arr_participants = [_dic_groupParticipant objectForKey:@"Participants"];
    NSInteger totalSpots = [_arr_participants count];//现有人数
    NSInteger scale = [[_dic_groupParticipant objectForKey:@"Scale"] integerValue];//人数限制
    NSInteger showValue = scale - totalSpots;
    NSString *str_leftOrJoined = @"";
    if(scale == 0)
    {
        showValue = totalSpots;
        str_leftOrJoined = multiLanguage(@"Joined");
    }//如果认输限制是0 那么显示现有人数
    else
    {
        showValue = scale - totalSpots;
        str_leftOrJoined = multiLanguage(@"(Spots)Left");
    }
    
    for(NSMutableDictionary *_dic_singleinfo in _arr_participants)
    {
        NSString *_str_userid = [_dic_singleinfo objectForKey:@"UserId"];
        id _str_currentUserId = [commond getUserDefaults:KEY_API_USER_USERID];
        if(!_str_currentUserId)
            _str_currentUserId = @"";
        if([_str_userid isEqualToString:_str_currentUserId])
        {
            [self changeJoinButtonToLeave];
            break;
        }//如果我在组里
        
    }
    
    
    
    lb_participant.text = [NSString stringWithFormat:@"%ld %@",showValue,str_leftOrJoined];
    [self setupPariciapnts:_arr_participants];
    
    [iv_orgnizer sd_setImageWithURL:[NSURL URLWithString:[_dic_groupOrganizer objectForKey:@"UserIcon"]] placeholderImage:IMG_PLACEHOLDER];
    lb_orgnizerName.text = [NSString stringWithFormat:@"%@: %@",multiLanguage(@"Organizer"),[_dic_groupOrganizer objectForKey:@"UserName"]];
    
    [queueView_rating updateHighliteByCount:[[_dic_groupOrganizer objectForKey:@"Rating"] intValue]];
    
    
    self.btn_join.hidden = NO;
}

-(void)afterJoinGroup
{
    
    for(UIViewController *vc in nav_current.viewControllers)
    {
        if([vc isKindOfClass:[FGLocationFindAGroupViewController class]])
        {
            FGLocationFindAGroupViewController *vc_findAGrouop = (FGLocationFindAGroupViewController *)vc;
            [nav_current popToViewController:vc_findAGrouop animated:NO];
            [vc_findAGrouop performSelector:@selector(buttonAction_myGroup:) withObject:nil afterDelay:.1];
            return;
        }
    }//跳转到my group界面
    
    
}

#pragma mark - 按钮事件
-(IBAction)buttonAction_join:(id)_sender
{
    
    [commond alertWithButtons:@[multiLanguage(@"YES"),multiLanguage(@"NO")] title:multiLanguage(@"Join Group") message:multiLanguage(@"Are you sure you want to join the group?") callback:^(FGCustomAlertView *alertView, NSInteger buttonIndex) {
        if(buttonIndex == 0)
        {
            if([btn_join.titleLabel.text isEqualToString:multiLanguage(@"LEAVE")])
            {
                [self postRequest_leave];
            }
            else if([btn_join.titleLabel.text isEqualToString:multiLanguage(@"Join Group")])
            {
                [self postRequest_joinGroup];
            }
            
        }
    }];
}

-(void)gesture_clickPariciapnts:(id)_sender
{
    [commond presentGroupParticipantsViewFromController:self groupID:str_groupID];
}

#pragma mark - 解析json
-(id)giveMeResponseContentByResponseName:(NSString *)_str_responseName
{
    NSMutableDictionary *_dic_result = [[MemoryCache sharedMemoryCache] getDataByUrl:HOST(URL_LOCATION_GroupDetailPage)];
    NSMutableArray *_arr_datas = [_dic_result objectForKey:@"Responses"];
    for(NSMutableDictionary *_dic_data in _arr_datas)
    {
        NSString *str_responseName = [_dic_data objectForKey:@"ResponseName"];
        if([_str_responseName isEqualToString:str_responseName])
        {
            id _obj_responseContent = [_dic_data objectForKey:@"ResponseContent"];
            return _obj_responseContent;
        }
    }
    return nil;
}
@end
