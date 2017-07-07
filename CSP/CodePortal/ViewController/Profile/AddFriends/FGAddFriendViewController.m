//
//  FGAddFriendViewController.m
//  CSP
//
//  Created by JasonLu on 16/10/17.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//
#import "Global.h"
#import "FGAddFriendView.h"
#import "FGAddFriendViewController.h"
#import "YContactsManager.h"
#import "FGContactsViewController.h"
#import <MessageUI/MessageUI.h>
#import <Contacts/Contacts.h>
#define MESSAGE_TITLE @"专访张小龙：产品之上的世界观"
#define MESSAGE_CONTENT @"微信的平台化发展方向是否真的会让这个原本简洁的产品变得臃肿？在国际化发展方向上，微信面临的问题真的是文化差异壁垒吗？腾讯高级副总裁、微信产品负责人张小龙给出了自己的回复。"
#define MESSAGE_URL @"http://tech.qq.com/zt2012/tmtdecode/252.htm"

@interface FGAddFriendViewController () <FGAddFriendViewDelegate, FGContactsViewControllerDelegate>{
//  enum WXScene _scene;
}

@property (nonatomic, strong) FGAddFriendView *view_addFriend;
@property (nonatomic, copy)NSArray <YContactObject *> *  contactObjects;
@end

@implementation FGAddFriendViewController
@synthesize view_addFriend;
- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.
  self.view_topPanel.str_title = multiLanguage(@"ADD FRIENDS");

  [self internalInitalAddFriendView];
  [self hideBottomPanelWithAnimtaion:NO];
  
   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(action_pickupUser:) name:NOTIFICATION_UPDATECONTENT object:nil];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self setWhiteBGStyle];
}

- (void)manullyFixSize {
  [super manullyFixSize];
}

- (void)dealloc {
  self.view_addFriend = nil;
  self.contactObjects = nil;
  [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_UPDATECONTENT object:nil];
  NSLog(@":::::>dealloc %s %d", __FUNCTION__, __LINE__);
}

- (void)internalInitalAddFriendView {
  view_addFriend = (FGAddFriendView *)[[[NSBundle mainBundle] loadNibNamed:@"FGAddFriendView" owner:nil options:nil] objectAtIndex:0];
  [commond useDefaultRatioToScaleView:view_addFriend];
  CGRect frame         = self.view_topPanel.frame;
  view_addFriend.frame = CGRectMake(0, frame.size.height, view_addFriend.frame.size.width, view_addFriend.frame.size.height);
  [self.view addSubview:view_addFriend];
  view_addFriend.delegate = self;
  
  view_addFriend.view_searchBar.tf_search.delegate = self;
  [view_addFriend.view_searchBar.btn_right addTarget:self action:@selector(searchDidCancle) forControlEvents:UIControlEventTouchUpInside];
}

- (void)action_pickupUser:(id)obj {
  NSDictionary *_dic_userInfo = (NSDictionary *)[obj object];
  NSLog(@"obj==%@",_dic_userInfo);
  ;
  //进入用户中心
  FGControllerManager *manager = [FGControllerManager sharedManager];
  FGFriendProfileViewController *vc_friendProfile = [[FGFriendProfileViewController alloc] initWithNibName:@"FGFriendProfileViewController" bundle:nil withFriendId:_dic_userInfo[@"link"]];
  [manager pushController:vc_friendProfile navigationController:nav_current];
}

#pragma mark - 从父类继承的
- (void)buttonAction_left:(id)_sender {
  [super buttonAction_left:_sender];
}

- (void)buttonAction_right:(id)_sender {
}

- (void)receivedDataFromNetwork:(NSNotification *)_notification {
}

- (void)requestFailedFromNetwork:(NSNotification *)_notification {
}

#pragma mark - TextField Delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
//  [view_addFriend.view_searchBar setupSearchViewWithStatus:TF_EDITING withAnimation:YES];
  [commond presentUserPickViewFromController:self listType:ListType_User];
  return NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  [textField resignFirstResponder];
  [view_addFriend.view_searchBar.tf_search resignFirstResponder];
  return YES;
}

#pragma mark - FGAddFriendViewDelegate
-(void)didClickCellWithName:(NSString *)_name {
  if ([_name isEqualToString:@"Contacts"]) {
    
//    // 1.获取授权状态
    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
//
//    // 2.判断授权状态,如果不是已经授权,则直接返回
    if (status != CNAuthorizationStatusAuthorized) {
      [commond alert:multiLanguage(@"ALERT") message:multiLanguage(@"Please authorize permission in Setting") callback:^(FGCustomAlertView *alertView, NSInteger buttonIndex) {
        
      }];
      return;
    };
    
    
//    switch ([CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts])
//    {
//      //存在权限
//      case CNAuthorizationStatusAuthorized:
//      //获取通讯录
//      break;
//      
//      //权限未知
//      case CNAuthorizationStatusNotDetermined:
//      //请求权限
//      [self __requestAuthorizationStatus];break;
//      
//      //如果没有权限
//      case CNAuthorizationStatusRestricted:
//      case CNAuthorizationStatusDenied://需要提示
//      self.defendBlock();break;
//    }
    
    
    
    //打开联系人界面
    FGContactsViewController *vc_userpickup = [[FGContactsViewController alloc] initWithNibName:@"FGContactsViewController" bundle:nil];
    [commond useDefaultRatioToScaleView:vc_userpickup.view];
    STPopupController *vc_userPickPopup= [[STPopupController alloc] initWithRootViewController:vc_userpickup];
    vc_userpickup.delegate = self;
    vc_userpickup.contentSizeInPopup = vc_userpickup.view.frame.size;
    vc_userpickup.landscapeContentSizeInPopup = vc_userpickup.view.frame.size;
    
    [STPopupNavigationBar appearance].tintColor = color_red_panel;
    vc_userPickPopup.containerView.layer.cornerRadius = 4;
    [vc_userPickPopup presentInViewController:self];
    [vc_userpickup setupByListType:ListType_Contacts];
  }
  else if ([_name isEqualToString:@"Wechat"]) {
    //打开微信界面
    [self sendWechatLinkContent];
  }
  else if ([_name isEqualToString:@"Weibo"]) {
    [self sendWeiboLinkContent];
  }
  else if ([_name isEqualToString:@"QQ"]) {
    [self sendQQLinkContent];
  }
  else if ([_name isEqualToString:@"Facebook"]) {
    [self sendFBLinkContent];
  }
}

#pragma mark - FGContactsViewControllerDelegate
-(void)didClickContactWithPhones:(NSArray *)_arr_phones {
  [self showMessageView:_arr_phones title:MESSAGE_TITLE body:MESSAGE_CONTENT];
}

#pragma mark - 打开短信
-(void)showMessageView:(NSArray *)phones title:(NSString *)title body:(NSString *)body
{
  if( [MFMessageComposeViewController canSendText] )
  {
    MFMessageComposeViewController * controller = [[MFMessageComposeViewController alloc] init];
    controller.recipients = phones;
    controller.navigationBar.tintColor = [UIColor redColor];
    controller.body = body;
    controller.messageComposeDelegate = self;
    [self presentViewController:controller animated:YES completion:nil];
    [[[[controller viewControllers] lastObject] navigationItem] setTitle:title];//修改短信界面标题
  }
  else
  {
    [self showAlertWithContent:multiLanguage(@"The Device Not Support SMS")];
  }
}

-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
  [self dismissViewControllerAnimated:YES completion:nil];
  switch (result) {
    case MessageComposeResultSent:
      //信息传送成功
      
      break;
    case MessageComposeResultFailed:
      //信息传送失败
      
      break;
    case MessageComposeResultCancelled:
      //信息被用户取消传送
      
      break;
    default:
      break;
  }
}

#pragma mark - 打开微信
// FIXME: share
- (void) sendWechatLinkContent {
//  [[FGSNSManager shareInstance] shareToPlatformWithTitle:share_AddFriends_title text:share_AddFriends_content url:share_AddFriends_link images:@[] platformType:SSDKPlatformTypeWechat];
  
  [[FGSNSManager shareInstance] actionToShareAddFriendOnView:self.view platformType:SSDKPlatformTypeWechat];
}

#pragma mark - 打开QQ
- (void)sendQQLinkContent {
  //分享到qq空间
//  [[FGSNSManager shareInstance] shareToPlatformWithTitle:share_AddFriends_title text:share_AddFriends_content url:share_AddFriends_link images:@[] platformType:SSDKPlatformSubTypeQZone];
  
  [[FGSNSManager shareInstance] actionToShareAddFriendOnView:self.view platformType:SSDKPlatformTypeQQ];
}

#pragma mark - 打开Weibo
- (void)sendWeiboLinkContent {
//  [[FGSNSManager shareInstance] shareToPlatformWithTitle:share_AddFriends_title text:share_AddFriends_content url:share_AddFriends_link images:@[] platformType:SSDKPlatformTypeSinaWeibo];
  
  [[FGSNSManager shareInstance] actionToShareAddFriendOnView:self.view platformType:SSDKPlatformTypeSinaWeibo];
}

#pragma mark - 打开Facebook
- (void)sendFBLinkContent {
//  [[FGSNSManager shareInstance] shareToPlatformWithTitle:share_AddFriends_title text:share_AddFriends_content url:share_AddFriends_link images:@[] platformType:SSDKPlatformTypeFacebook];
  [[FGSNSManager shareInstance] actionToShareAddFriendOnView:self.view platformType:SSDKPlatformTypeFacebook];
}

#pragma mark - 其他事件
- (void)searchDidCancle {
  [view_addFriend.view_searchBar.tf_search resignFirstResponder];
  [view_addFriend.view_searchBar setupViewOriginStyleWithAnimation:YES];
}

- (void)showAlertWithContent:(NSString *)str_content {
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:multiLanguage(@"ALERT")
                                                  message:str_content
                                                 delegate:nil
                                        cancelButtonTitle:multiLanguage(@"OK")
                                        otherButtonTitles:nil, nil];
  [alert show];
}

@end
