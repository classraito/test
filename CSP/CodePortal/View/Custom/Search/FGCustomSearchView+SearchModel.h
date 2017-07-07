//
//  FGCustomSearchView+SearchModel.h
//  CSP
//
//  Created by JasonLu on 16/10/13.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGCustomSearchView.h"
#import <UIKit/UIGeometry.h>

@interface FGCustomSearchView (SearchModel)
- (void)setupSearchModelWithFrame:(CGRect)frame padding:(UIEdgeInsets)padding searchCancleButtonTitle:(NSString *)title withAnimated:(BOOL)isAnimation;
- (void)searchDidSearch;
@end
