//
//  FGDataPickeriew.h
//  DunkinDonuts
//
//  Created by Ryan Gong on 15/11/24.
//  Copyright © 2015年 Ryan Gong. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol FGDataPickerViewDelegate<NSObject>

-(void)didSelectData:(NSString *)_str_selected picker:(id)_dataPicker;
-(void)didCloseDataPicker:(NSString *)_str_selected  picker:(id)_dataPicker;
@end

@interface FGDataPickeriView : UIView<UIPickerViewDataSource,UIPickerViewDelegate>
{
    
}
@property(nonatomic,strong)UIFont *labelFont;
@property(nonatomic,assign)IBOutlet UIPickerView *pv;
@property(nonatomic,assign)id<FGDataPickerViewDelegate>delegate;
@property(nonatomic,assign)IBOutlet UIButton *btn;
-(IBAction)buttonAction_done:(id)_sender;
-(void)setupDatas:(NSArray*)_arr_datas;
@end
