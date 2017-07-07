//
//  FGHomepageSmallIconView.h
//  CSP
//
//  Created by JasonLu on 16/9/18.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FGHomepageSmallIconView : UIView
#pragma mark - IBOuelets
@property (weak, nonatomic) IBOutlet UIImageView *iv_icon;
@property (weak, nonatomic) IBOutlet UILabel *lb_title;
@property (weak, nonatomic) IBOutlet UIButton *btn_info;

- (void)updateViewWithIconLink:(NSString *)link title:(NSString *)title;
@end
