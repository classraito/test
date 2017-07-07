//
//  ConstValue.h
//  可展开Cell
//
//  Created by PengLei on 17/1/20.
//  Copyright © 2017年 PengLei. All rights reserved.
//

#ifndef ConstValue_h
#define ConstValue_h


////Helvetica Neue
#define KFamafotoMediumFont(value) [UIFont fontWithName:@"HelveticaNeue-Medium" size:value] //Medium
#define KFamafotoRegularFont(value) [UIFont fontWithName:@"HelveticaNeue" size:value] //Regular
#define KFamafotoInforLigFont(value) [UIFont fontWithName:@"HelveticaNeue-Light" size:value] //Regular

//小标题及按钮
#define KFrameContentTitleFont   font(FONT_TEXT_REGULAR, 17)
//具体内容
#define KFrameSubContentFont   font(FONT_TEXT_REGULAR, 14)


#define ratioW KMainWidth / 320.0f
#define ratioH KMainHeight / 568.0f

#define KMainWidth  [[UIScreen mainScreen] bounds].size.width
#define KMainHeight  [[UIScreen mainScreen] bounds].size.height

#define KFramefotoLatte [UIColor grayColor]

#define KFramefotoMocca [UIColor blackColor]
#endif /* ConstValue_h */
