//
//  FGClearCacheView.h
//  CSP
//
//  Created by JasonLu on 17/1/20.
//  Copyright © 2017年 Fugumobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FGClearCacheView : UIView <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tb_settings;
@property (nonatomic, strong, readonly) NSMutableArray *arr_data;
@end
