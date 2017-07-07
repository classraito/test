//
//  FGPostEditPhotoView.m
//  CSP
//
//  Created by Ryan Gong on 16/10/26.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGPostEditPhotoView.h"
#import "Global.h"
#import "FGPostEditPhotoFilterCell.h"
#import "FGMoveableImageView.h"
#import "UIImage+SubImage.h"
#define DefaultStickerWidth 100 * ratioW
#define DefaultStickerHeight 100 * ratioH

#define DefaultStickerSize CGSizeMake(DefaultStickerWidth,DefaultStickerHeight)


@interface FGPostEditPhotoView()
{
    UIView *view_cursor;
    CGFloat _cellWidth ;
    EditType currentEditType;
    NSMutableArray *arr_filtedThumnail;
    NSMutableArray *arr_stickerImageNames;
    
    UIImage *orgImage;
}
@end

@implementation FGPostEditPhotoView
@synthesize img_edited;
@synthesize view_container;
@synthesize iv_needToEdit;
@synthesize sv_filterContainer;
@synthesize view_switchStickOrFilter;
@synthesize view_separator_stickerAndFilter;
@synthesize btn_filter;
@synthesize btn_sticker;
@synthesize btn_cancel;
@synthesize btn_next;
#pragma mark - 生命周期
-(void)awakeFromNib
{
    [super awakeFromNib];
    [commond useDefaultRatioToScaleView:view_container];
    [commond useDefaultRatioToScaleView:iv_needToEdit];
    [commond useDefaultRatioToScaleView:sv_filterContainer];
    [commond useDefaultRatioToScaleView:view_switchStickOrFilter];
    [commond useDefaultRatioToScaleView:view_separator_stickerAndFilter];
    [commond useDefaultRatioToScaleView:btn_filter];
    [commond useDefaultRatioToScaleView:btn_sticker];
    [commond useDefaultRatioToScaleView:btn_cancel];
    [commond useDefaultRatioToScaleView:btn_next];
   
    arr_filtedThumnail = [[NSMutableArray alloc] initWithCapacity:1];
    arr_stickerImageNames = [[NSMutableArray alloc] initWithCapacity:1];
    
    btn_cancel.titleLabel.font = font(FONT_TEXT_REGULAR, 16);
    btn_next.titleLabel.font = font(FONT_TEXT_REGULAR, 16);
    
    for(int i=0;i<15;i++)
    {
        [arr_stickerImageNames addObject:[NSString stringWithFormat:@"QuoteDesigns%d.png",i+1]];
        
    }
    
    for(int i=0;i<15;i++)
    {
        NSString *_str_filename;
        if([commond isChinese])
        {
            _str_filename = [NSString stringWithFormat:@"Quote%d_Chinese.png",i+1];
        }
        else
        {
            _str_filename = [NSString stringWithFormat:@"Quote%d.png",i+1];
        }
        [arr_stickerImageNames addObject:_str_filename];
    }
    
    
    sv_filterContainer.backgroundColor = [UIColor clearColor];
    currentEditType = EditType_Filter;
   
    
    btn_sticker.titleLabel.font = font(FONT_TEXT_REGULAR, 14);
    btn_filter.titleLabel.font = font(FONT_TEXT_REGULAR, 14);
    btn_cancel.titleLabel.font = font(FONT_TEXT_BOLD, 20);
    btn_next.titleLabel.font = font(FONT_TEXT_BOLD, 20);
    
    btn_next.layer.shadowOpacity = .8;
    btn_next.layer.shadowColor = [UIColor blackColor].CGColor;
    btn_next.layer.shadowOffset = CGSizeMake(0, 0);
    btn_next.layer.shadowRadius = 2;
    
    btn_cancel.layer.shadowOpacity = .8;
    btn_cancel.layer.shadowColor = [UIColor blackColor].CGColor;
    btn_cancel.layer.shadowOffset = CGSizeMake(0, 0);
    btn_cancel.layer.shadowRadius = 2;
    
    [btn_filter setTitle:multiLanguage(@"Filter") forState:UIControlStateNormal];
    [btn_filter setTitle:multiLanguage(@"Filter") forState:UIControlStateHighlighted];
    
    [btn_sticker setTitle:multiLanguage(@"Sticker") forState:UIControlStateNormal];
    [btn_sticker setTitle:multiLanguage(@"Sticker") forState:UIControlStateHighlighted];
    
    [btn_cancel setTitle:multiLanguage(@"CANCEL") forState:UIControlStateNormal];
    [btn_cancel setTitle:multiLanguage(@"CANCEL") forState:UIControlStateHighlighted];
    
    [btn_next setTitle:multiLanguage(@"NEXT") forState:UIControlStateNormal];
    [btn_next setTitle:multiLanguage(@"NEXT") forState:UIControlStateHighlighted];
    
    view_switchStickOrFilter.backgroundColor = [UIColor clearColor];
    view_container.layer.cornerRadius = 10;
    view_container.layer.masksToBounds = YES;
    
    UISwipeGestureRecognizer *_swipe_left = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeAction:)];
    _swipe_left.cancelsTouchesInView = YES;
    _swipe_left.direction = UISwipeGestureRecognizerDirectionLeft;
    
    UISwipeGestureRecognizer *_swipe_right = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeAction:)];
    _swipe_right.cancelsTouchesInView = YES;
    _swipe_right.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self addGestureRecognizer:_swipe_left];
    [self addGestureRecognizer:_swipe_right];
    _swipe_left = nil;
    _swipe_right = nil;

}

-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
    view_cursor = nil;
    orgImage = nil;
    arr_filtedThumnail = nil;
    arr_stickerImageNames = nil;
    img_edited = nil;
}

-(void)filterThumbnailImage
{
    [commond showLoading];
    for(int i=0;i<[[FGCIImageFilterTool sharedTool].arr_items count];i++)
    {
        
        UIImage *_tmpImg = [orgImage  rescaleImageToSize:CGSizeMake(80 * ratioW, 80 * ratioH * (orgImage.size.height / orgImage.size.width))];
        [arr_filtedThumnail addObject:[[FGCIImageFilterTool sharedTool] filterByImage:_tmpImg byFilterListIndex:i]];
        
    }
    [commond removeLoading];
}

#pragma mark - 初始化scroll view
-(void)internalInitalFilterOrStickerPanelByImageNames:(NSMutableArray *)_arr_img filterNames:(NSMutableArray *)_arr_filterNames
{
    [[sv_filterContainer subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    CGFloat _cursorY = 0;
    for(int i = 0; i < [_arr_img count]; i ++)
    {
        FGPostEditPhotoFilterCell *view_filterCell = (FGPostEditPhotoFilterCell *)[[[NSBundle mainBundle] loadNibNamed:@"FGPostEditPhotoFilterCell" owner:nil options:nil] objectAtIndex:0];
       
        
        if(_arr_filterNames && [_arr_filterNames count] > 0)
        {
            view_filterCell.lb_filterName.text = [[FGCIImageFilterTool sharedTool].arr_displayNames objectAtIndex:i];
            
            view_filterCell.lb_filterName.hidden = NO;
            view_filterCell.iv_filter.image = [_arr_img objectAtIndex:i];
        }
        else
        {
            view_filterCell.lb_filterName.hidden = YES;
             view_filterCell.iv_filter.image = [UIImage imageNamed:[_arr_img objectAtIndex:i]] ;
        }
        view_filterCell.btn_filter.tag = i + 1;
        [view_filterCell.btn_filter addTarget:self action:@selector(buttonAction_thumbnailClicked:) forControlEvents:UIControlEventTouchUpInside];
        [commond useDefaultRatioToScaleView:view_filterCell];
        CGRect _frame = view_filterCell.frame;
        _frame.origin.x = i * view_filterCell.frame.size.width;
        _frame.origin.y = 0;
        view_filterCell.frame = _frame;
        [sv_filterContainer addSubview:view_filterCell];
        _cellWidth = _frame.size.width;
        
        
        CGRect _labelRect = [view_filterCell.lb_filterName convertRect:view_filterCell.lb_filterName.frame toView:sv_filterContainer];
        _cursorY = _labelRect.origin.y + _labelRect.size.height - 4 * ratioH;
    }
    sv_filterContainer.contentSize = CGSizeMake([_arr_img count] * _cellWidth, sv_filterContainer.frame.size.height);
    view_cursor = [[UIView alloc] initWithFrame:CGRectMake(0, _cursorY, _cellWidth/2, 2)];
    view_cursor.backgroundColor = [UIColor whiteColor];
    view_cursor.center = CGPointMake(_cellWidth / 2, view_cursor.center.y);
    [sv_filterContainer addSubview:view_cursor];
}

-(void)updateSwitchTypeByEditType:(EditType)_editType
{
    if(currentEditType == _editType)
        return;
    sv_filterContainer.alpha = 0;
    
    if(currentEditType == EditType_Sticker)
    {
       [self internalInitalFilterOrStickerPanelByImageNames:arr_filtedThumnail filterNames:[FGCIImageFilterTool sharedTool].arr_items];
        view_cursor.hidden = NO;
    }
    else if(currentEditType == EditType_Filter)
    {
         [self internalInitalFilterOrStickerPanelByImageNames:arr_stickerImageNames filterNames:nil];
        view_cursor.hidden = YES;
    }
    
    [UIView animateWithDuration:.2 animations:^{
        
        CGRect _frame = view_switchStickOrFilter.frame;
        
        if(currentEditType == EditType_Sticker)
        {
            _frame.origin.x += view_switchStickOrFilter.frame.size.width / 2;
            
           
        }
        else if(currentEditType == EditType_Filter)
        {
            _frame.origin.x -= view_switchStickOrFilter.frame.size.width / 2;
           
        }
        view_switchStickOrFilter.frame = _frame;
        
        sv_filterContainer.alpha = 1;
        
    } completion:^(BOOL finished) {
        if(finished)
        {
            
            
        }
    }];
    currentEditType = _editType;
}

#pragma mark - 添加sticker
-(void)initAndAddStickerToContainer:(NSString *)_str_filename size:(CGSize )_stickerSize
{
    FGMoveableImageView *vi_sticker = nil;
    for(UIView *_subview in view_container.subviews)
    {
        if([_subview isKindOfClass:[FGMoveableImageView class]])
        {
            vi_sticker = (FGMoveableImageView *)_subview;
            break;
        }
    }//判断是否已经有贴纸
    
    if(vi_sticker)
    {
        vi_sticker.image = nil;
        vi_sticker.image = [UIImage imageNamed:_str_filename];
        vi_sticker.frame = CGRectMake(0, 0, _stickerSize.width, _stickerSize.height);
        vi_sticker.center = CGPointMake(view_container.frame.size.width/2, view_container.frame.size.height/2);
        
    }//有贴纸就替换贴纸
    else
    {
        vi_sticker = [[FGMoveableImageView alloc] initWithImage:[UIImage imageNamed:_str_filename]];
        vi_sticker.frame = CGRectMake(0, 0, _stickerSize.width, _stickerSize.height);
        vi_sticker.center = [self randomStickerPosition];
        [view_container addSubview:vi_sticker];
        vi_sticker = nil;
    }//没有贴纸就创建一个
}

#pragma mark - 这个方法返回一个随机的sticker的初始位置,它会尽量避免重叠
-(CGPoint)randomStickerPosition
{
    CGPoint _retVal = CGPointMake(view_container.frame.size.width/2, view_container.frame.size.height/2);
    NSInteger tryCount = 100;//尝试100次
    for(int i=0;i<tryCount;i++)
    {
        CGFloat _randomCenterX = arc4random() % (int)(view_container.frame.size.width - DefaultStickerWidth*2) + DefaultStickerWidth;
        CGFloat _randomCenterY = arc4random() % (int)(view_container.frame.size.height - DefaultStickerHeight*2) + DefaultStickerHeight;
        CGRect _randomFrame = CGRectMake(_randomCenterX - DefaultStickerWidth/2, _randomCenterY - DefaultStickerHeight/2, DefaultStickerWidth, DefaultStickerHeight);
        
        
        for(UIView *_subview in [view_container subviews])
        {
            if([_subview isKindOfClass:[FGMoveableImageView class]])
            {
                FGMoveableImageView *moveableIV = (FGMoveableImageView *)_subview;
                _retVal = CGPointMake(_randomCenterX, _randomCenterY);
                if(CGRectContainsRect(moveableIV.frame, _randomFrame))
                {
                    break;
                }
            }
        }
    }
    
    
    return _retVal;
}

-(UIImage *)getEditedImg
{
    view_container.layer.cornerRadius = 0;
    view_container.layer.masksToBounds = NO;
    img_edited = [UIImage imageFromView:view_container];
    view_container.layer.cornerRadius = 10;
    view_container.layer.masksToBounds = YES;
    return img_edited;
}

#pragma mark - 设置图片
-(void)setupNeedEditedImage:(UIImage *)_img
{
    iv_needToEdit.image = _img;
    orgImage = [iv_needToEdit.image copy];
    [self filterThumbnailImage];
    [self internalInitalFilterOrStickerPanelByImageNames:arr_filtedThumnail filterNames:[FGCIImageFilterTool sharedTool].arr_items];
    
    CGFloat height = view_container.frame.size.width * (orgImage.size.height / orgImage.size.width);
    CGFloat centerY = (view_container.frame.origin.y + view_container.frame.size.height) / 2;
    CGRect _frame = view_container.frame;
    _frame.size.height = height;
    view_container.frame = _frame;
    iv_needToEdit.frame = view_container.bounds;//按照图片比例设置 容器视图高度
    
    view_container.center = CGPointMake(view_container.center.x, centerY);//高度居中
    
}
#pragma mark - 交互
-(void)swipeAction:(UISwipeGestureRecognizer *)_sender
{
    if( _sender.direction == UISwipeGestureRecognizerDirectionLeft)
    {
        [self buttonAction_switchToSticker:nil];
    }
    else if( _sender.direction == UISwipeGestureRecognizerDirectionRight)
    {
        [self buttonAction_switchToFilter:nil];
    }
}

-(void)doFilteImage:(NSNumber *)_index
{
    iv_needToEdit.image = [[FGCIImageFilterTool sharedTool] filterByImage:orgImage byFilterListIndex:[_index integerValue]];
    [commond removeLoading];
}

-(void)buttonAction_thumbnailClicked:(UIButton *)_btn
{
    NSInteger index = _btn.tag - 1;
    
    if(currentEditType == EditType_Filter)
    {
        [UIView beginAnimations:nil context:nil];
        view_cursor.center = CGPointMake(_cellWidth / 2 + _cellWidth * index, view_cursor.center.y);
        [UIView commitAnimations];
        
        
        [commond showLoadingInView:iv_needToEdit];
        [self performSelector:@selector(doFilteImage:) withObject:[NSNumber numberWithInteger:index] afterDelay:.01];
        
        
    }
    else
    {
        
        NSString *_str_stickerName = [arr_stickerImageNames objectAtIndex:index];
        CGSize _stickerSize = DefaultStickerSize;
        if(index > 14)
            _stickerSize = CGSizeMake(150 * ratioW, 150 * ratioH);
        [self initAndAddStickerToContainer:_str_stickerName size:_stickerSize];
    }
    
   
    
}

-(IBAction)buttonAction_switchToSticker:(id)_sender;
{
    [self updateSwitchTypeByEditType:EditType_Sticker];
}

-(IBAction)buttonAction_switchToFilter:(id)_sender;
{
    [self updateSwitchTypeByEditType:EditType_Filter];
}

@end
