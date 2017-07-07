//
//  FAQFrameModel.h
//  Framafoto
//
//  Created by PengLei on 16/8/19.
//  Copyright © 2016年 PengLei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@class FAQModel;
@interface FAQFrameModel : NSObject

@property (nonatomic,copy) NSString * str_title;

@property (nonatomic,strong) FAQModel * model;

@property (nonatomic,assign) CGFloat cellH;

@property (nonatomic,assign) CGFloat cellTitleH;
@end
