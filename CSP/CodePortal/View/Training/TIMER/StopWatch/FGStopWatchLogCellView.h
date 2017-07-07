//
//  FGStopWatchLogCellView.h
//  CSP
//
//  Created by Ryan Gong on 16/9/6.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FGStopWatchLogCellView : UITableViewCell
{
    
}
@property(nonatomic,assign)IBOutlet UILabel *lb_lapname;
@property(nonatomic,assign)IBOutlet UILabel *lb_lapTime;
@property(nonatomic,assign)IBOutlet UIView *view_separatorLine;
@end
