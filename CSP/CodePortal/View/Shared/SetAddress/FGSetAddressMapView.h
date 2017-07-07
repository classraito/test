//
//  FGSetAddressMapView.h
//  CSP
//
//  Created by Ryan Gong on 16/12/5.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGLocationMapBaseView.h"

@interface FGSetAddressMapView : FGLocationMapBaseView
{
    
}
@property(nonatomic,strong)NSString *str_address;
@property(nonatomic,strong)NSString *str_provinceDestrict;
/*根据关键字查周边*/
- (void)searchPoiBySearchKey:(NSString *)key;
/* 输入提示 搜索.*/
- (void)searchTipsWithKey:(NSString *)key;
@end
