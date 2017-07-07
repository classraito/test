//
//  FGLocationViewController.h
//  CSP
//
//  Created by Ryan Gong on 16/9/13.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGBaseViewController.h"
#define KEY_CURRENTCITYNAME @"KEY_CURRENTCITYNAME"
@interface FGLocationViewController : FGBaseViewController<UITableViewDelegate,UITableViewDataSource>
{
    
}
@property(nonatomic,weak)IBOutlet UITableView *tb;
@property(nonatomic,strong)NSMutableArray *arr_data;
@end
