//
//  FGWriteFeedBackView.h
//  CSP
//
//  Created by Ryan Gong on 16/11/28.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGUserInputPageBaseView.h"
#import "FGViewsQueueCustomView.h"
@interface FGWriteFeedBackView : FGUserInputPageBaseView
{
    
}
@property(nonatomic,weak)IBOutlet UIImageView *iv_trainerThumbnail;
@property(nonatomic,weak)IBOutlet FGViewsQueueCustomView *queueView_rating;
@property(nonatomic,weak)IBOutlet UITextView *tv_feedback;
@property(nonatomic,weak)IBOutlet UIButton *btn_sendFeedback;
@end
