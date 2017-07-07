//
//  FGLikesPickupViewController.h
//  CSP
//
//  Created by Ryan Gong on 16/12/20.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGBaseViewController.h"

@interface FGLikesPickupViewController : FGBaseViewController
{
    
}
@property(nonatomic,weak)IBOutlet UITableView *tb;
@property(nonatomic,strong)NSMutableArray *arr_data;
@property(nonatomic,strong)NSString *str_trainingID;
@property(nonatomic,strong)NSString *str_groupID;
@property NSInteger commentCursor;
@property NSInteger totalComment;
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil trainingID:(NSString *)_str_trainingID;
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil groupId:(NSString *)_str_groupId;
-(void)beginRefresh;
@end


@interface FGLikesPickupViewController(TableView)<UITableViewDelegate,UITableViewDataSource>
{
    
}
@end
