//
//  FGStopWatchHistoryTableView.h
//  CSP
//
//  Created by Ryan Gong on 16/9/8.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FGStopWatchLogicModel.h"
@interface FGStopWatchHistoryTableView : UITableView<UITableViewDataSource,UITableViewDelegate>
{
    
}
#pragma mark - 加载模型
-(void)loadModel:(FGStopWatchLogicModel *)_model;
@end
