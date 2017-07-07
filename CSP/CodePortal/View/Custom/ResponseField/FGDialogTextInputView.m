//
//  EwenTextView.m
//  0621TextViewDemo
//
//  Created by apple on 16/6/21.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "FGDialogTextInputView.h"
#import "Masonry.h"
#import "Global.h"
#define kScreenBounds ([[UIScreen mainScreen] bounds])
#define kScreenwidth (kScreenBounds.size.width)
#define kScreenheight (kScreenBounds.size.height)
#define UIColorRGB(x,y,z) [UIColor colorWithRed:x/255.0 green:y/255.0 blue:z/255.0 alpha:1.0]
#define MaxTextViewHeight 80 * ratioH //限制文字输入的高度
@interface FGDialogTextInputView()<UITextViewDelegate,UIScrollViewDelegate>
{
    BOOL statusTextView;//当文字大于限定高度之后的状态
    NSString *placeholderText;//设置占位符的文字
    CGRect originalFrame;
}

@end


@implementation FGDialogTextInputView
@synthesize backGroundView;
@synthesize textView;
@synthesize placeholderLabel;
@synthesize sendButton;
@synthesize iv_thumbnail;
@synthesize delegate;
-(void)awakeFromNib
{
    [super awakeFromNib];
    
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)name:UIKeyboardWillShowNotification object:nil];
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [commond useDefaultRatioToScaleView:backGroundView];
    [commond useDefaultRatioToScaleView:textView];
    [commond useDefaultRatioToScaleView:placeholderLabel];
    [commond useDefaultRatioToScaleView:sendButton];
    [commond useDefaultRatioToScaleView:iv_thumbnail];
    
    placeholderLabel.font = font(FONT_TEXT_REGULAR, 16);
    textView.font = font(FONT_TEXT_REGULAR, 16);
    textView.textColor = [UIColor blackColor];
    backGroundView.layer.cornerRadius = 5;
    backGroundView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    backGroundView.layer.borderWidth = .5f;
    
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, -2);
    self.layer.shadowRadius = 10;
    self.layer.shadowOpacity = .2;
    
    [sendButton setTitle:multiLanguage(@"Send") forState:UIControlStateNormal];
    [sendButton setTitle:multiLanguage(@"Send") forState:UIControlStateHighlighted];
    sendButton.titleLabel.font = font(FONT_TEXT_REGULAR, 16);
    /**
     点击 空白区域取消
     */
    UITapGestureRecognizer *centerTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(centerTapClick)];
    [self addGestureRecognizer:centerTap];
    
    
}

-(void)clearMemory
{
    [textView clearMemory];
}

-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
    self.textView.delegate = nil;
    self.textView = nil;
}

- (void)setupUI{
    
    textView.delegate = self;
    [sendButton addTarget:self action:@selector(sendClick:) forControlEvents:UIControlEventTouchUpInside];
    [self textViewDidChange:textView];
    originalFrame = self.frame;
    [self.textView setupAttributesWithFont:textView.font textColor:textView.textColor];
    [self.textView setupMathPatternsWithArray:@[ @{@"key":@[@"@"],      @"linkPrefix":@"userid:", @"bgColor":[UIColor clearColor], @"font":font(FONT_TEXT_BOLD, 16),     @"color":color_red_panel},
                                              @{@"key":@[@"#",@"#"],    @"linkPrefix":@"",  @"bgColor":[UIColor clearColor], @"font":font(FONT_TEXT_BOLD, 16), @"color":color_red_panel}] maxLength:400];
}

//暴露的方法
- (void)setPlaceholderText:(NSString *)text{
    placeholderText = text;
    self.placeholderLabel.text = placeholderText;
}

-(void)adjustUILayoutBySelfFrame:(CGRect)_frame
{
    self.frame = _frame;
    
    
    CGRect __frame = backGroundView.frame;
    __frame.size.height = self.frame.size.height - 8 *ratioH;
    backGroundView.frame = __frame;
    
    __frame = textView.frame;
    __frame.size.height = backGroundView.frame.size.height;
    textView.frame = __frame;
    
    __frame = placeholderLabel.frame;
    __frame.origin.x = textView.frame.origin.x + 5;
    placeholderLabel.frame = __frame;
    
    __frame = iv_thumbnail.frame;
    __frame.origin.y = 5 *ratioH;
    iv_thumbnail.frame = __frame;
    
    backGroundView.center = CGPointMake(backGroundView.center.x, self.frame.size.height / 2);
    
    sendButton.center = CGPointMake(sendButton.center.x, self.frame.size.height / 2);
}

//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height ;
    if (self.textView.text.length == 0) {
        
        CGRect rect = CGRectMake(0, self.superview.frame.size.height - height - originalFrame.size.height, kScreenwidth,originalFrame.size.height);
        [self adjustUILayoutBySelfFrame:rect];
        
    }else{
        CGRect rect = CGRectMake(0, self.superview.frame.size.height - self.frame.size.height-height, kScreenwidth, self.frame.size.height);
        [self adjustUILayoutBySelfFrame:rect];
    }
    if(delegate && [delegate respondsToSelector:@selector(dialogDidOpenPad)])
    {
        [delegate dialogDidOpenPad];
    }
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
        CGRect rect = CGRectMake(0, self.superview.frame.size.height-self.frame.size.height, kScreenwidth, self.frame.size.height);
        [self adjustUILayoutBySelfFrame:rect];
    if(delegate && [delegate respondsToSelector:@selector(dialogDidClosePad)])
    {
        [delegate dialogDidClosePad];
    }
}

- (void)centerTapClick{
    [self.textView resignFirstResponder];
}

#pragma mark --- UITextViewDelegate
- (void)textViewDidChange:(UITextView *)_textView{
    
    /**
     *  设置占位符
     */
    if (_textView.text.length == 0) {
        self.placeholderLabel.text = placeholderText;
        [self.sendButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self.sendButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        self.sendButton.userInteractionEnabled = NO;
    }else{
        self.placeholderLabel.text = @"";
        [self.sendButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.sendButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        self.sendButton.userInteractionEnabled = YES;
    }
    
    //---- 计算高度 ---- //
    CGSize size = CGSizeMake(textView.frame.size.width, CGFLOAT_MAX);
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:textView.font,NSFontAttributeName, nil];
    CGFloat curheight = [_textView.text boundingRectWithSize:size
                                                    options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                 attributes:dic
                                                    context:nil].size.height;
    
    CGFloat y = CGRectGetMaxY(self.frame);
    CGRect rect;
    
    if (curheight < 17) {
        statusTextView = NO;
        rect = CGRectMake(0, y - self.frame.size.height, kScreenwidth, self.frame.size.height);
        [self adjustUILayoutBySelfFrame:rect];
    }else if(curheight < MaxTextViewHeight){
        statusTextView = NO;
        CGFloat selfHeight = _textView.contentSize.height + 8 * ratioH;
        rect = CGRectMake(0, y - selfHeight, kScreenwidth,selfHeight);
        [self adjustUILayoutBySelfFrame:rect];
    }else{
        statusTextView = YES;
        return;
    }
    
}

#pragma  mark -- 发送事件
- (void)sendClick:(UIButton *)sender{
    [self.textView endEditing:YES];
    if (delegate && [delegate respondsToSelector:@selector(dialogDidClickSend:)]) {
        [delegate dialogDidClickSend:textView.text];
    }
    
    self.textView.text = @"";
    [self.sendButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.sendButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    self.sendButton.userInteractionEnabled = NO;
    self.placeholderLabel.text = placeholderText;
    [self textViewDidChange:textView];
    [self closePad];
    
    
    
}

-(void)closePad
{
    //---- 发送成功之后清空 ------//
    [self.textView resignFirstResponder];
    [self keyboardWillHide:nil];
}


#pragma mark --- UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (statusTextView == NO) {
        scrollView.contentOffset = CGPointMake(0, 0);
    }else{
        
    }
}
@end
