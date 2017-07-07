//
//  FGTrainingStepByStepView.h
//  CSP
//
//  Created by Ryan Gong on 16/9/18.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FGTrainingStepByStepView : UIView<UITableViewDelegate,UITableViewDataSource>
{
    
}
@property(nonatomic,weak)IBOutlet UITableView *tb;
-(void)bindDataToUI;
@end
