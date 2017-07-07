//
//  FGWechatWrapper.m
//  CSP
//
//  Created by Ryan Gong on 17/2/6.
//  Copyright © 2017年 Fugumobile. All rights reserved.
//

#import "FGWechatWrapper.h"
#import "Global.h"
#import "WXApi.h"
#import "WXApiObject.h"
#import "ApiXml.h"
#import "WXUtil.h"
static id _instance = nil;
@implementation FGWechatWrapper
#pragma mark - 单例方法
+ (FGWechatWrapper *)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

#pragma mark - 初始化方法
- (id)init {
    if (ISEXISTObj(_instance))
        return _instance;
    
    if (self = [super init]) {
        
    }
    return self;
}

#pragma mark - 生命周期
- (void)dealloc {
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
}

- (void)doWechatPay:(NSString *)_str_response
{
    if ( _str_response != nil) {
        //解析服务端返回json数据
        
        NSMutableDictionary *dict = NULL;
        NSLog(@"str_response = %@",_str_response);
        XMLHelper *xml  = [XMLHelper alloc];
        //开始解析
        [xml startParse:[_str_response dataUsingEncoding:NSUTF8StringEncoding]];
        dict = [xml getDict];
        xml = nil;
        
        NSLog(@"dict = %@",dict);
        
        if(dict != nil){
            NSMutableString *retcode = [dict objectForKey:@"retcode"];
            if (retcode.intValue == 0){
                
                //调起微信支付接口   API说明: https://pay.weixin.qq.com/wiki/doc/api/app/app.php?chapter=9_12&index=2
                //微信公众平台支付接口调试工具: https://pay.weixin.qq.com/wiki/tools/signverify/
                PayReq* req             = [[PayReq alloc] init];
                req.openID              = [dict objectForKey:@"appid"];
                req.partnerId           = [dict objectForKey:@"partnerid"];
                req.prepayId            = [dict objectForKey:@"prepayid"];
                req.nonceStr            = [dict objectForKey:@"noncestr"];
                req.timeStamp           = [[dict objectForKey:@"timestamp"] intValue];
                req.package             = @"Sign=WXPay";//[dict objectForKey:@"package"];
                req.sign                = [dict objectForKey:@"sign"];
                [WXApi sendReq:req];
                //日志输出
                NSLog(@"appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",req.openID,req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign );
               // req = nil;
            }else{
                [commond alert:multiLanguage(@"ALERT") message:@"retmsg" callback:nil];
                
            }
        }else{
            [commond alert:multiLanguage(@"ALERT") message:multiLanguage(@"服务器返回错误，未获取到json对象") callback:nil];
        }
    }else{
        [commond alert:multiLanguage(@"ALERT") message:multiLanguage(@"服务器返回错误") callback:nil];
    }
}
@end
