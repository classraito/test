//
//  FGLocationFindAGYMListCellView.h
//  CSP
//
//  Created by Ryan Gong on 16/11/24.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FGViewsQueueCustomView.h"
@interface FGLocationFindAGYMListCellView : UITableViewCell
{
    
}
@property(nonatomic,weak)IBOutlet UIView *view_container;
@property(nonatomic,weak)IBOutlet UILabel *lb_gymTitle;
@property(nonatomic,weak)IBOutlet UILabel *lb_distance;
@property(nonatomic,weak)IBOutlet FGViewsQueueCustomView *queueView_rating;
@property(nonatomic,weak)IBOutlet UILabel *lb_address;
@property(nonatomic,weak)IBOutlet UIImageView *iv_gymThumbnail;

@end
