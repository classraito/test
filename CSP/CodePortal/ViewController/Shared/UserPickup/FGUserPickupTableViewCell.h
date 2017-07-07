//
//  FGUserPickupTableViewCell.h
//  CSP
//
//  Created by Ryan Gong on 16/11/16.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FGUserPickupTableViewCell : UITableViewCell
{
    
}
@property(nonatomic,weak)IBOutlet UILabel *lb_title;
@property(nonatomic,weak)IBOutlet UILabel *lb_topicTitle;
@property(nonatomic,weak)IBOutlet UIImageView *iv_thumbnail;
@property(nonatomic,strong)NSString *str_userid;
@property int listType;
@end
