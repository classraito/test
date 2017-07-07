//
//  FGCitiesPickupViewController.h
//  CSP
//
//  Created by JasonLu on 17/1/3.
//  Copyright © 2017年 Fugumobile. All rights reserved.
//

#import "FGBaseViewController.h"

@interface FGCitiesPickupViewController : FGBaseViewController <UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,weak)IBOutlet UITableView *tb;
@property(nonatomic,strong)NSMutableArray *arr_data;
@end
