//
//  FAQFrameModel.m
//  Framafoto
//
//  Created by PengLei on 16/8/19.
//  Copyright © 2016年 PengLei. All rights reserved.
//

#import "FAQFrameModel.h"
#import "FAQModel.h"
#import "ConstValue.h"

static CGFloat KHEIGHT_NORMAL = 50;//设置cell 的默认高度

static CGFloat KHEIGHT_NORMAL_MORE = 70;//设置cell 的默认高度 如果title 有2行

static CGFloat KMARGIN_WIDTH_VALUE = 15;//title lable 距边框的位置

static CGFloat KMARGIN_WIDTH_VALUE2 = 25; //详情lable 距边框的位置

static CGFloat KIMAGEICON_HEIGHT = 60; //图片的高度

static CGFloat KHEIGHT_SPACE = 5; //间距

@implementation FAQFrameModel

-(void)setStr_title:(NSString *)str_title
{
    _str_title = [str_title copy];
    
}


/**
 获取title的高度，如果title有2行，高度自增20

 @return <#return value description#>
 */
-(CGFloat)cellTitleH
{
    if (_cellTitleH ==0) {
        
        NSString * str_line = @"Title one line";
        CGFloat height1 = [self getHeightWithString:str_line];
        
        CGFloat height_title = [self getTitleHeightWithString:_str_title];
        
        if (height_title > height1) {
            
            _cellTitleH = KHEIGHT_NORMAL_MORE*ratioH;
        }
        else{
            _cellTitleH = KHEIGHT_NORMAL*ratioH;
        }
    }
    return _cellTitleH;
}


/**
    计算title的高度

 @param str_content <#str_content description#>
 @return <#return value description#>
 */
-(CGFloat)getTitleHeightWithString:(NSString*)str_content
{
    CGFloat contentW = KMainWidth - KMARGIN_WIDTH_VALUE *2;
    CGFloat contentH = [str_content boundingRectWithSize:CGSizeMake(contentW, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:KFrameContentTitleFont,NSFontAttributeName,nil] context:nil].size.height;
    
    return contentH;
}


/**
    计算详情内容的高度  包含间距和图片的高度

 @param str_content <#str_content description#>
 @return <#return value description#>
 */
-(CGFloat)getHeightWithString:(NSString*)str_content
{
    CGFloat contentW = KMainWidth - KMARGIN_WIDTH_VALUE2 *2;
    CGFloat contentH = [str_content boundingRectWithSize:CGSizeMake(contentW, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:KFrameSubContentFont,NSFontAttributeName,nil] context:nil].size.height;
    
    return contentH + KIMAGEICON_HEIGHT*ratioH + KHEIGHT_SPACE*ratioH * 3;
}


-(void)setModel:(FAQModel *)model
{
    _model = model;
    
    NSString * str_content = _model.str_context;
    
    self.cellH = self.cellTitleH;
    if (_model.isOpen) {
        
        CGFloat contentH = [self getHeightWithString:str_content];
        self.cellH += contentH + 20*ratioH;
    }
    
}

@end
