//
//  FGLocationFindAGYMListView.h
//  CSP
//
//  Created by Ryan Gong on 16/11/24.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface FGLocationFindAGYMListView : UIView<UITableViewDelegate,UITableViewDataSource>
{
    
}
@property(nonatomic,weak)IBOutlet UITableView *tb;
@property NSInteger commentCursor;
@property NSInteger totalComment;

-(void)bindDataToUI;
-(void)loadMoreGYMList;
-(void)beginRefresh;
@end
