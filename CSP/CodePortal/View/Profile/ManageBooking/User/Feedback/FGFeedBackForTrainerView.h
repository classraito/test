//
//  FGFeedBackForTrainerView.h
//  CSP
//
//  Created by JasonLu on 16/12/26.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGWriteFeedBackView.h"

@interface FGFeedBackForTrainerView : FGWriteFeedBackView
@property (nonatomic, strong, readonly) NSDictionary *dic_trainerInfo;
@property (weak, nonatomic) IBOutlet UILabel *lb_textViewPlaceHolder;
@property (weak, nonatomic) IBOutlet UIView *view_whiteBg;

- (void)setupViewWithTrainerInfo:(NSDictionary *)_dic_info;

- (NSInteger)ratingCount;
- (NSString *)reviewContent;
@end
