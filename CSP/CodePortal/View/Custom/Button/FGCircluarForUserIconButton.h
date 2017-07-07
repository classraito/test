//
//  FGCircluarForUserIconButton.h
//  CSP
//
//  Created by JasonLu on 17/1/3.
//  Copyright © 2017年 Fugumobile. All rights reserved.
//

#import "FGCircluarWithRightTitleButton.h"

@interface FGCircluarForUserIconButton : FGCircluarWithBottomTitleButton
- (void)setupButtonInfoWithImageName:(NSString *)imgName;
- (void)setIconButtonTouchWhenHighlighted:(BOOL)isHighlighted;
@end
