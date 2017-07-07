//
//  FGLocationFindAGYMDetailViewController.h
//  CSP
//
//  Created by Ryan Gong on 16/11/24.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGBaseViewController.h"
#import "FGViewsQueueCustomView.h"
@interface FGLocationFindAGYMDetailViewController : FGBaseViewController
{
    
}
@property(nonatomic,weak)IBOutlet UIImageView *iv_gymBigImage;
@property(nonatomic,weak)IBOutlet UILabel *lb_gymName;
@property(nonatomic,weak)IBOutlet FGViewsQueueCustomView *queueView_rating;
@property(nonatomic,weak)IBOutlet UILabel *lb_time1;
@property(nonatomic,weak)IBOutlet UILabel *lb_time2;
@property(nonatomic,weak)IBOutlet UILabel *lb_tel;
@property(nonatomic,weak)IBOutlet UILabel *lb_location;
@property(nonatomic,weak)IBOutlet UIButton *btn_bookNow;
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil detail:(NSMutableDictionary *)_dic_data;
-(IBAction)buttonAction_bookNow:(id)_sender;
@end
