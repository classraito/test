//
//  FGAboutViewController.h
//  可展开Cell
//
//  Created by PengLei on 17/1/20.
//  Copyright © 2017年 PengLei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FGAboutViewController : FGBaseViewController <UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tbv_about;

@end
