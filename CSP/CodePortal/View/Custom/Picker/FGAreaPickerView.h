//
//  FGAreaPickerView.h
//  Pureit
//
//  Created by Ryan Gong on 16/1/21.
//  Copyright © 2016年 Ryan Gong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HZAreaPickerView.h"
@protocol FGAreaPickerViewDelegate<NSObject>
-(void)didSelectData:(NSString *)_str_selected ids:(NSString *)_str_selectedID picker:(id)_dataPicker;
-(void)didSelectData:(NSString *)_str_selected picker:(id)_dataPicker;
-(void)didCloseDataPicker:(NSString *)_str_selected  picker:(id)_dataPicker;
@end
@interface FGAreaPickerView : UIView<HZAreaPickerDelegate>
{
    
}
@property(nonatomic,assign)IBOutlet UIView *view_picker;
@property(nonatomic,assign)id<FGAreaPickerViewDelegate>delegate;
@property (strong, nonatomic) HZAreaPickerView *locatePicker;
@property(nonatomic,assign)IBOutlet UIButton *btn;
-(IBAction)buttonAction_done:(id)_sender;
@property (strong, nonatomic) NSString *areaValue;
@property(strong,nonatomic)NSString *areaID;
@end
