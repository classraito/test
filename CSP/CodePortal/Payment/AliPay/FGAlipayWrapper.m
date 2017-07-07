//
//  FGAlipayWrapper.m
//  CSP
//
//  Created by Ryan Gong on 16/12/30.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGAlipayWrapper.h"
#import "Global.h"
#import "Order.h"
#import "APAuthV2Info.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
static id _instance = nil;
@implementation FGAlipayWrapper
#pragma mark - 单例方法
+ (FGAlipayWrapper *)shareInstance {
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


#pragma mark -
#pragma mark   ==============点击订单模拟支付行为==============
//
//选中商品调用支付宝极简支付
//
- (void)doAlipayPay:(NSString *)_str_signed
{
        //应用注册scheme,在AliSDKDemo-Info.plist定义URL types
        NSString *appScheme = APP_BUNDLEID;
    
        NSLog(@"_str_signed = %@",_str_signed);
        // NOTE: 调用支付结果开始支付
        [[AlipaySDK defaultService] payOrder:_str_signed fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
        }];
}

- (NSString *)generateTradeNO
{
    static int kNumber = 15;
    
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand((unsigned)time(0));
    for (int i = 0; i < kNumber; i++)
    {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}
@end
