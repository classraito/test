//
//  FGCommentsCommonView.h
//  CSP
//
//  Created by Ryan Gong on 16/9/20.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NSAttributedString+Attributes.h"
#import "OHASBasicHTMLParser.h"
#import "OHASBasicMarkupParser.h"
#import "OHAttributedLabel.h"

@interface FGCommentsCommonCellView : UITableViewCell<OHAttributedLabelDelegate> {
}
@property (nonatomic, weak) IBOutlet UIImageView *iv_thumbnail;
@property (nonatomic, weak) IBOutlet UILabel *lb_username;
@property (nonatomic, weak) IBOutlet OHAttributedLabel *ml_comments;
@property (nonatomic, weak) IBOutlet UILabel *lb_time;
@property (nonatomic, weak) IBOutlet UIView *view_separator;
@property(nonatomic,strong) NSString *str_userId;
@end
