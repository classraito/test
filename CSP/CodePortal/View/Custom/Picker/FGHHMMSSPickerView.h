//
//  FGDataPickeriew.h
//  DunkinDonuts
//
//  Created by Ryan Gong on 15/11/24.
//  Copyright © 2015年 Ryan Gong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FGDataPickeriView.h"

@interface FGHHMMSSPickerView : UIView<UIPickerViewDataSource,UIPickerViewDelegate>
{
    
}
@property(nonatomic,assign)IBOutlet UIPickerView *pv;
@property(nonatomic,assign)id<FGDataPickerViewDelegate>delegate;
@property(nonatomic,assign)IBOutlet UIButton *btn;
@property(nonatomic,weak)IBOutlet UIView *view_titlePanel;
-(IBAction)buttonAction_done:(id)_sender;
-(void)setupDatas;
-(void)setupTimeByStringFormat:(NSString *)_str_timeFormate;
-(void)setupTimeByStringFormat:(NSString *)_str_timeFormate dataTextColor:(UIColor *)_dataTextColor;
@end
