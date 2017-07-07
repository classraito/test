//
//  NetworkManager_SNS.h
//  CSP
//
//  Created by JasonLu on 17/1/15.
//  Copyright © 2017年 Fugumobile. All rights reserved.
//

#import "NetworkManager.h"
#define URL_SNSQQ_shareToQZone @"https://graph.qq.com/t/add_pic_t"
@interface NetworkManager_SNS : NetworkManager
#pragma mark - 用户注册和登录接口, 会向用户手机发送验证码，没有注册的情况下，该用户将进入注册流程
-(void)postRequest_qqShareToQZoneWithInfo:(NSDictionary *)_dic_info userinfo:(NSMutableDictionary *)_dic_userinfo;

@end
