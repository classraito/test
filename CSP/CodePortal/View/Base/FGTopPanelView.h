//
//  FGTopPanelView.h
//  DunkinDonuts
//
//  Created by Ryan Gong on 15/11/16.
//  Copyright © 2015年 Ryan Gong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FGCustomSearchView.h"
#define DEFAULT_KEYBOARDHEIGHT_IPHONE5 253
#define DEFAULT_KEYBOARDHEIGHT_IPHONE6 258
#define DEFAULT_KEYBOARDHEIGHT_IPHONE6PLUS 271
@interface FGTopPanelView : UIView
{
    NSString *str_title;
}
@property(nonatomic,assign)IBOutlet FGCustomSearchView *cs_search;
@property(nonatomic,assign)IBOutlet UILabel *lb_title;
@property(nonatomic,assign,getter = getMyTitle,setter = setMyTitle:) NSString *str_title;
@property(nonatomic,assign)IBOutlet UIImageView *iv_left;
@property(nonatomic,assign)IBOutlet UIButton *btn_left;
@property(nonatomic,assign)IBOutlet UIImageView *iv_right;
@property(nonatomic,assign)IBOutlet UIButton *btn_right;
@property(nonatomic,assign)IBOutlet UIButton *btn_right_inside1;
@property(nonatomic,assign)IBOutlet UIImageView *iv_right_indise1;
@property(nonatomic,assign)IBOutlet UIView *view_separator;
@end

