//
//  FGTrainingDetailLikesBannerCellView.h
//  CSP
//
//  Created by Ryan Gong on 16/9/20.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FGViewsQueueCustomView.h"
@interface FGTrainingDetailLikesBannerCellView : UITableViewCell
{
    
}
@property(nonatomic,weak)IBOutlet UIView *view_whiteBg;
@property(nonatomic,weak)IBOutlet FGViewsQueueCustomView *qv_imagesQueue;
@property(nonatomic,weak)IBOutlet UILabel *lb_likes;
@property(nonatomic,weak)IBOutlet UIImageView *iv_dot;
@end
