//
//  FGLocationFindATrainerMapView.h
//  CSP
//
//  Created by Ryan Gong on 16/11/24.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGLocationMapBaseView.h"

@interface FGLocationFindATrainerMapView : FGLocationMapBaseView<AMapSearchDelegate>
{
    
}
@property(nonatomic,weak)IBOutlet UILabel *lb_addressBar;
@property(nonatomic,weak)IBOutlet UIView *view_addressBg;
@property(nonatomic,weak)IBOutlet UIImageView *iv_arrow_up;
@end
