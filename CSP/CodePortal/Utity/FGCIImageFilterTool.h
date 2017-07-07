//
//  FGCIImageFilterTool.h
//  CSP
//
//  Created by Ryan Gong on 16/11/3.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FGCIImageFilterTool : NSObject
{
    
}
@property(nonatomic,strong)NSMutableArray *arr_items;
@property(nonatomic,strong)NSMutableArray *arr_displayNames;
+(instancetype)sharedTool;//manager 单例初始化
-(UIImage *)filterByImage:(UIImage *)orgImage useFilter:(NSString *)_str_filter;
-(UIImage *)filterByImage:(UIImage *)orgImage byFilterListIndex:(NSInteger)_index;
@end
