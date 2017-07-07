//
//  UITableView+ShowNoResult.h
//  CSP
//
//  Created by Ryan Gong on 17/1/12.
//  Copyright © 2017年 Fugumobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (ShowNoResult)
{
    
}
-(void)showNoResultWithText:(NSString *)_str_text;
-(void)showNoResultWithText:(NSString *)_str_text atCenterY:(CGFloat)_centerY;
-(void)showNoResultWithText:(NSString *)_str_text atCenterY:(CGFloat)_centerY withImage:(UIImage *)_img;
-(void)resetNoResultView;
@end
