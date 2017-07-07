//
//  FGLocationMyGroupViewController.h
//  CSP
//
//  Created by Ryan Gong on 16/11/24.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGBaseViewController.h"
typedef enum
{
    LocationMyGroupSectionType_COMINGSOON = 0,
    LocationMyGroupSectionType_HISTORY = 1
}LocationMyGroupSectionType;

@interface FGLocationMyGroupViewController : FGBaseViewController
{
    
}
@property(nonatomic,weak)IBOutlet UIView *view_section;
@property(nonatomic,weak)IBOutlet UIView *view_separator_v;
@property(nonatomic,weak)IBOutlet UIButton *btn_comingSoon;
@property(nonatomic,weak)IBOutlet UIButton *btn_history;
@property(nonatomic,weak)IBOutlet UITableView *tb;
@property NSInteger commentCursor;
@property NSInteger totalComment;
@property LocationMyGroupSectionType sectionType;
-(IBAction)buttonAction_commingSoon:(id)_sender;
-(IBAction)buttonAction_history:(id)_sender;
@end

