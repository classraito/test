//
//  FGUserInputPageBaseView.h
//  CSP
//
//  Created by Ryan Gong on 16/9/3.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

//这个类主要处理 用户输入时 弹出键盘 会遮住部分界面的情况
//继承这个类的view 是一个scrollview 当弹出键盘 或用户自定义的输入区域后 scrollview会调整高度 并可滚动
//目前子类只支持nib 加载的方式初始化
#import <UIKit/UIKit.h>
typedef enum
{
    InputType_Inital = 0,
    InputType_Inputing = 1
}InputType;

@interface FGUserInputPageBaseView : UIScrollView<UIGestureRecognizerDelegate,UITextFieldDelegate>
{
    
}
@property InputType currentInputType;
@property CGFloat currentSlideUpHeight;
-(void)setupByOriginalContentSize:(CGSize)_contentSize;
-(void)bindDataToUI:(NSMutableArray *)_arr_imgs videoFilePath:(NSString *)_str_filePath;
-(void)adjustVisibleRegion:(CGFloat)_slideUpHeight;
-(void)resetVisibleRegion;
-(void)removeAllInputView;
- (void)scrollsToBottomAnimated:(BOOL)animated;
#pragma mark - 这个方法指定子视图滚动到底部 如果需要的话
#pragma mark - 这个方法必须在 adjustVisibleRegion 之后调用 adjustVisibleRegion方法指定了现在是输入模式的状态
//_heightOccupied 告知这个view占用了多少高度
-(void)scrollSubViewToBottomIfNeeded:(UIView *)_view_subviewOfScrollView heightOccupied:(CGFloat)_heightOccupied;
@end
