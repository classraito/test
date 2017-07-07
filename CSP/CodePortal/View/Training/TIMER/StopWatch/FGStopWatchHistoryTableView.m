//
//  FGStopWatchHistoryTableView.m
//  CSP
//
//  Created by Ryan Gong on 16/9/8.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGStopWatchHistoryTableView.h"
#import "FGStopWatchLogCellView.h"
#import "Global.h"
@interface FGStopWatchHistoryTableView()
{
    FGStopWatchLogicModel *model_stopWatch;
}
@end

@implementation FGStopWatchHistoryTableView
#pragma mark - 生命周期
-(void)awakeFromNib
{
    [super awakeFromNib];
}

-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
}

#pragma mark - 加载模型
-(void)loadModel:(FGStopWatchLogicModel *)_model
{
    model_stopWatch = _model;
    self.delegate = self;
    self.dataSource = self;
    [self reloadData];
    [self setNeedsDisplay];
    if([model_stopWatch.arr_stopWatchHistory count]==0)
    {
        self.contentInset = UIEdgeInsetsMake(-30, 0, 0, 0);//往上移一点 以便看到第三根线
    }
    else
    {
        self.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
}

#pragma mark - UITableViewDelegate
/*table cell高度*/
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 30 * ratioH;
}


#pragma mark - UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return [model_stopWatch.arr_stopWatchHistory count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
  
        NSString *CellIdentifier = @"FGStopWatchLogCellView";
        FGStopWatchLogCellView *cell = (FGStopWatchLogCellView *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];//从xib初始化tablecell
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
            cell = (FGStopWatchLogCellView *)[nib objectAtIndex:0];
            
        }
        //倒序
        NSInteger index = [model_stopWatch.arr_stopWatchHistory count] - indexPath.row - 1;
        NSTimeInterval secs = [[model_stopWatch.arr_stopWatchHistory objectAtIndex:index] doubleValue];
        cell.lb_lapname.text = [NSString stringWithFormat:@"%@%ld",multiLanguage(@"Lap"),index+1];
        cell.lb_lapTime.text = [commond clockFormatByMicroSeconds:secs];
        return cell;
        
    
}

@end
