//
//  EwenTextView.h
//  0621TextViewDemo
//
//  Created by apple on 16/6/21.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol FGDialogTextInputViewDelegate<NSObject>
-(void)dialogDidClickSend:(NSString *)_str_textNeedToSend;
-(void)dialogDidOpenPad;
-(void)dialogDidClosePad;
@end

@interface FGDialogTextInputView : UIView
{
    
}
@property (nonatomic, weak)IBOutlet UIView *backGroundView;
@property (nonatomic, weak)IBOutlet UITextView *textView;
@property (nonatomic, weak)IBOutlet UILabel *placeholderLabel;
@property (nonatomic, weak)IBOutlet UIButton *sendButton;
@property(nonatomic,weak)IBOutlet UIImageView *iv_thumbnail;
@property(nonatomic,weak)id<FGDialogTextInputViewDelegate> delegate;
//------  设置占位符 ------//
- (void)setPlaceholderText:(NSString *)text;

/*需在外部调用*/
- (void)setupUI;
-(void)clearMemory;
-(void)closePad;
@end
