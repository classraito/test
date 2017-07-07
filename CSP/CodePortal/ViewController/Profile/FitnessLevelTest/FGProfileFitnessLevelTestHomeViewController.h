//
//  FGProfileFitnessLevelTestHomeViewController.h
//  CSP
//
//  Created by Ryan Gong on 16/12/7.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGBaseViewController.h"
#import "FGFitnessCellView.h"
#import "FGFitnessTestGroupCellView.h"
#import "FGFitnessTestTopBannerCellView.h"
@interface FGProfileFitnessLevelTestHomeViewController : FGBaseViewController
{
    
}
@property(nonatomic,weak)IBOutlet UITableView *tb;
@property NSInteger commentCursor;
@property NSInteger totalComment;
@end



@interface FGProfileFitnessLevelTestHomeViewController(TableView)<UITableViewDelegate,UITableViewDataSource>
{
    
}
@end
