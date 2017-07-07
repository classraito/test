//
//  FGImageQueueCustomView.h
//  CSP
//
//  Created by Ryan Gong on 16/9/21.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGCustomizableBaseView.h"
typedef enum
{
    ViewsQueueIncreaseMode_LEFT = 0,
    ViewsQueueIncreaseMode_RIGHT = 1,
    ViewsQueueIncreaseMode_UP = 2,
    ViewsQueueIncreaseMode_DOWN = 3,
    ViewsQueueIncreaseMode_CENTER = 4
}ViewsQueueIncreaseMode;


@interface FGViewsQueueCustomView : FGCustomizableBaseView
{
    
}
@property ViewsQueueIncreaseMode increaseMode;
#pragma mark - 设置需要排列的view 
/*
    _arr_views:  需要被排列的view  
    _padding : 间隔
    _increaseMode: 可以向上下左右四个方向增长
 */
-(void)initalQueueByViews:(NSArray *)_arr_views padding:(CGFloat)_padding increaseMode:(ViewsQueueIncreaseMode)_increaseMode;

/*
 _arr_imgNames:  需要被排列的图片的名称的数组
  _arr_imgNames_highlighted:  需要被排列的图片的高亮状态时的名称的数组
 _padding : 间隔
 _imgBounds: 指定图片宽高
 _increaseMode: 可以向上下左右四个方向增长
 return: 包含所有 UIImageView 的数组
 */
-(NSMutableArray *)initalQueueByImageNames:(NSArray *)_arr_imgNames  highlightedImageNames:(NSArray *)_arr_imgNames_highlighted padding:(CGFloat)_padding imgBounds:(CGRect)_imgBounds  increaseMode:(ViewsQueueIncreaseMode)_increaseMode;

-(void)updateHighliteByCount:(NSInteger)_highlightCount;
@end
