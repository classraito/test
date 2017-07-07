//
//  UITableView+ShowNoResult.m
//  CSP
//
//  Created by Ryan Gong on 17/1/12.
//  Copyright © 2017年 Fugumobile. All rights reserved.
//

#import "UITableView+ShowNoResult.h"
#import "Global.h"
#import "FGShowNoResultView.h"
@implementation UITableView (ShowNoResult)
-(void)showNoResultWithText:(NSString *)_str_text
{
    [self showNoResultWithText:_str_text atCenterY:self.frame.size.height / 2];
}

-(void)showNoResultWithText:(NSString *)_str_text atCenterY:(CGFloat)_centerY
{
    [self showNoResultWithText:_str_text atCenterY:_centerY withImage:nil];
}

-(void)showNoResultWithText:(NSString *)_str_text atCenterY:(CGFloat)_centerY withImage:(UIImage *)_img
{
    FGShowNoResultView *view_showNoResult = (FGShowNoResultView *)[[[NSBundle mainBundle] loadNibNamed:@"FGShowNoResultView" owner:nil options:nil] objectAtIndex:0];
    [commond useDefaultRatioToScaleView:view_showNoResult];
    view_showNoResult.center = CGPointMake(self.frame.size.width / 2, _centerY);
    view_showNoResult.lb_noResult.text = _str_text;
    if(_img)
        view_showNoResult.iv_thumbnail.image = _img;
    [self addSubview:view_showNoResult];
    NSLog(@"view_showNoResult.frame = %@",NSStringFromCGRect(view_showNoResult.frame));
    //[self sendSubviewToBack:view_showNoResult];
}

-(void)resetNoResultView
{
    for(UIView *_subView in [self subviews])
    {
        if([_subView isKindOfClass:[FGShowNoResultView class]])
        {
            FGShowNoResultView *_view_noResult = (FGShowNoResultView *)_subView;
            SAFE_RemoveSupreView(_view_noResult);
            _view_noResult = nil;
        }
    }
}


@end
