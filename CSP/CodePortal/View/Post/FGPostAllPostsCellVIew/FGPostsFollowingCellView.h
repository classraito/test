//
//  FGPostsFollowingCellView.h
//  CSP
//
//  Created by Ryan Gong on 16/10/17.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGPostsCommonCellView.h"
#import "OHAttributedLabel.h"
@interface FGPostsFollowingCellView : FGPostsCommonCellView
{
    
}
@property(nonatomic,weak)IBOutlet UIImageView *iv_like;
@property(nonatomic,weak)IBOutlet UILabel *lb_likes;
@property(nonatomic,weak)IBOutlet UIImageView *iv_comments;
@property(nonatomic,weak)IBOutlet UILabel *lb_comments;
@property(nonatomic,weak)IBOutlet UIImageView *iv_shares;
@property(nonatomic,weak)IBOutlet UILabel *lb_shares;
@property(nonatomic,weak)IBOutlet UIImageView *iv_dots;
@property(nonatomic,weak)IBOutlet UIButton *btn_likes;
@property(nonatomic,weak)IBOutlet UIButton *btn_shares;
@property(nonatomic,weak)IBOutlet UIButton *btn_comments;
@property(nonatomic,weak)IBOutlet UIButton *btn_more;

-(IBAction)buttonAction_like:(id)_sender;
-(IBAction)buttonAction_share:(id)_sender;
@end
