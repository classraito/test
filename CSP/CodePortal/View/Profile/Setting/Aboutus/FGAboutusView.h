//
//  FGAboutusView.h
//  CSP
//
//  Created by JasonLu on 17/1/19.
//  Copyright © 2017年 Fugumobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FGAboutusView : UIView <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tb_aboutus;
@end
