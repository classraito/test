//
//  FGTrainingVideoPreviewViewController.h
//  CSP
//
//  Created by Ryan Gong on 16/9/18.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGBaseViewController.h"
#import "FGTrainingStepByStepPreviewVideoView.h"

#define NOTIFICATION_KEY_VIDEOPAGE_CHANGED @"NOTIFICATION_KEY_VIDEOPAGE_CHANGED"

@interface FGTrainingVideoPreviewViewController : FGBaseViewController
{
    
}
@property(nonatomic,strong) FGTrainingStepByStepPreviewVideoView *view_previewVideo;
-(void)videoPageDidChange;
@end
