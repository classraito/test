//
//  FGBookingCancelCoursePopView.h
//  CSP
//
//  Created by JasonLu on 16/12/23.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGBookingAcceptCourseBetweenTwoPopView.h"
@interface FGBookingCancelCoursePopView : FGBookingAcceptCourseBetweenTwoPopView
@property (weak, nonatomic) IBOutlet UIImageView *iv_userAvatar;
@property (weak, nonatomic) IBOutlet UILabel *lb_userName;

- (void)setupViewWithInfo:(NSDictionary *)_dic;
@end
