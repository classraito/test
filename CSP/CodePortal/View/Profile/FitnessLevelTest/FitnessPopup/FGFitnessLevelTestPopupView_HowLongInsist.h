//
//  FGFitnessLevelTestPopupView_HowLongInsist.h
//  CSP
//
//  Created by Ryan Gong on 16/10/8.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGPopupView.h"
#import "FGHHMMSSPickerView.h"
#import "FGCustomButton.h"
@interface FGFitnessLevelTestPopupView_HowLongInsist : FGPopupView<FGDataPickerViewDelegate>
{
    
}
@property(nonatomic,weak)IBOutlet UILabel *lb_title;
@property(nonatomic,strong)FGHHMMSSPickerView *dp_hhmmss;
@property(nonatomic,weak)IBOutlet UIView *view_pickerContainer;
@property(nonatomic,weak)IBOutlet FGCustomButton *cb_done;
@end
