//
//  FGTrainerProfileInfoCellView.h
//  CSP
//
//  Created by JasonLu on 16/10/20.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FGCircluarForTrainerIconButton;
@class FGViewsQueueCustomView;
@interface FGTrainerProfileInfoCellView : UITableViewCell
@property (weak, nonatomic) IBOutlet FGCircluarForTrainerIconButton *view_useIconAndname;
@property (weak, nonatomic) IBOutlet UIImageView *iv_bg;
@property (weak, nonatomic) IBOutlet FGViewsQueueCustomView *qv_trainerLevel;

@end
