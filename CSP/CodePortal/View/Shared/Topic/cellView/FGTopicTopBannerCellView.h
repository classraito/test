//
//  FGTopicTopBannerCellView.h
//  CSP
//
//  Created by Ryan Gong on 16/12/1.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FGTopicTopBannerCellView : UITableViewCell
{
    
}
@property(nonatomic,weak)IBOutlet UIImageView *iv_topicBg;
@property(nonatomic,weak)IBOutlet UILabel *lb_topicName;
@property(nonatomic,weak)IBOutlet UILabel *lb_postCount;
@end
