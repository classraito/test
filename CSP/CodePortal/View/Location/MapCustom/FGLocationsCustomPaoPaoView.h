//
//  FGLocationsCustomPaoPaoView.h
//  DunkinDonuts
//
//  Created by Ryan Gong on 15/12/1.
//  Copyright © 2015年 Ryan Gong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FGCustomButton.h"
@interface FGLocationsCustomPaoPaoView : UIView
{
    
}
@property(nonatomic,weak)IBOutlet UIImageView *iv_bg;
@property(nonatomic,weak)IBOutlet UILabel *lb_title;
@property(nonatomic,weak)IBOutlet UILabel *lb_subtitle;
@property(nonatomic,weak)IBOutlet UILabel *lb_description;
@property(nonatomic,weak)IBOutlet UIView *view_seperatorLine_h;
@property(nonatomic,weak)IBOutlet FGCustomButton *cb_go2Detail;
@property(nonatomic,weak)IBOutlet UIImageView *iv_thumbnail;
@property(nonatomic,strong)NSString *str_id;
-(void)bindDataToUI_gym:(NSMutableDictionary *)_dic_info;
-(void)bindDataToUI_group:(NSMutableDictionary *)_dic_info;
@end
