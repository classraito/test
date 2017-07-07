//
//  FGLocationFindAGroupViewController.h
//  CSP
//
//  Created by Ryan Gong on 16/11/24.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGBaseViewController.h"
#import "FGLocationJoinAGroupMapView.h"
#import "FGLocationJoinAGroupListView.h"
#import "FGLocationRegisteAGroupView.h"
typedef enum
{
    LocationSectionType_Map = 0,
    LocationSectionType_List = 1
}LocationSectionType;

@interface FGLocationFindAGroupViewController : FGBaseViewController
{
    
}
@property(nonatomic,weak)IBOutlet UIView *view_section;
@property(nonatomic,weak)IBOutlet UIView *view_separator_v;
@property(nonatomic,weak)IBOutlet UIButton *btn_map;
@property(nonatomic,weak)IBOutlet UIButton *btn_list;

@property(nonatomic,strong)FGLocationJoinAGroupMapView *view_map;
@property(nonatomic,strong)FGLocationJoinAGroupListView *view_list;
@property LocationSectionType sectionType;
-(IBAction)buttonAction_map:(id)_sender;
-(IBAction)buttonAction_list:(id)_sender;
-(void)buttonAction_myGroup:(id)_sender;
-(void)updateMapViewAnnotationByData:(NSMutableArray *)_arr_datas;
@end
