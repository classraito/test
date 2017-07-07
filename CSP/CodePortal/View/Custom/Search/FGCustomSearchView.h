//
//  FGCustomSearchView.h
//  CSP
//
//  Created by Ryan Gong on 16/9/13.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGCustomizableBaseView.h"

@protocol FGCustomSearchViewDelegate <NSObject>

@optional
- (void)searchDidCancle;

@end

@interface FGCustomSearchView : FGCustomizableBaseView {
}
@property (nonatomic, assign) IBOutlet UIImageView *iv_searchIcon;
@property (nonatomic, assign) IBOutlet UITextField *tf_search;
@property (weak, nonatomic) IBOutlet UIView *view_bg;
@property (nonatomic, assign) BOOL isEditing;
@property (nonatomic, assign) id<FGCustomSearchViewDelegate> delegate;
@property (nonatomic, assign) CGRect rect_originSelfFrame;
@property (nonatomic, assign) CGRect rect_originViewBgFrame;
@property (nonatomic, assign) CGRect rect_originSearchIcon;
@property (nonatomic, assign) CGRect rect_originSearchTF;
#pragma mark - 设置方法
- (void)setupByBGColor:(UIColor *)_bgColor borderColor:(UIColor *)_borderColor roundRadius:(CGFloat)_roundRaduis borderWidth:(CGFloat)_borderWidth;
#pragma mark - 设置方法(带placeholder设置)
- (void)setupByBGColor:(UIColor *)_bgColor borderColor:(UIColor *)_borderColor roundRadius:(CGFloat)_roundRaduis borderWidth:(CGFloat)_borderWidth placeHolderColor:(UIColor *)_placeHolderColor placeHolderFont:(UIFont *)_placeHolderFont;
@end
