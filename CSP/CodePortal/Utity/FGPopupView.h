//
//  FGPopupView.h
//  DurexBaby
//
//  Created by luyang on 12-9-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DRNRealTimeBlurView.h"
@interface FGPopupView : UIView
{
    
}
@property(nonatomic,strong)UIView *view_bg;
@property(nonatomic,strong)DRNRealTimeBlurView *blurView;
-(void)closePopup;
-(void)startAnim;
@end
