//
//  FGLocationFindAGYMMapVIew.h
//  CSP
//
//  Created by Ryan Gong on 16/11/24.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGLocationMapBaseView.h"

@interface FGLocationFindAGYMMapVIew : FGLocationMapBaseView<MFMailComposeViewControllerDelegate>
{
    
}
@property(nonatomic,strong)NSMutableArray *arr_annotations;
@property(nonatomic,weak)IBOutlet FGCustomButton *cb_registeAGroup;
@property(nonatomic,strong)FGLocationRegisteAGroupView *view_registeGroupPopup;
-(void)updateAllAnnotationsByDatas:(NSMutableArray *)_arr_datas;
-(void)internalInitalRegisteGroupPopupView;
@end
