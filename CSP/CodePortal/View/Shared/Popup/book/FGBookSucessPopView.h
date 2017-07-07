//
//  FGBookSucessPopView.h
//  CSP
//
//  Created by Ryan Gong on 16/11/28.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGPopupView.h"
#import "FGViewsQueueCustomView.h"
@interface FGBookSucessPopView : FGPopupView
{
    
}
@property(nonatomic,weak)IBOutlet UIView *view_whiteBG;
@property(nonatomic,weak)IBOutlet UILabel *lb_title;
@property(nonatomic,weak)IBOutlet UILabel *lb_subtitle;
@property(nonatomic,weak)IBOutlet UIImageView *iv_trainerThumbnail;
@property(nonatomic,weak)IBOutlet UILabel *lb_trainerName;
@property(nonatomic,weak)IBOutlet FGViewsQueueCustomView *queueView_rating;
@property(nonatomic,weak)IBOutlet UIButton *btn_done;
@end
