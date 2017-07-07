//
//  Global.h
//  MyStock
//
//  Created by Ryan Gong on 15/9/10.
//  Copyright (c) 2015年 Ryan Gong. All rights reserved.
//

#pragma mark - 导入头
#import "AppDelegate.h"
#import "Font.h" //字体
#import "MBProgressHUD.h"
#import "Macros.h"

//工具
//#import <ShareSDK/SSDKTypeDefine.h>
#import "FGSNSManager.h"
#import "UIView+ViewController.h"
#import "FGControllerManager.h"
#import "FGCustomAlertView.h"
#import "FGFont.h"
#import "FGLocationManagerWrapper.h"
#import "FGUtils.h"
#import "FGVideoModel.h"
#import "FGWindowsStyleProgressView.h"
#import "IMYWebView.h"
#import "JSONKit.h"
#import "MemoryCache.h"
#import "NSMutableArray+Safty.h"
#import "NSMutableDictionary+Safty.h"
#import "NSString+MD5.h"
#import "NSString+Utility.h"
#import "NSString+Validate.h"
#import "NetWorkMarco.h"
#import "NetworkManager.h"
#import "UIView+ViewController.h"
#import "NetworkManager_User.h"
#import "OHAttributedLabel+Utils.h"
#import "Reachability.h"
#import "SFHFKeychainUtils.h"
#import "TAlertView.h"
#import "UIDevice+IdentifierAddition.h"
#import "UIImageView+WebCache.h"
#import "UILabel+LineSpace.h"
#import "UIScrollView+FGRereshFooter.h"
#import "UIScrollView+FGRereshHeader.h"
#import "UIScrollView+FGWindowsStyleRefreshHeader.h"
#import "UITableViewCell+BindDataToUI.h"
#import "ZJSwitch.h"
#import "UIImage+FixOrientation.h"
#import "UITextView+Utils.h"
#import "XDRefresh.h"
#import "MJRefresh.h"
#import "commond.h" //一些实用的小工具 不归类了
#import <AVFoundation/AVFoundation.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//viewController
#import "FGControllerManager.h" //管理所有viewcontroller类的 1.初始化 2.销毁 3.导航 4.传递参数 .etc (这个类需要手动管理内存 non-arc)
#import "MemoryCache.h"
#import "STPopup.h"
#import "FGCIImageFilterTool.h"
#import "UIImage+SubImage.h"
#import "FGVideoModel.h"
#import "FGPostedVideoDownloadModel.h"
#import "FGSharedAVPlayerLayer.h"
#import "FGProfileFitnessTestModel.h"
#import "FGPaymentModel.h"
#include <AMapFoundationKit/AMapFoundationKit.h>
#import "DateTools.h"
#import "NetworkEventTrack.h"
#import "FGAlipayWrapper.h"
#import "FGWechatWrapper.h"
#import "UITableView+ShowNoResult.h"
#import "FGTimeCounterLabel.h"
#import "FGGlobalBadgesPopupView.h"
#import "UIColor+ColorChange.h"
#import "Mixpanel.h"
#import "UILabel+LoadingDot.h"
#import "UITextField+LoadingDot.h"
#import "NSMutableArray+Utity.h"
#import "FGPhotoGalleryManager.h"
#import "FGPostLikesCommentsSyncModel.h"

#pragma mark - 隐藏功能
#define NOINPUTPHONENUMBER_FEATURE 1
#define NOSEEMORE_FEATURE 1
#define REMOVEFAETUREUSER 1
#define REMOVEWORKOUTS 1
#define NOVIDEOSECTION 1
#pragma mark -

#define IMG_PLACEHOLDER nil //[UIImage imageNamed:@"image_default.png"]
#define IMG_PLACEHOLDER1 [UIImage imageNamed:@"image_default.png"]
#define FLURRY_CODE @""

//#define HOSTNAME @"http://brand.fugumobile.cn/CSP"   //测试服务器
#define HOSTNAME @"http://wbx.weboxapp.com"        //正式服务器
//使用默认的本地图片
#define USELOCALDEFAULTBGIMAGE 1
#define IMG_USERDEFAULTICON IMGWITHNAME(@"ic_user_default2")



//============================开发版预编译========================
#if defined(DEVELOPER)
#define APP_BUNDLEID @"com.csp.WeBox"
#define AUTONAVI_KEY @"04e872ea3a53b57043916c4c57b93e66"//高德地图 APP KEY
#define MIXPANEL_TOKEN @"f14976c6f06b10513791205f3bbb3d4c"
#endif

//===========================发布版预编译========================
#if defined(DISTRIBUTION)
#define APP_BUNDLEID @"com.csp.WeBox"
#define AUTONAVI_KEY @"04e872ea3a53b57043916c4c57b93e66" //高德地图 APP KEY
#define MIXPANEL_TOKEN @"f14976c6f06b10513791205f3bbb3d4c"
#endif

#define appDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate) //获得AppDelegate实例的宏 如果你的AppDelegate文件名与我不同 请在这里更改"AppDelegate"

#pragma mark - 分享信息    //com.csp.WeBox
//--------CSP官方微博--------
#define WEIBO_APPKEY @"2769012389"
#define WEIBO_APPSECRET @"1fea3ed7857e63aee3c4fc9fa093846b" 
#define WEIBO_kRedirectURI @"http://www.weboxapp.com"

//--------微信APPID--------------
#define WECHAT_APPID @"wx323607d747a88c7b"//@"wx61fa75ed542e1883"
#define WECHAT_APPSECRET @"9923196dbc900e7071ab62d013cc53a8"

//--------腾讯APPID--------------
#define QQ_APPID @"1105918470"
#define QQ_APPKEY @"1105918470"//@"8f4ZYEJxHKXRmDH0" //QQ41EAFA06

//--------Facebook APPID--------------
#define FB_APPID @"251866938571947"
#define FB_APPSECRET @"aded061175487354e0d254cbf3db8670"

//--------Instagram APPID--------------
#define IG_APPID @"7c1be66e022949ff9be2c5d44e1ffc3b"
#define IG_APPSECRET @""

//--------Twitter APPID--------------
#define TW_APPID @"WWOj6xr07ajWrVqdmQD5ExTxL"
#define TW_APPSECRET @"njoowOaAtgWqTSpAzml7YzuUet55HRJO6lX4yij61UEg4EU5hE"
#define TW_kRedirectURI @"http://www.weboxapp.com"


//--------Push key--------------
static BOOL isProduction = FALSE;
#define JPush_AppKey @"e16048906e3e1aa221ed64e6"
#define JPush_Channel @"Publish channel"
#define KEYCHAIN_KEY_PUSH_DEVICETOKEN @"KEYCHAIN_KEY_PUSH_DEVICETOKEN"
#define JPush_UserId @"JPush_UserId"


//----------分享内容--------------
//Add Friends
#define share_AddFriends_title @""
#define share_AddFriends_content1 multiLanguage(@"50RMB off Boxing training")
#define share_AddFriends_content2 multiLanguage(@"Sign up! Get 50RMB off your first class")
#define share_AddFriends_link @"http://weboxapp.com/"

//分享邀请码
#define share_inviationCode_title @""
#define share_inviationCode_content1 multiLanguage(@"I am giving you 50RMB off of your first personal training session with WEBOX. To enjoy it, please use my code")
#define share_inviationCode_content2 multiLanguage(@"Happy training!")
#define share_inviationCode_link @"http://weboxapp.com"

//分享joinGroup内容
#define share_joinGroup_content1 multiLanguage(@"50RMB off Boxing training")
#define share_joinGroup_content2 multiLanguage(@"Sign up! Get 50RMB off your first class")
#define share_joinGroup_link @"http://weboxapp.com"

//分享training内容
#define share_training_content1 multiLanguage(@"50RMB off Boxing training")
#define share_training_content2 multiLanguage(@"Sign up! Get 50RMB off your first class")
#define share_training_link @"http://weboxapp.com"

//分享post内容
#define share_post_content1 multiLanguage(@"50RMB off Boxing training")
#define share_post_content2 multiLanguage(@"Sign up! Get 50RMB off your first class")
#define share_post_link @"http://weboxapp.com"

//追踪关键字
#define TRACK_FACEBOOK @"Facebook"
#define TRACK_EMAIL @"Email"
#define TRACK_TWITTER @"Twitter"
#define TRACK_QQ @"QQ"
#define TRACK_QZONE @"QQ"
#define TRACK_WechatSession @"Wechat"
#define TRACK_WechatTimeline @"Wechat"
#define TRACK_Weibo @"Weibo"
