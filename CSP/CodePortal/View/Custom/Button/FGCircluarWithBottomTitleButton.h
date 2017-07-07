//
//  FGCircluarWithBottomTitleButton.h
//  CSP
//
//  Created by JasonLu on 16/10/8.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGAlignmentLabel.h"
#import "FGCircularButton.h"
#import "FGCustomizableBaseView.h"

@interface FGCircluarWithBottomTitleButton : FGCustomizableBaseView
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (weak, nonatomic) IBOutlet FGAlignmentLabel *lb_title;
@property (weak, nonatomic) IBOutlet UIImageView *vi_icon;
@property (assign, nonatomic) CGFloat processPercent;
- (void)setupButtonInfoWithTitle:(NSString *)title titleColor:(UIColor *)titleColor titleAlignment:(VerticalAlignment)alignment textAlignment:(NSTextAlignment)textAlignment buttonImage:(UIImage *)image;
- (void)setupButtonInfoWithTitle:(NSString *)title buttonImageName:(NSString *)imgName;
- (void)setupButtonInfoWithTitle:(NSString *)title titleColor:(UIColor *)titleColor titleAlignment:(VerticalAlignment)alignment buttonImageName:(NSString *)imgName;
- (void)setupButtonInfoWithTitle:(NSString *)title titleColor:(UIColor *)titleColor titleAlignment:(VerticalAlignment)alignment textAlignment:(NSTextAlignment)textAlignment buttonImageName:(NSString *)imgName;
- (void)setupStatusWithShowProcessBg:(BOOL)bgShow showProcess:(BOOL)procesShow;
- (void)setupButtonInfoWithImage:(UIImage *)_img;
@end
