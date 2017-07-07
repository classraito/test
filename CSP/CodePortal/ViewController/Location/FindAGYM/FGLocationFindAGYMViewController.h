//
//  FGLocationFindAGYMViewController.h
//  CSP
//
//  Created by Ryan Gong on 16/11/24.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGBaseViewController.h"
#import "FGLocationFindAGYMMapVIew.h"
#import "FGLocationFindAGYMListView.h"
@interface FGLocationFindAGYMViewController : FGBaseViewController
{
    
}
@property(nonatomic,weak)IBOutlet UIView *view_section;
@property(nonatomic,weak)IBOutlet UIView *view_separator_v;
@property(nonatomic,weak)IBOutlet UIButton *btn_map;
@property(nonatomic,weak)IBOutlet UIButton *btn_list;
@property LocationSectionType sectionType;

@property(nonatomic,strong)FGLocationFindAGYMMapVIew *view_map;
@property(nonatomic,strong)FGLocationFindAGYMListView *view_list;

-(void)updateMapViewAnnotationByData:(NSMutableArray *)_arr_datas;
@end
