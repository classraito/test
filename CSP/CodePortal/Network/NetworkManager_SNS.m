//
//  NetworkManager_SNS.m
//  CSP
//
//  Created by JasonLu on 17/1/15.
//  Copyright © 2017年 Fugumobile. All rights reserved.
//

#import "NetworkManager_SNS.h"

@implementation NetworkManager_SNS
-(void)postRequest_qqShareToQZoneWithInfo:(NSDictionary *)_dic_info userinfo:(NSMutableDictionary *)_dic_userinfo {
  NSMutableDictionary *_dic_headers = [NSMutableDictionary dictionary];
  [_dic_headers setObject:@"multipart/form-data" forKey:@"Content-Type"];

  
  NSMutableDictionary *dic_params = [NSMutableDictionary dictionary];
  [dic_params setObjectSafty:@"json" forKey:@"format"];
  [dic_params setObjectSafty:@"test" forKey:@"content"];
  [dic_params setObjectSafty:@"" forKey:@"clientip"];
  [dic_params setObjectSafty:@0 forKey:@"longitude"];
  [dic_params setObjectSafty:@0 forKey:@"latitude"];
  [dic_params setObjectSafty:IMGWITHNAME(@"featured-user1") forKey:@"pic"];
  [dic_params setObjectSafty:@0 forKey:@"syncflag"];
  [dic_params setObjectSafty:@0 forKey:@"compatibleflag"];

  [self requestUrl:HOST(URL_SNSQQ_shareToQZone) params:dic_params headers:_dic_headers userinfo:_dic_userinfo];
}

@end
