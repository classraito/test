//
//  FGTrainingStepByStepPreviewVideoView.h
//  CSP
//
//  Created by Ryan Gong on 16/9/18.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FGVideoModel.h"
@interface FGTrainingStepByStepPreviewVideoView : UIView<FGVideoModelDownloadDelegate,UIScrollViewDelegate>
{
    
}
@property(nonatomic,weak)IBOutlet UIScrollView *sv;
@property(nonatomic,weak)IBOutlet UIImageView *iv_left;
@property(nonatomic,weak)IBOutlet UIImageView *iv_right;
@end
