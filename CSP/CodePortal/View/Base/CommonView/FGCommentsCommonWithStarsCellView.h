//
//  FGCommentsCommonWithStarsCellView.h
//  CSP
//
//  Created by JasonLu on 16/10/25.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGCommentsCommonCellView.h"
#import "FGViewsQueueCustomView.h"
@interface FGCommentsCommonWithStarsCellView : FGCommentsCommonCellView
@property (weak, nonatomic) IBOutlet FGViewsQueueCustomView *qv_ratingLevel;
@end
