//
//  FGCustomBadgeView.h
//  CSP
//
//  Created by JasonLu on 17/1/24.
//  Copyright © 2017年 Fugumobile. All rights reserved.
//

#import "FGCustomizableBaseView.h"

@interface FGCustomBadgeView : FGCustomizableBaseView
@property (weak, nonatomic) IBOutlet UIView *view_bg;
@property (weak, nonatomic) IBOutlet UILabel *lb_title;

- (void)setupViewWithInfo:(NSDictionary *)_dic;

@end
