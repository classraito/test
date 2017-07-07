//
//  FGAboutCell.m
//  可展开Cell
//
//  Created by PengLei on 17/1/20.
//  Copyright © 2017年 PengLei. All rights reserved.
//

#import "FGAboutCell.h"
#import "FAQModel.h"
#import "ConstValue.h"
#import "UIView+LineSpace.h"

@implementation FGAboutCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self initSubViews];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
//    [_vi_line reSetLineHeight];
    [_vi_line_bottom reSetLineHeight];
}

-(void)initSubViews
{
    _lb_question.font = KFrameContentTitleFont;
    _lb_question.textColor = [UIColor grayColor];
    
    _lb_answer.font = KFrameSubContentFont;
    _lb_answer.textColor = [UIColor blackColor];
    
    _lb_copyright.font = KFrameSubContentFont;
    _lb_copyright.textAlignment = NSTextAlignmentCenter;
    _lb_copyright.textColor = KFramefotoLatte;
    _lb_copyright.hidden = YES;
    
    _vi_line.backgroundColor = [UIColor grayColor];
    _vi_line_bottom.backgroundColor = [UIColor grayColor];;
    
    
    self.backgroundColor = [UIColor whiteColor];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)setStr_imageName:(NSString *)str_imageName
{
    _str_imageName = str_imageName;
    _imv_icon.image = [UIImage imageNamed:_str_imageName];

}

-(void)setStr_copyright:(NSString *)str_copyright
{
    _str_copyright = str_copyright;
    if (_str_copyright) {
        
        _imv_icon.hidden = YES;
        [self showCopyRightHidden:NO];
        _lb_copyright.text = _str_copyright;
        
    }
    else
    {
        [self showCopyRightHidden:YES];
        _lb_copyright.text = nil;
    }
}

-(void)showCopyRightHidden:(BOOL)_isHidden
{
    _lb_copyright.hidden = _isHidden;
        BOOL isNeedHidden = !_isHidden;
    _vi_line_bottom.hidden  = isNeedHidden;
    _lb_question.hidden     = isNeedHidden;
    _lb_answer.hidden       = isNeedHidden;
    _imv_arrow.hidden       = isNeedHidden;
//    _imv_icon.hidden        = isNeedHidden;
}


-(void)setFrame_model:(FAQFrameModel *)frame_model
{
    if(!frame_model)
    {
        return;
    }
    _frame_model = frame_model;
    FAQModel * model = _frame_model.model;
    
    CGFloat h_title = _frame_model.cellTitleH;
    CGRect _frame = _vi_line.frame;
    _frame.origin.y = h_title - 2;
    _vi_line.frame = _frame;
    
    _frame = _lb_question.frame;
    _frame.size.height = h_title;
    _lb_question.frame = _frame;
    
    CGPoint center = _imv_arrow.center;
    center.y = h_title/2;
    _imv_arrow.center = center;
    
    
    if (model.isOpen) {
        
        _imv_arrow.image = [UIImage imageNamed:@"icon-arrowup-mk"];
        
        //图片坐标 设置图片的大小（100，60），图片居中显示
        _imv_icon.hidden = NO;
        _frame = _imv_icon.frame;
        _frame.size.width = 100 *ratioW;
        _frame.size.height = 60 * ratioH;
        _frame.origin.y = h_title + 5*ratioH;
        _frame.origin.x = (KMainWidth - 100*ratioW)/2;
        _imv_icon.frame = _frame;
       
        //详情坐标
        CGFloat y_position = h_title + 5*ratioH + CGRectGetHeight(_frame);
        _frame = _lb_answer.frame;
        _frame.origin.y = y_position + 5*ratioH;
        _frame.size.height = CGRectGetHeight(self.frame) - h_title - 15*ratioH -60*ratioH;
        _lb_answer.frame = _frame;
        _lb_answer.text =  model.str_context;
        _lb_answer.hidden = NO;
//        _vi_line.hidden = NO;
    
    }
    else
    {
        _imv_arrow.image = [UIImage imageNamed:@"icon-arrowdown-mk"];
        _lb_answer.frame = CGRectMake(15, h_title, KMainWidth - 30, 0);
        _lb_answer.text = @"";
        _lb_answer.hidden = YES;
//        _vi_line.hidden = YES;
        _imv_icon.hidden = YES;
    }
    
}

@end
