//
//  FGAboutusTitleView.h
//  CSP
//
//  Created by JasonLu on 17/1/20.
//  Copyright © 2017年 Fugumobile. All rights reserved.
//

#import "FGHomepageTitleView.h"
@protocol FGSectionHeaderDelegate <NSObject>

- (void)action_sectionHeaderTappedAtIndex:(NSInteger)index;

@end


@interface FGAboutusTitleView : FGHomepageTitleView
@property (nonatomic, weak)id<FGSectionHeaderDelegate> tapDelegate;
@end
