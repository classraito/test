//
//  FGSNSManager.m
//  CSP
//
//  Created by JasonLu on 17/1/12.
//  Copyright © 2017年 Fugumobile. All rights reserved.
//

#import "FBApiWrapper.h"
#import "QQApiWrapper.h"
#import "WBApiWrapper.h"
#import "WXApiWrapper.h"
#import "FGSNSManager.h"
#import "FBActivity.h"
#import <Social/Social.h>
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareActionSheetCustomItem.h>

#define SNSIcon_wechatTimeLine IMGWITHNAME(@"sns_icon_wechatTimeline")
#define SNSIcon_wechatSession IMGWITHNAME(@"sns_icon_wechatSession")
#define SNSIcon_qqFriend IMGWITHNAME(@"sns_icon_qqFriend")
#define SNSIcon_qqZone IMGWITHNAME(@"sns_icon_qqZone")
#define SNSIcon_email IMGWITHNAME(@"sns_icon_email")
#define SNSIcon_facebook IMGWITHNAME(@"sns_icon_facebook")
#define SNSIcon_twitter IMGWITHNAME(@"sns_icon_twitter")
#define SNSIcon_weibo IMGWITHNAME(@"sns_icon_weibo")
#define SNSIcon_sms IMGWITHNAME(@"sns_icon_sms")
#define SNSIcon_copylink IMGWITHNAME(@"sns_icon_copy")


#define SNSType_wechatTimeLine multiLanguage(@"ShareType_wechatMoments")
#define SNSType_wechatSession multiLanguage(@"ShareType_wechatContacts")
#define SNSType_qqFriend multiLanguage(@"ShareType_qq")
#define SNSType_qqZone multiLanguage(@"ShareType_qzone")
#define SNSType_email multiLanguage(@"ShareType_mail")
#define SNSType_facebook multiLanguage(@"ShareType_facebook")
#define SNSType_twitter multiLanguage(@"ShareType_twitter")
#define SNSType_weibo multiLanguage(@"ShareType_weibo")
#define SNSType_sms multiLanguage(@"ShareType_sms")
#define SNSType_copylink multiLanguage(@"ShareType_copylink")



static id _instance = nil;

@interface FGSNSManager () {
  SLComposeViewController *slComposerSheet;
}

@end

@implementation FGSNSManager
#pragma mark - 单例方法
+ (FGSNSManager *)shareInstance {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    _instance = [[self alloc] init];
  });
  return _instance;
}

#pragma mark - 创建系统分享界面
- (void)actionToShareWithSystemActivityOnViewController:(UIViewController *)_vc shareTitle:(NSString *)_str_shareTitle shareContent:(NSString *)_str_shareContent shareImages:(NSArray *)_arr_shareImages shareUrl:(NSString *)_str_shareUrl{
  
//  NSMutableArray *activityItems = [NSMutableArray array];
//  //  对于多少图片分享
//  if (_arr_shareImages.count > 1) {
//    for (int i = 0; i < 8 && i<_arr_shareImages.count; i++) {
//      UIImage *imagerang = _arr_shareImages[i];
//      
//      NSString *path_sandox = NSHomeDirectory();
//      NSString *imagePath = [path_sandox stringByAppendingString:[NSString stringWithFormat:@"/Documents/ShareWX%d.jpg",i]];
//      [UIImagePNGRepresentation(imagerang) writeToFile:imagePath atomically:YES];
//      
//      NSURL *shareobj = [NSURL fileURLWithPath:imagePath];
//      
//      /** 这里做个解释 imagerang : UIimage 对象  shareobj:NSURL 对象 这个方法的实际作用就是 在调起微信的分享的时候 传递给他 UIimage对象,在分享的时候 实际传递的是 NSURL对象 达到我们分享九宫格的目的 */
//      SharedItem *item = [[SharedItem alloc] initWithData:imagerang andFile:shareobj andTitle:@"textToShare"];
//      [activityItems addObject:item];
//    }
//  }
//  else
//  {
    NSString *textToShare = [NSString stringWithFormat:@"%@", _str_shareContent];//@"请大家登录《iOS云端与网络通讯》服务网站。";
  NSURL *urlToShare = [NSURL URLWithString:_str_shareUrl];
  UIImage *imageToShare;
  NSArray *activityItems;
  if (_arr_shareImages.count > 0) {
    imageToShare = _arr_shareImages[0];//[UIImage imageNamed:@"featured-user1"];
    activityItems = @[textToShare, imageToShare, urlToShare];
  }
  else {
    activityItems = @[textToShare, urlToShare];
  }
    
    
//  }
  //分享内容
  //  NSString *contentToShare = [NSString stringWithFormat:@"%@", _str_shareContent];
  //  NSString *titleToShare   = [NSString stringWithFormat:@"%@", _str_shareTitle];
  //  UIImage *imageToShare = _arr_shareImages[0];
  //  NSURL *urlToShare = [NSURL URLWithString:_str_shareUrl];
//    NSArray *activityItems = @[textToShare, imageToShare, urlToShare];
  
  //设置分享的类型
//  WeixinSessionActivity *_activity_wxSession = [[WeixinSessionActivity alloc] init];
//  WeixinTimelineActivity *_activity_wxTimeline = [[WeixinTimelineActivity alloc] init];
//  QQActivity *_activity_qq = [[QQActivity alloc] init];
  
//  FBActivity *_activity_fb = [[FBActivity alloc] init];

//  _activity_fb._controller = _controller;
//  _activity_fb._arr_img = _arr_shareImages;
  
  //预处理分享数据
//  [_activity_wxSession prepareWithActivityItems:activityItems];
//  [_activity_wxTimeline prepareWithActivityItems:activityItems];
//  [_activity_qq prepareWithActivityItems:activityItems];
  
//  [_activity_fb prepareWithActivityItems:activityItems];
//  NSArray *applicationActivities = @[_activity_fb];
  
  
  // 创建分享视图控制器
  UIActivityViewController *activityVC = [[UIActivityViewController alloc]
                                          
                                          initWithActivityItems:activityItems
                                          
                                          applicationActivities:nil];
  
  // 设置不出现的分享按钮
  /*
   添加到此数组中的系统分享按钮项将不会出现在分享视图控制器中
   */
  activityVC.excludedActivityTypes = @[UIActivityTypeMessage,UIActivityTypePrint,UIActivityTypeCopyToPasteboard,UIActivityTypeAssignToContact,UIActivityTypeSaveToCameraRoll,UIActivityTypeAddToReadingList,UIActivityTypePostToFlickr,UIActivityTypePostToVimeo,UIActivityTypePostToTencentWeibo,UIActivityTypeAirDrop,UIActivityTypeOpenInIBooks];
  
  //  activityVC.excludedActivityTypes = @[
  //                                       UIActivityTypeMessage,
  //                                       UIActivityTypePostToFacebook,
  //                                       UIActivityTypePostToTwitter,
  //                                       UIActivityTypePostToWeibo,
  ////                                       UIActivityTypeMail,
  //                                       UIActivityTypePrint,
  //                                       UIActivityTypeCopyToPasteboard,
  //                                       UIActivityTypeAssignToContact,
  //                                       UIActivityTypeSaveToCameraRoll,
  //                                       UIActivityTypeAddToReadingList,
  //                                       UIActivityTypePostToFlickr,
  //                                       UIActivityTypePostToVimeo,
  //                                       UIActivityTypePostToTencentWeibo,
  //                                       UIActivityTypeAirDrop,
  //                                       UIActivityTypeOpenInIBooks
  //                                       ];
  
  // 写一个bolck，用于completionHandler的初始化
  UIActivityViewControllerCompletionWithItemsHandler myBlock = ^(NSString *activityType, BOOL completed, NSArray *returnedItems, NSError *activityError) {
    NSLog(@"activityType = %@ completed=%d returnedItems=%@ activityError = %@", activityType,completed,returnedItems,activityError);
    //这里不需要处理成功失败的逻辑 系统分享会自己处理
    [activityVC dismissViewControllerAnimated:YES completion:Nil];
    
  };
  // 初始化completionHandler，当post结束之后（无论是done还是cancell）该block都会被调用
  activityVC.completionWithItemsHandler = myBlock;
  
  [_vc presentViewController:activityVC animated:YES completion:nil];
}


#pragma mark - 创建分享界面
- (void)actionToShareWithTitle:(NSString *)_str_title text:(NSString *)_str_text url:(NSString *)_str_url images:(NSArray *)_arr_img {
  ////////////////////////////////////////////////////////////////////
  
  /*
  NSArray* imageArray = _arr_img;
  NSString *_str_newText = _str_text;
  if (imageArray) {
    
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    if (imageArray.count <= 0)
    {
      [shareParams SSDKSetupShareParamsByText:_str_text
                                       images:nil
                                          url:[NSURL URLWithString:_str_url]
                                        title:_str_title
                                         type:SSDKContentTypeWebPage];
      
      [shareParams SSDKSetupSinaWeiboShareParamsByText:[NSString stringWithFormat:@"%@ %@",_str_text, _str_url]
                                                 title:_str_title
                                                 image:nil
                                                   url:[NSURL URLWithString:_str_url]
                                              latitude:0
                                             longitude:0
                                              objectID:nil
                                                  type:SSDKContentTypeWebPage];
    }
    [shareParams SSDKEnableUseClientShare];
    //2、分享（可以弹出我们的分享菜单和编辑界面）
    [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
                             items:nil
                       shareParams:shareParams
               onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                 
                 switch (state) {
                   case SSDKResponseStateSuccess:
                   {
                     if (platformType == SSDKPlatformTypeInstagram) {
                       break;
                     }
                     UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                         message:nil
                                                                        delegate:nil
                                                               cancelButtonTitle:@"确定"
                                                               otherButtonTitles:nil];
                     [alertView show];
                     break;
                   }
                   case SSDKResponseStateFail:
                   {
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                     message:[NSString stringWithFormat:@"%@",error]
                                                                    delegate:nil
                                                           cancelButtonTitle:@"OK"
                                                           otherButtonTitles:nil, nil];
                     [alert show];
                     break;
                   }
                   case SSDKResponseStateCancel:
                   {
                     UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享已取消"
                                                                         message:nil
                                                                        delegate:nil
                                                               cancelButtonTitle:@"确定"
                                                               otherButtonTitles:nil];
                     [alertView show];
                     break;
                   }
                   default:
                     break;
                 }
               }
     ];}
   */
}

- (void)shareToPlatformWithTitle:(NSString *)_str_title text:(NSString *)_str_text url:(NSString *)_str_url images:(NSArray *)_arr_img platformType:(SSDKPlatformType)platformType {
  [self shareToPlatformWithTitle:_str_title text:_str_text url:_str_url images:_arr_img platformType:platformType contentType:SSDKContentTypeAuto];
}

- (void)shareToPlatformWithTitle:(NSString *)_str_title text:(NSString *)_str_text url:(NSString *)_str_url images:(NSArray *)_arr_img platformType:(SSDKPlatformType)platformType contentType:(SSDKContentType)contentType {
  //创建分享参数
  NSArray* imageArray = _arr_img;
  NSString *_str_newText = _str_text;
  if (platformType == SSDKPlatformTypeSinaWeibo)
    _str_newText =[NSString stringWithFormat:@"%@ %@",_str_text, _str_url];
  if (imageArray) {
     NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    if (imageArray.count <= 0) {
      [shareParams SSDKSetupShareParamsByText:_str_newText
                                       images:nil
                                          url:[NSURL URLWithString:_str_url]
                                        title:_str_title
                                         type:contentType];
    } else {
      [shareParams SSDKSetupShareParamsByText:_str_newText
                                       images:imageArray
                                          url:[NSURL URLWithString:_str_url]
                                        title:_str_title
                                         type:contentType];
    }
   
    
    [shareParams SSDKEnableUseClientShare];
    [ShareSDK share:platformType parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
      switch (state) {
          
        case SSDKResponseStateBegin:
        {
          break;
        }
        case SSDKResponseStateSuccess:
        {
          UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                              message:nil
                                                             delegate:nil
                                                    cancelButtonTitle:@"确定"
                                                    otherButtonTitles:nil];
          [alertView show];
          break;
        }
        case SSDKResponseStateFail:
        {
          UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                              message:[NSString stringWithFormat:@"%@", error]
                                                             delegate:nil
                                                    cancelButtonTitle:@"确定"
                                                    otherButtonTitles:nil];
          [alertView show];
          break;
        }
        case SSDKResponseStateCancel:
        {
          UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享已取消"
                                                              message:nil
                                                             delegate:nil
                                                    cancelButtonTitle:@"确定"
                                                    otherButtonTitles:nil];
          [alertView show];
          break;
        }
        default:
          break;
      }
    }];
  }
}

#pragma mark - 分享邀请码
- (void)actionToShareInviateCodeOnView:(UIView *)_view title:(NSString *)_str_title text:(NSString *)_str_text url:(NSString *)_str_url inviateCode:(NSString *)_str_inviateCode {
  if (_str_inviateCode == nil) {
    _str_inviateCode = @"L40F288444";
  }
  //#define share_inviationCode_content1 multiLanguage(@" I am giving you 50RMB off of your first personal training session with WEBOX. To enjoy it, please use my code")
  //#define share_inviationCode_content2 multiLanguage(@"Happy training!")
  
  
  if ([commond isChinese]) {
    _str_inviateCode = [NSString stringWithFormat:@"\"%@\"", _str_inviateCode];
  } else {
    _str_inviateCode = [NSString stringWithFormat:@"'%@'", _str_inviateCode];
  }
  
  //#define share_inviationCode_link @"http://weboxapp.com"
  //添加一个自定义的平台（非必要）
  NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
  [shareParams SSDKSetupShareParamsByText:
   [NSString stringWithFormat:@"%@ %@.%@%@",
    share_inviationCode_content1,
    _str_inviateCode,share_inviationCode_content2, share_inviationCode_link]
                                   images:nil
                                      url:[NSURL URLWithString:share_inviationCode_link]
                                    title:share_inviationCode_title
                                     type:SSDKContentTypeAuto];
  
  NSString *_str_shareContent = [NSString stringWithFormat:@"%@ %@.%@%@",
                                 share_inviationCode_content1,
                                 _str_inviateCode,share_inviationCode_content2, share_inviationCode_link];
  SSUIShareActionSheetCustomItem *item_wechatSession = [SSUIShareActionSheetCustomItem itemWithIcon:SNSIcon_wechatSession
                                                                                label:SNSType_wechatSession
                                                                              onClick:^{
                                                                                //wechat好友
                                                                                [[WXApiWrapper sharedManager] sendLinkContent:share_inviationCode_link tagName:@"" title:_str_shareContent thumbImage:IMGWITHNAME(@"logofang-60_3") description:[NSString stringWithFormat:@"%@%@",multiLanguage(@"code:"), _str_inviateCode] inScene:WXSceneSession];
                                                                              
                                                                                [commond trackShareContent:_str_shareContent shareTo:TRACK_WechatSession];
                                                                                
                                                                              }];
  SSUIShareActionSheetCustomItem *item_wechatTimeline = [SSUIShareActionSheetCustomItem itemWithIcon:SNSIcon_wechatTimeLine
                                                                                              label:SNSType_wechatTimeLine
                                                                                            onClick:^{
                                                                                              [[WXApiWrapper sharedManager] sendLinkContent:share_inviationCode_link tagName:@"" title:_str_shareContent thumbImage:IMGWITHNAME(@"logofang-60_3") description:[NSString stringWithFormat:@"%@%@",multiLanguage(@"code:"), _str_inviateCode] inScene:WXSceneTimeline];
                                                                                              
                                                                                              [commond trackShareContent:_str_shareContent shareTo:TRACK_WechatTimeline];
                                                                                            }];

  SSUIShareActionSheetCustomItem *item_weibo = [SSUIShareActionSheetCustomItem itemWithIcon:SNSIcon_weibo
                                                                                              label:SNSType_weibo
                                                                                            onClick:^{
                                                                                              //weibo
                                                                                              WBMessageObject *message = [WBMessageObject message];
                                                                                              message.text = _str_shareContent;
                                                                                              
                                                                                              WBImageObject *image = [WBImageObject object];
                                                                                              image.imageData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"logofang-60_3" ofType:@"png"]];
                                                                                              message.imageObject = image;
                                                                                              
                                                                                              [[WBApiWrapper sharedManager] shareToWeibo:message];
                                                                                              
                                                                                              [commond trackShareContent:_str_shareContent shareTo:TRACK_Weibo];
                                                                                            }];
  
  SSUIShareActionSheetCustomItem *item_qqPerson = [SSUIShareActionSheetCustomItem itemWithIcon:SNSIcon_qqFriend
                                                                                      label:SNSType_qqFriend
                                                                                    onClick:^{
                                                                                      [[QQApiWrapper shareInstance] qqSharesendTextMessageWithText:_str_shareContent toShareType:QQ_PERSON];
                                                                                      
                                                                                      [commond trackShareContent:_str_shareContent shareTo:TRACK_QQ];
                                                                                    }];

  SSUIShareActionSheetCustomItem *item_twitter = [SSUIShareActionSheetCustomItem itemWithIcon:SNSIcon_twitter
                                                                                       label:SNSType_twitter
                                                                                     onClick:^{
                                                                                       
                                                                                       slComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
                                                                                       
                                                                                       if ([self availableSharePlateformWith:SLServiceTypeTwitter] == NO) {
                                                                                         [commond alert:multiLanguage(@"Alert") message:@"Service unavailable" callback:^(FGCustomAlertView *alertView, NSInteger buttonIndex) {
                                                                                           ;
                                                                                         }];
                                                                                         return;
                                                                                       }
                                                                                       
                                                                                       
                                                                                       
                                                                                       [slComposerSheet setInitialText:_str_shareContent];
                                                                                       [slComposerSheet addImage:IMGWITHNAME(@"logofang-60_3")];
                                                                                       [slComposerSheet addURL:[NSURL URLWithString:share_inviationCode_link]];
                                                                                       [[_view viewController] presentViewController:slComposerSheet animated:YES completion:nil];
                                                                                       //}
                                                                                       [slComposerSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
                                                                                         NSLog(@"start completion block");
                                                                                         NSString *output;
                                                                                         switch (result) {
                                                                                           case SLComposeViewControllerResultCancelled:
                                                                                             output = @"Action Cancelled";
                                                                                             break;
                                                                                           case SLComposeViewControllerResultDone:
                                                                                             output = @"Post Successfull";
                                                                                             [commond trackShareContent:_str_shareContent shareTo:TRACK_TWITTER];
                                                                                             break;
                                                                                           default:
                                                                                             break;
                                                                                         }
                                                                                         if (result == SLComposeViewControllerResultCancelled)
                                                                                         {
                                                                                           
                                                                                         }
                                                                                       }];
                                                                                       
                                                                                     }];
  
  
  SSUIShareActionSheetCustomItem *item_copylink = [SSUIShareActionSheetCustomItem itemWithIcon:SNSIcon_copylink
                                                                                         label:SNSType_copylink
                                                                                       onClick:^{
                                                                                         
                                                                                           //  通用的粘贴板
                                                                                           UIPasteboard *pBoard = [UIPasteboard generalPasteboard];
                                                                                         pBoard.string = _str_shareContent;
                                                                                         
                                                                                         dispatch_async(dispatch_get_main_queue(), ^{
                                                                                           //显示提示信息
                                                                                           [commond showHUDAfterCopyToClipboardWithMessage:multiLanguage(@"Copied to clipboard")];
                                                                                         });
                                                                                         
                                                                                         
                                                                                       }];
  
  
  NSArray * platforms =@[item_wechatSession,item_wechatTimeline,item_weibo,item_qqPerson,@(SSDKPlatformSubTypeQZone),@(SSDKPlatformTypeFacebook),item_twitter, @(SSDKPlatformTypeMail),@(SSDKPlatformTypeSMS),item_copylink];
  [shareParams SSDKEnableUseClientShare];
  //再把声明的platforms对象传进分享方法里的items参数里
  SSUIShareActionSheetController *sheet = [ShareSDK showShareActionSheet:nil
                           items:platforms
                     shareParams:shareParams
             onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
               switch (state) {
                 case SSDKResponseStateSuccess:
                   NSLog(@"分享成功!");
                   if (platformType == SSDKPlatformTypeFacebook) {
                     [commond trackShareContent:_str_shareContent shareTo:TRACK_FACEBOOK];
                   } else if (platformType == SSDKPlatformTypeMail) {
                      [commond trackShareContent:_str_shareContent shareTo:TRACK_EMAIL];
                   } else if (platformType == SSDKPlatformSubTypeQZone) {
                     [commond trackShareContent:_str_shareContent shareTo:TRACK_QZONE];
                   }
                   break;
                 case SSDKResponseStateFail:
                   NSLog(@"分享失败%@",error);
                   break;
                 case SSDKResponseStateCancel:
                   NSLog(@"分享已取消");
                   break;
                 default:
                   break;
               }
             }];
  [sheet.directSharePlatforms addObject:@(SSDKPlatformTypeFacebook)];//（加了这个方法之后可以不跳分享编辑界面，直接点击分享菜单里的选项，直接分享）
  [sheet.directSharePlatforms addObject:@(SSDKPlatformTypeMail)];//（加了这个方法之后可以不跳分享编辑界面，直接点击分享菜单里的选项，直接分享）
  [sheet.directSharePlatforms addObject:@(SSDKPlatformTypeSMS)];
}

#pragma mark - 分享添加好友
- (void)actionToShareAddFriendOnView:(UIView *)_view platformType:(SSDKPlatformType)platformType {
  
  if (platformType == SSDKPlatformTypeWechat) {
    //wechat好友
    [[WXApiWrapper sharedManager] sendLinkContent:share_AddFriends_link tagName:@"" title:@"" thumbImage:IMGWITHNAME(@"logofang-60_3") description:[NSString stringWithFormat:@"%@;%@",share_AddFriends_content1,share_AddFriends_content2] inScene:WXSceneSession];
    [commond trackShareContent:[NSString stringWithFormat:@"%@ %@",[NSString stringWithFormat:@"%@;%@;",share_AddFriends_content1,share_AddFriends_content1], share_AddFriends_link] shareTo:TRACK_WechatSession];
  } else if (platformType == SSDKPlatformTypeSinaWeibo) {
    //weibo
    WBMessageObject *message = [WBMessageObject message];
    message.text = [NSString stringWithFormat:@"%@ %@",[NSString stringWithFormat:@"%@;%@;",share_AddFriends_content1,share_AddFriends_content1], share_AddFriends_link];
    
    WBImageObject *image = [WBImageObject object];
    image.imageData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"logofang-60_3" ofType:@"png"]];
    message.imageObject = image;
    
    [[WBApiWrapper sharedManager] shareToWeibo:message];
    
    [commond trackShareContent:[NSString stringWithFormat:@"%@ %@",[NSString stringWithFormat:@"%@;%@;",share_AddFriends_content1,share_AddFriends_content1], share_AddFriends_link] shareTo:TRACK_Weibo];

  } else if (platformType == SSDKPlatformTypeQQ) {
    [[QQApiWrapper shareInstance] qqSharesendTextMessageWithText:[NSString stringWithFormat:@"%@;%@;%@",share_AddFriends_content1,share_AddFriends_content2,share_AddFriends_link] toShareType:QQ_PERSON];
    
    [commond trackShareContent:[NSString stringWithFormat:@"%@ %@",[NSString stringWithFormat:@"%@;%@;",share_AddFriends_content1,share_AddFriends_content1], share_AddFriends_link] shareTo:TRACK_QQ];
    
  } else if (platformType == SSDKPlatformTypeFacebook) {
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:
     [NSString stringWithFormat:@"%@;%@",
      share_AddFriends_content1,
      share_AddFriends_content2]
                                     images:nil
                                        url:[NSURL URLWithString:share_AddFriends_link]
                                      title:[NSString stringWithFormat:@"%@",
                                             share_AddFriends_title]
                                       type:SSDKContentTypeAuto];
    [shareParams SSDKEnableUseClientShare];
    //进行分享
    [ShareSDK share:SSDKPlatformTypeFacebook //传入分享的平台类型
         parameters:shareParams
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) { // 回调处理....}];
     }];
    
    [commond trackShareContent:[NSString stringWithFormat:@"%@ %@",[NSString stringWithFormat:@"%@;%@;",share_AddFriends_content1,share_AddFriends_content1], share_AddFriends_link] shareTo:TRACK_FACEBOOK];
  }
}

#pragma mark - 分享post内容
- (void)actionToSharePostOnView:(UIView *)_view title:(NSString *)_str_title text:(NSString *)_str_text url:(NSString *)_str_url image:(id)_img link:(NSString *)_str_Link{
  //添加一个自定义的平台（非必要）
  NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
  UIImage *_img_thumbnail;
  NSData *_data_toWeibo;
  BOOL _bool_hasVideoUrl = NO;
  
  NSString *_str_shareContent;
  if (_img) {
    //分享图片
    NSString *_str_imageThumbnailsUrl = ((NSArray *)_img)[0];
    _data_toWeibo = [NSData dataWithContentsOfURL:[NSURL URLWithString:_str_imageThumbnailsUrl]];
    _img_thumbnail = [UIImage imageWithData:_data_toWeibo];
    
    //分享链接
    [shareParams SSDKSetupShareParamsByText:
     [NSString stringWithFormat:@"%@;%@;%@",
      share_post_content1,
      share_post_content2,
      share_post_link]
                                     images:_img_thumbnail == nil?nil:@[_img_thumbnail]
                                        url:[NSURL URLWithString:_str_Link]
                                      title:@""
                                       type:SSDKContentTypeAuto];
    
    _str_shareContent = [NSString stringWithFormat:@"%@;%@;%@",
                         share_post_content1,
                         share_post_content2,
                         ISNULLObj(_str_Link)?@"":_str_Link];
  } else {
    //[[FGSNSManager shareInstance] actionToSharePostOnView:self title:@"" text:dic_dataInfo[@"Content"] url:@"" image:nil link:_str_video];
    _img_thumbnail = IMGWITHNAME(@"logofang-60_3");
    _data_toWeibo = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"logofang-60_3" ofType:@"png"]];
    _bool_hasVideoUrl = YES;
    
    //分享链接
    [shareParams SSDKSetupShareParamsByText:
     [NSString stringWithFormat:@"%@;%@;%@",
      share_post_content1,
      share_post_content2,
      _str_Link]
                                     images:nil
                                        url:[NSURL URLWithString:_str_Link]
                                      title:@""
                                       type:SSDKContentTypeAuto];
    
    _str_shareContent = [NSString stringWithFormat:@"%@;%@;%@",
                         share_post_content1,
                         share_post_content2,
                         ISNULLObj(_str_Link)?@"":_str_Link];

  }
  
  
  SSUIShareActionSheetCustomItem *item_wechatSession = [SSUIShareActionSheetCustomItem itemWithIcon:SNSIcon_wechatSession
                                                                                              label:SNSType_wechatSession
                                                                                            onClick:^{
                                                                                              //wechat好友
                                                                                              [[WXApiWrapper sharedManager] sendLinkContent:_str_Link tagName:@"" title:[NSString stringWithFormat:@"%@;%@;%@",share_post_content1,share_post_content2,share_post_link] thumbImage:_img_thumbnail description:_str_text inScene:WXSceneSession];
                                                                                            
                                                                                              [commond trackShareContent:[NSString stringWithFormat:@"%@;%@;%@;%@",share_post_content1,share_post_content2,share_post_link,_str_text] shareTo:TRACK_WechatSession];
                                                                                                                                                                                  }];
  SSUIShareActionSheetCustomItem *item_wechatTimeline = [SSUIShareActionSheetCustomItem itemWithIcon:SNSIcon_wechatTimeLine
                                                                                               label:SNSType_wechatTimeLine
                                                                                             onClick:^{
                                                                                               [[WXApiWrapper sharedManager] sendLinkContent:_str_Link tagName:@"" title:[NSString stringWithFormat:@"%@;%@;%@",share_post_content1,share_post_content2,share_post_link] thumbImage:_img_thumbnail description:_str_text inScene:WXSceneTimeline];
                                                                                               
                                                                                             [commond trackShareContent:[NSString stringWithFormat:@"%@;%@;%@;%@",share_post_content1,share_post_content2,share_post_link,_str_text] shareTo:TRACK_WechatTimeline];
                                                                                             
                                                                                             }];
  
  SSUIShareActionSheetCustomItem *item_weibo = [SSUIShareActionSheetCustomItem itemWithIcon:SNSIcon_weibo
                                                                                      label:SNSType_weibo
                                                                                    onClick:^{
                                                                                      //weibo
                                                                                      if (_bool_hasVideoUrl) {
                                                                                        WBMessageObject *message = [WBMessageObject message];
                                                                                        message.text = [NSString stringWithFormat:@"%@;%@;%@;%@",share_post_content1,share_post_content2,_str_Link,share_post_link];
                                                                                        
                                                                                        WBImageObject *image = [WBImageObject object];
                                                                                        image.imageData = _data_toWeibo;
                                                                                        message.imageObject = image;
                                                                                        
                                                                                        [[WBApiWrapper sharedManager] shareToWeibo:message];
                                                                                        
                                                                                        [commond trackShareContent:message.text shareTo:TRACK_Weibo];
                                                                                      }
                                                                                      else {
                                                                                        WBMessageObject *message = [WBMessageObject message];
                                                                                        message.text = [NSString stringWithFormat:@"%@;%@;%@",share_post_content1,share_post_content2,share_post_link];
                                                                                        
                                                                                        WBImageObject *image = [WBImageObject object];
                                                                                        image.imageData = _data_toWeibo;
                                                                                        message.imageObject = image;
                                                                                        
                                                                                        [[WBApiWrapper sharedManager] shareToWeibo:message];
                                                                                        
                                                                                        [commond trackShareContent:message.text shareTo:TRACK_Weibo];
                                                                                      }
                                                                                      
                                                                                      
                                                                                      
                                                                                    }];
  
  SSUIShareActionSheetCustomItem *item_qqPerson = [SSUIShareActionSheetCustomItem itemWithIcon:SNSIcon_qqFriend
                                                                                         label:SNSType_qqFriend
                                                                                       onClick:^{
                                                                                         if (_bool_hasVideoUrl) {
                                                                                           //分享链接
                                                                                           [shareParams SSDKSetupShareParamsByText:
                                                                                            _str_text
                                                                                                                            images:@[_img_thumbnail]
                                                                                                                               url:[NSURL URLWithString:_str_Link]
                                                                                                                             title:[NSString stringWithFormat:@"%@;%@;%@",                                                                   share_post_content1,                                                                     share_post_content2,
                                                                                                                                    share_post_link]
                                                                                                                              type:SSDKContentTypeAuto];
                                                                                           
                                                                                           
                                                                                           [shareParams SSDKEnableUseClientShare];
                                                                                           //进行分享
                                                                                           [ShareSDK share:SSDKPlatformSubTypeQQFriend //传入分享的平台类型
                                                                                                parameters:shareParams
                                                                                            onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) { // 回调处理....}];
                                                                                            }];
                                                                                           
                                                                                           
                                                                                           [commond trackShareContent:[NSString stringWithFormat:@"%@;%@;%@;%@",                                                                   share_post_content1,                                                                     share_post_content2,              share_post_link,_str_Link] shareTo:TRACK_QQ];
                                                                                           
                                                                                         } else {
                                                                                           //分享链接
                                                                                           [shareParams SSDKSetupShareParamsByText:
                                                                                            _str_text
                                                                                                                            images:@[_img_thumbnail]
                                                                                                                               url:[NSURL URLWithString:_str_Link]
                                                                                                                             title:[NSString stringWithFormat:@"%@;%@;%@",                                                                   share_post_content1,                                                                     share_post_content2,
                                                                                                                                    share_post_link]
                                                                                                                              type:SSDKContentTypeAuto];
                                                                                           
                                                                                           
                                                                                           [shareParams SSDKEnableUseClientShare];
                                                                                           //进行分享
                                                                                           [ShareSDK share:SSDKPlatformSubTypeQQFriend //传入分享的平台类型
                                                                                                parameters:shareParams
                                                                                            onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) { // 回调处理....}];
                                                                                            }];
                                                                                           
                                                                                           [commond trackShareContent:[NSString stringWithFormat:@"%@;%@;%@;%@",                                                                   share_post_content1,                                                                     share_post_content2,              share_post_link,_str_Link] shareTo:TRACK_QQ];
                                                                                         }
                                                                                       }];
  
  SSUIShareActionSheetCustomItem *item_qqZone = [SSUIShareActionSheetCustomItem itemWithIcon:SNSIcon_qqZone
                                                                                       label:SNSType_qqZone
                                                                                     onClick:^{
                                                                                       if (_bool_hasVideoUrl) {
                                                                                         //分享链接
                                                                                         [shareParams SSDKSetupShareParamsByText:
                                                                                          _str_text
                                                                                                                          images:@[_img_thumbnail]
                                                                                                                             url:[NSURL URLWithString:_str_Link]
                                                                                                                           title:[NSString stringWithFormat:@"%@;%@;%@",                                                                   share_post_content1,                                                                     share_post_content2,
                                                                                                                                  share_post_link]
                                                                                                                            type:SSDKContentTypeAuto];
                                                                                         
                                                                                         
                                                                                         [shareParams SSDKEnableUseClientShare];
                                                                                         //进行分享
                                                                                         [ShareSDK share:SSDKPlatformSubTypeQZone //传入分享的平台类型
                                                                                              parameters:shareParams
                                                                                          onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) { // 回调处理....}];
                                                                                          }];
                                                                                         
                                                                                         [commond trackShareContent:[NSString stringWithFormat:@"%@;%@;%@;%@",                                                                   share_post_content1,                                                                     share_post_content2,              share_post_link,_str_Link] shareTo:TRACK_QZONE];
                                                                                         
                                                                                       } else {
                                                                                         //分享链接
                                                                                         [shareParams SSDKSetupShareParamsByText:
                                                                                          _str_text
                                                                                                                          images:@[_img_thumbnail]
                                                                                                                             url:[NSURL URLWithString:_str_Link]
                                                                                                                           title:[NSString stringWithFormat:@"%@;%@;%@",                                                                   share_post_content1,                                                                     share_post_content2,
                                                                                                                                  share_post_link]
                                                                                                                            type:SSDKContentTypeAuto];
                                                                                         
                                                                                         
                                                                                         [shareParams SSDKEnableUseClientShare];
                                                                                         //进行分享
                                                                                         [ShareSDK share:SSDKPlatformSubTypeQZone //传入分享的平台类型
                                                                                              parameters:shareParams
                                                                                          onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) { // 回调处理....}];
                                                                                          }];
                                                                                         
                                                                                         [commond trackShareContent:[NSString stringWithFormat:@"%@;%@;%@;%@",                                                                   share_post_content1,                                                                     share_post_content2,              share_post_link,_str_Link] shareTo:TRACK_QZONE];
                                                                                       }
                                                                                     }];
  
  SSUIShareActionSheetCustomItem *item_twitter = [SSUIShareActionSheetCustomItem itemWithIcon:SNSIcon_twitter
                                                                                        label:SNSType_twitter
                                                                                      onClick:^{
                                                                                        
                                                                                        slComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
                                                                                        
                                                                                        if ([self availableSharePlateformWith:SLServiceTypeTwitter] == NO) {
                                                                                          [commond alert:multiLanguage(@"Alert") message:@"Service unavailable" callback:^(FGCustomAlertView *alertView, NSInteger buttonIndex) {
                                                                                            ;
                                                                                          }];
                                                                                          return;
                                                                                        }
                                                                                        
                                                                                        
                                                                                        
                                                                                        [slComposerSheet setInitialText:[NSString stringWithFormat:@"%@;%@;%@",share_post_content1,share_post_content2,share_post_link]];
                                                                                        [slComposerSheet addImage:_img_thumbnail];
                                                                                        if (_bool_hasVideoUrl)
                                                                                          [slComposerSheet addURL:[NSURL URLWithString:_str_Link]];
                                                                                        else
                                                                                          [slComposerSheet addURL:[NSURL URLWithString:share_post_link]];
                                                                                        [[_view viewController] presentViewController:slComposerSheet animated:YES completion:nil];
                                                                                        //}
                                                                                        [slComposerSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
                                                                                          NSLog(@"start completion block");
                                                                                          NSString *output;
                                                                                          switch (result) {
                                                                                            case SLComposeViewControllerResultCancelled:
                                                                                              output = @"Action Cancelled";
                                                                                              break;
                                                                                            case SLComposeViewControllerResultDone:
                                                                                              output = @"Post Successfull";
                                                                                              [commond trackShareContent:[NSString stringWithFormat:@"%@;%@;%@;%@",                                                                   share_post_content1,                                                                     share_post_content2,              share_post_link,_str_Link] shareTo:TRACK_TWITTER];
                                                                                              break;
                                                                                            default:
                                                                                              break;
                                                                                          }
                                                                                          if (result == SLComposeViewControllerResultCancelled)
                                                                                          {
                                                                                            
                                                                                          }
                                                                                        }];
                                                                                        
                                                                                      }];
  
  
  
  NSArray * platforms =@[item_wechatSession,item_wechatTimeline,item_weibo,item_qqPerson,item_qqZone,@(SSDKPlatformTypeFacebook),item_twitter, @(SSDKPlatformTypeMail)];
  [shareParams SSDKEnableUseClientShare];
  //再把声明的platforms对象传进分享方法里的items参数里
  SSUIShareActionSheetController *sheet = [ShareSDK showShareActionSheet:nil
                                                                   items:platforms
                                                             shareParams:shareParams
                                                     onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                                                       switch (state) {
                                                         case SSDKResponseStateSuccess:
                                                           NSLog(@"分享成功!");
                                                           if (platformType == SSDKPlatformTypeFacebook) {
                                                             [commond trackShareContent:_str_shareContent shareTo:TRACK_FACEBOOK];
                                                           } else if (platformType == SSDKPlatformTypeMail) {
                                                             [commond trackShareContent:_str_shareContent shareTo:TRACK_EMAIL];
                                                           }
                                                           break;
                                                         case SSDKResponseStateFail:
                                                           NSLog(@"分享失败%@",error);
                                                           break;
                                                         case SSDKResponseStateCancel:
                                                           NSLog(@"分享已取消");
                                                           break;
                                                         default:
                                                           break;
                                                       }
                                                     }];
  [sheet.directSharePlatforms addObject:@(SSDKPlatformTypeFacebook)];//（加了这个方法之后可以不跳分享编辑界面，直接点击分享菜单里的选项，直接分享）
  [sheet.directSharePlatforms addObject:@(SSDKPlatformTypeMail)];//（加了这个方法之后可以不跳分享编辑界面，直接点击分享菜单里的选项，直接分享）
}
#pragma mark - 分享训练内容
- (void)actionToShareTrainingOnView:(UIView *)_view title:(NSString *)_str_title text:(NSString *)_str_text url:(NSString *)_str_url{
  
  //添加一个自定义的平台（非必要）
  NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
  [shareParams SSDKSetupShareParamsByText:
   _str_text
                                   images:nil
                                      url:[NSURL URLWithString:_str_url]
                                    title:@""
                                     type:SSDKContentTypeAuto];
  
  NSString *_str_shareContent = [NSString stringWithFormat:@"%@;%@", _str_text, _str_url];
  SSUIShareActionSheetCustomItem *item_wechatSession = [SSUIShareActionSheetCustomItem itemWithIcon:SNSIcon_wechatSession
                                                                                              label:SNSType_wechatSession
                                                                                            onClick:^{
                                                                                              //wechat好友
                                                                                              [[WXApiWrapper sharedManager] sendLinkContent:_str_url tagName:@"" title:_str_text thumbImage:IMGWITHNAME(@"logofang-60_3") description:_str_text inScene:WXSceneSession];
                                                                                            
                                                                                             [commond trackShareContent:[NSString stringWithFormat:@"%@;%@",_str_text,_str_url] shareTo:TRACK_WechatSession];
                                                                                            
                                                                                            }];
  SSUIShareActionSheetCustomItem *item_wechatTimeline = [SSUIShareActionSheetCustomItem itemWithIcon:SNSIcon_wechatTimeLine
                                                                                               label:SNSType_wechatTimeLine
                                                                                             onClick:^{
                                                                                               [[WXApiWrapper sharedManager] sendLinkContent:share_inviationCode_link tagName:@"" title:_str_text thumbImage:IMGWITHNAME(@"logofang-60_3") description:_str_text inScene:WXSceneTimeline];
                                                                                               
                                                                                                [commond trackShareContent:[NSString stringWithFormat:@"%@;%@",_str_text,_str_url] shareTo:TRACK_WechatTimeline];
                                                                                             }];
  
  SSUIShareActionSheetCustomItem *item_weibo = [SSUIShareActionSheetCustomItem itemWithIcon:SNSIcon_weibo
                                                                                      label:SNSType_weibo
                                                                                    onClick:^{
                                                                                      //weibo
                                                                                      WBMessageObject *message = [WBMessageObject message];
                                                                                      message.text = _str_text;
                                                                                      
                                                                                      WBImageObject *image = [WBImageObject object];
                                                                                      image.imageData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"logofang-60_3" ofType:@"png"]];
                                                                                      message.imageObject = image;
                                                                                      
                                                                                      [[WBApiWrapper sharedManager] shareToWeibo:message];
                                                                                      
                                                                                      [commond trackShareContent:[NSString stringWithFormat:@"%@",_str_text] shareTo:TRACK_Weibo];
                                                                                      
                                                                                    }];
  
  SSUIShareActionSheetCustomItem *item_qqPerson = [SSUIShareActionSheetCustomItem itemWithIcon:SNSIcon_qqFriend
                                                                                         label:SNSType_qqFriend
                                                                                       onClick:^{
                                                                                         [[QQApiWrapper shareInstance] qqSharesendTextMessageWithText:_str_text toShareType:QQ_PERSON];
                                                                                         
                                                                                          [commond trackShareContent:[NSString stringWithFormat:@"%@",_str_text] shareTo:TRACK_QQ];
                                                                                       }];
  SSUIShareActionSheetCustomItem *item_qqZone = [SSUIShareActionSheetCustomItem itemWithIcon:SNSIcon_qqZone
                                                                                       label:SNSType_qqZone
                                                                                     onClick:^{
                                                                                       [[QQApiWrapper shareInstance] qqSharesendTextMessageWithText:_str_text toShareType:QQ_ZONE];
                                                                                     }];
  
  SSUIShareActionSheetCustomItem *item_twitter = [SSUIShareActionSheetCustomItem itemWithIcon:SNSIcon_twitter
                                                                                        label:SNSType_twitter
                                                                                      onClick:^{
                                                                                        
                                                                                        slComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
                                                                                        
                                                                                        if ([self availableSharePlateformWith:SLServiceTypeTwitter] == NO) {
                                                                                          [commond alert:multiLanguage(@"Alert") message:@"Service unavailable" callback:^(FGCustomAlertView *alertView, NSInteger buttonIndex) {
                                                                                            ;
                                                                                          }];
                                                                                          return;
                                                                                        }
                                                                                        
                                                                                        [slComposerSheet setInitialText:_str_text];
                                                                                        [slComposerSheet addImage:IMGWITHNAME(@"logofang-60_3")];
                                                                                        [slComposerSheet addURL:[NSURL URLWithString:_str_url]];
                                                                                        [[_view viewController] presentViewController:slComposerSheet animated:YES completion:nil];
                                                                                        //}
                                                                                        [slComposerSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
                                                                                          NSLog(@"start completion block");
                                                                                          NSString *output;
                                                                                          switch (result) {
                                                                                            case SLComposeViewControllerResultCancelled:
                                                                                              output = @"Action Cancelled";
                                                                                              break;
                                                                                            case SLComposeViewControllerResultDone:
                                                                                              output = @"Post Successfull";
                                                                                              [commond trackShareContent:[NSString stringWithFormat:@"%@;%@",_str_text,_str_url] shareTo:TRACK_TWITTER];
                                                                                              break;
                                                                                            default:
                                                                                              break;
                                                                                          }
                                                                                          if (result == SLComposeViewControllerResultCancelled)
                                                                                          {
                                                                                            
                                                                                          }
                                                                                        }];
                                                                                        
                                                                                      }];
  
  
  
  NSArray * platforms =@[item_wechatSession,item_wechatTimeline,item_weibo,item_qqPerson,@(SSDKPlatformSubTypeQZone),@(SSDKPlatformTypeFacebook),item_twitter, @(SSDKPlatformTypeMail)];
  [shareParams SSDKEnableUseClientShare];
  //再把声明的platforms对象传进分享方法里的items参数里
  SSUIShareActionSheetController *sheet = [ShareSDK showShareActionSheet:nil
                                                                   items:platforms
                                                             shareParams:shareParams
                                                     onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                                                       switch (state) {
                                                         case SSDKResponseStateSuccess:
                                                           NSLog(@"分享成功!");
                                                           if (platformType == SSDKPlatformTypeFacebook) {
                                                             [commond trackShareContent:_str_shareContent shareTo:TRACK_FACEBOOK];
                                                           } else if (platformType == SSDKPlatformTypeMail) {
                                                             [commond trackShareContent:_str_shareContent shareTo:TRACK_EMAIL];
                                                           } else if (platformType == SSDKPlatformSubTypeQZone) {
                                                             [commond trackShareContent:_str_shareContent shareTo:TRACK_QZONE];
                                                           }
                                                           break;
                                                         case SSDKResponseStateFail:
                                                           NSLog(@"分享失败%@",error);
                                                           break;
                                                         case SSDKResponseStateCancel:
                                                           NSLog(@"分享已取消");
                                                           break;
                                                         default:
                                                           break;
                                                       }
                                                     }];
  [sheet.directSharePlatforms addObject:@(SSDKPlatformTypeFacebook)];//（加了这个方法之后可以不跳分享编辑界面，直接点击分享菜单里的选项，直接分享）
  [sheet.directSharePlatforms addObject:@(SSDKPlatformTypeMail)];//（加了这个方法之后可以不跳分享编辑界面，直接点击分享菜单里的选项，直接分享）
  
}

#pragma mark - 分享edit post内容
- (void) actionToShareEditPostWithImages:(NSArray *)_arr_img text:(NSString *)_str_text onViewController:(UIViewController *)_vc{
  NSArray *activityItems = _arr_img;//@[imageToShare,imageToShare1, imageToShare2];
  UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
  
  // 设置不出现的分享按钮
  /*
   添加到此数组中的系统分享按钮项将不会出现在分享视图控制器中
   */
  activityVC.excludedActivityTypes = @[UIActivityTypeMessage,UIActivityTypePrint,UIActivityTypeCopyToPasteboard,UIActivityTypeAssignToContact,UIActivityTypeSaveToCameraRoll,UIActivityTypeAddToReadingList,UIActivityTypePostToFlickr,UIActivityTypePostToVimeo,UIActivityTypePostToTencentWeibo,UIActivityTypeAirDrop,UIActivityTypeOpenInIBooks];
  
  // 写一个bolck，用于completionHandler的初始化
  UIActivityViewControllerCompletionWithItemsHandler myBlock = ^(NSString *activityType, BOOL completed, NSArray *returnedItems, NSError *activityError) {
    NSLog(@"activityType = %@ completed=%d returnedItems=%@ activityError = %@", activityType,completed,returnedItems,activityError);
    if (completed == YES) {
      NSString *_str_shareContent = [NSString stringWithFormat:@"%@;%@;%@;%@",
                           share_post_content1,share_post_content2,
                           share_post_link,
                                     _str_text];
      if ([activityType isEqualToString:@"com.tencent.xin.sharetimeline"]) {
        [commond trackShareContent:_str_shareContent shareTo:TRACK_WechatSession];
      } else if ([activityType isEqualToString:@"com.apple.UIKit.activity.PostToWeibo"]) {
        [commond trackShareContent:_str_shareContent shareTo:TRACK_Weibo];
      } else if ([activityType isEqualToString:@"com.tencent.mqq.ShareExtension"]) {
        [commond trackShareContent:_str_shareContent shareTo:TRACK_QQ];
      } else if ([activityType isEqualToString:@"com.apple.UIKit.activity.PostToFacebook"]) {        [commond trackShareContent:_str_shareContent shareTo:TRACK_FACEBOOK];
      } else if ([activityType isEqualToString:@"com.apple.UIKit.activity.PostToTwitter"]) {        [commond trackShareContent:_str_shareContent shareTo:TRACK_TWITTER];
      } else if ([activityType isEqualToString:@"com.apple.UIKit.activity.Mail"]) {
        [commond trackShareContent:_str_shareContent shareTo:TRACK_EMAIL];
      }
    }
    //com.tencent.xin.sharetimeline
    //com.tencent.xin.sharetimeline
    
    //com.tencent.mqq.ShareExtension
    //com.tencent.mqq.ShareExtension
    
    //com.apple.UIKit.activity.PostToWeibo
    //com.apple.UIKit.activity.PostToFacebook
    
    //com.apple.UIKit.activity.PostToTwitter
    
    //com.apple.UIKit.activity.Mail
    
    
    //这里不需要处理成功失败的逻辑 系统分享会自己处理
    [activityVC dismissViewControllerAnimated:YES completion:Nil];
    
  };
  // 初始化completionHandler，当post结束之后（无论是done还是cancell）该block都会被调用
  activityVC.completionWithItemsHandler = myBlock;
  
  [_vc presentViewController:activityVC animated:YES completion:nil];
}

- (void)actionToShareEditPostOnView:(UIView *)_view title:(NSString *)_str_title text:(NSString *)_str_text link:(NSString *)_str_Link{
  //添加一个自定义的平台（非必要）
  NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
  UIImage *_img_thumbnail;
  NSData *_data_toWeibo;
  BOOL _bool_hasVideoUrl = NO;
  
  NSString *_str_shareContent;
  
  //[[FGSNSManager shareInstance] actionToSharePostOnView:self title:@"" text:dic_dataInfo[@"Content"] url:@"" image:nil link:_str_video];
  _img_thumbnail = IMGWITHNAME(@"logofang-60_3");
  _data_toWeibo = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"logofang-60_3" ofType:@"png"]];
  _bool_hasVideoUrl = YES;
  
  //分享链接
  [shareParams SSDKSetupShareParamsByText:
   [NSString stringWithFormat:@"%@;%@",
    _str_text,
    _str_Link]
                                   images:nil
                                      url:[NSURL URLWithString:_str_Link]
                                    title:@""
                                     type:SSDKContentTypeAuto];
  
  _str_shareContent = [NSString stringWithFormat:@"%@;%@;%@;%@;%@",
                       share_post_content1,share_post_content2,
                      share_post_link,
                       _str_text,
                       ISNULLObj(_str_Link)?@"":_str_Link];
  
  
  
  SSUIShareActionSheetCustomItem *item_wechatSession = [SSUIShareActionSheetCustomItem itemWithIcon:SNSIcon_wechatSession
                                                                                              label:SNSType_wechatSession
                                                                                            onClick:^{
                                                                                              //wechat好友
                                                                                              [[WXApiWrapper sharedManager] sendLinkContent:_str_Link tagName:@"" title:[NSString stringWithFormat:@"%@;%@;%@",share_post_content1,share_post_content2,share_post_link] thumbImage:_img_thumbnail description:_str_text inScene:WXSceneSession];
                                                                                              
                                                                                              [commond trackShareContent:[NSString stringWithFormat:@"%@;%@;",_str_Link,_str_text] shareTo:TRACK_WechatSession];
                                                                                            }];
  SSUIShareActionSheetCustomItem *item_wechatTimeline = [SSUIShareActionSheetCustomItem itemWithIcon:SNSIcon_wechatTimeLine
                                                                                               label:SNSType_wechatTimeLine
                                                                                             onClick:^{
                                                                                               [[WXApiWrapper sharedManager] sendLinkContent:_str_Link tagName:@"" title:[NSString stringWithFormat:@"%@;%@;%@",share_post_content1,share_post_content2,share_post_link] thumbImage:_img_thumbnail description:_str_text inScene:WXSceneTimeline];
                                                                                              
                                                                                               [commond trackShareContent:[NSString stringWithFormat:@"%@;%@;",_str_Link,_str_text] shareTo:TRACK_WechatTimeline];
                                                                                             }];
  
  SSUIShareActionSheetCustomItem *item_weibo = [SSUIShareActionSheetCustomItem itemWithIcon:SNSIcon_weibo
                                                                                      label:SNSType_weibo
                                                                                    onClick:^{
                                                                                      //weibo
                                                                                        WBMessageObject *message = [WBMessageObject message];
                                                                                      message.text = [NSString stringWithFormat:@"%@;%@;%@;%@",share_post_content1,share_post_content2,_str_text,_str_Link];
                                                                                        
                                                                                        WBImageObject *image = [WBImageObject object];
                                                                                        image.imageData = _data_toWeibo;
                                                                                        message.imageObject = image;
                                                                                        
                                                                                        [[WBApiWrapper sharedManager] shareToWeibo:message];
                                                                                        
                                                                                        [commond trackShareContent:message.text shareTo:TRACK_Weibo];
                                                                                    }];
  
  SSUIShareActionSheetCustomItem *item_qqPerson = [SSUIShareActionSheetCustomItem itemWithIcon:SNSIcon_qqFriend
                                                                                         label:SNSType_qqFriend
                                                                                       onClick:^{
                                                                                           //分享链接
                                                                                           [shareParams SSDKSetupShareParamsByText:
                                                                                            _str_text
                                                                                                                            images:@[_img_thumbnail]
                                                                                                                               url:[NSURL URLWithString:_str_Link]
                                                                                                                             title:[NSString stringWithFormat:@"%@;%@;%@",                                                                   share_post_content1,                                                                     share_post_content2,
                                                                                                                                    share_post_link]
                                                                                                                              type:SSDKContentTypeAuto];
                                                                                           
                                                                                           
                                                                                           [shareParams SSDKEnableUseClientShare];
                                                                                           //进行分享
                                                                                           [ShareSDK share:SSDKPlatformSubTypeQQFriend //传入分享的平台类型
                                                                                                parameters:shareParams
                                                                                            onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) { // 回调处理....}];
                                                                                            }];
                                                                                           
                                                                                           
                                                                                           [commond trackShareContent:[NSString stringWithFormat:@"%@;%@;%@;%@;%@",                                                                   share_post_content1,                                                                     share_post_content2,_str_text,              share_post_link,_str_Link] shareTo:TRACK_QQ];
                                                                                           
                                                                                       }];
  
  SSUIShareActionSheetCustomItem *item_qqZone = [SSUIShareActionSheetCustomItem itemWithIcon:SNSIcon_qqZone
                                                                                       label:SNSType_qqZone
                                                                                     onClick:^{
                                                                                         //分享链接
                                                                                         [shareParams SSDKSetupShareParamsByText:
                                                                                          _str_text
                                                                                                                          images:@[_img_thumbnail]
                                                                                                                             url:[NSURL URLWithString:_str_Link]
                                                                                                                           title:[NSString stringWithFormat:@"%@;%@;%@",                                                                   share_post_content1,                                                                     share_post_content2,
                                                                                                                                  share_post_link]
                                                                                                                            type:SSDKContentTypeAuto];
                                                                                         
                                                                                         
                                                                                         [shareParams SSDKEnableUseClientShare];
                                                                                         //进行分享
                                                                                         [ShareSDK share:SSDKPlatformSubTypeQZone //传入分享的平台类型
                                                                                              parameters:shareParams
                                                                                          onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) { // 回调处理....}];
                                                                                          }];
                                                                                         
                                                                                         [commond trackShareContent:[NSString stringWithFormat:@"%@;%@;%@;%@;%@",                                                                   share_post_content1,                                                                     share_post_content2,_str_text,              share_post_link,_str_Link] shareTo:TRACK_QZONE];
                                                                                         
                                                                                       
                                                                                     }];
  
  SSUIShareActionSheetCustomItem *item_twitter = [SSUIShareActionSheetCustomItem itemWithIcon:SNSIcon_twitter
                                                                                        label:SNSType_twitter
                                                                                      onClick:^{
                                                                                        
                                                                                        slComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
                                                                                        
                                                                                        if ([self availableSharePlateformWith:SLServiceTypeTwitter] == NO) {
                                                                                          [commond alert:multiLanguage(@"Alert") message:@"Service unavailable" callback:^(FGCustomAlertView *alertView, NSInteger buttonIndex) {
                                                                                            ;
                                                                                          }];
                                                                                          return;
                                                                                        }
                                                                                        
                                                                                        
                                                                                        
                                                                                        [slComposerSheet setInitialText:[NSString stringWithFormat:@"%@;%@;%@;%@",share_post_content1,share_post_content2,_str_text,share_post_link]];
                                                                                        [slComposerSheet addImage:_img_thumbnail];
                                                                                        if (_bool_hasVideoUrl)
                                                                                          [slComposerSheet addURL:[NSURL URLWithString:_str_Link]];
                                                                                        else
                                                                                          [slComposerSheet addURL:[NSURL URLWithString:share_post_link]];
                                                                                        [[_view viewController] presentViewController:slComposerSheet animated:YES completion:nil];
                                                                                        //}
                                                                                        [slComposerSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
                                                                                          NSLog(@"start completion block");
                                                                                          NSString *output;
                                                                                          switch (result) {
                                                                                            case SLComposeViewControllerResultCancelled:
                                                                                              output = @"Action Cancelled";
                                                                                              break;
                                                                                            case SLComposeViewControllerResultDone:
                                                                                              output = @"Post Successfull";
                                                                                              [commond trackShareContent:[NSString stringWithFormat:@"%@;%@;%@;%@;%@",                                                                   share_post_content1,                                                                     share_post_content2,
                                                                                                          _str_text,
                                                                                                    share_post_link,
                                                                                                        _str_Link] shareTo:TRACK_TWITTER];
                                                                                              break;
                                                                                            default:
                                                                                              break;
                                                                                          }
                                                                                          if (result == SLComposeViewControllerResultCancelled)
                                                                                          {
                                                                                            
                                                                                          }
                                                                                        }];
                                                                                        
                                                                                      }];
  
  
  
  NSArray * platforms =@[item_wechatSession,item_wechatTimeline,item_weibo,item_qqPerson,item_qqZone,@(SSDKPlatformTypeFacebook),item_twitter, @(SSDKPlatformTypeMail)];
  [shareParams SSDKEnableUseClientShare];
  //再把声明的platforms对象传进分享方法里的items参数里
  SSUIShareActionSheetController *sheet = [ShareSDK showShareActionSheet:nil
                                                                   items:platforms
                                                             shareParams:shareParams
                                                     onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                                                       switch (state) {
                                                         case SSDKResponseStateSuccess:
                                                           NSLog(@"分享成功!");
                                                           if (platformType == SSDKPlatformTypeFacebook) {
                                                             [commond trackShareContent:_str_shareContent shareTo:TRACK_FACEBOOK];
                                                           } else if (platformType == SSDKPlatformTypeMail) {
                                                             [commond trackShareContent:_str_shareContent shareTo:TRACK_EMAIL];
                                                           }
                                                           break;
                                                         case SSDKResponseStateFail:
                                                           NSLog(@"分享失败%@",error);
                                                           break;
                                                         case SSDKResponseStateCancel:
                                                           NSLog(@"分享已取消");
                                                           break;
                                                         default:
                                                           break;
                                                       }
                                                     }];
  [sheet.directSharePlatforms addObject:@(SSDKPlatformTypeFacebook)];//（加了这个方法之后可以不跳分享编辑界面，直接点击分享菜单里的选项，直接分享）
  [sheet.directSharePlatforms addObject:@(SSDKPlatformTypeMail)];//（加了这个方法之后可以不跳分享编辑界面，直接点击分享菜单里的选项，直接分享）
}

#pragma mark -
- (BOOL)availableSharePlateformWith:(NSString *)_str_plateformType {
  if (![SLComposeViewController isAvailableForServiceType:_str_plateformType]){
//    [commond alert:multiLanguage(@"Alert") message:@"Service unavailable" callback:^(FGCustomAlertView *alertView, NSInteger buttonIndex) {
//      ;
//    }];
    return NO;
  }
  
  if (slComposerSheet == nil){
//    [commond alert:multiLanguage(@"Alert") message:@"Service unavailable" callback:^(FGCustomAlertView *alertView, NSInteger buttonIndex) {
//      ;
//    }];
    return NO;
  }
  
  return YES;
}

@end
