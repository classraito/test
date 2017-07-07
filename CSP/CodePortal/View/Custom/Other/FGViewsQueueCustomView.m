//
//  FGImageQueueCustomView.m
//  CSP
//
//  Created by Ryan Gong on 16/9/21.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGViewsQueueCustomView.h"
#import "UIImageView+Circle.h"
@interface FGViewsQueueCustomView()
{
    NSMutableArray *arr_images;
}
@end


@implementation FGViewsQueueCustomView
@synthesize increaseMode;
#pragma mark - 生命周期
-(void)awakeFromNib
{
    [super awakeFromNib];
    self.view_content.backgroundColor = [UIColor clearColor];
    
}

-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
    arr_images = nil;
}

-(void)updateHighliteByCount:(NSInteger)_highlightCount
{
    for(int i=0;i<_highlightCount;i++)
    {
        UIImageView *iv = [arr_images objectAtIndex:i];
        iv.highlighted = YES;
    }
  
  [self setNeedsDisplay];
}

-(void)resetImage
{
    for(UIView *_subView in self.subviews)
    {
        if([_subView isKindOfClass:[UIImageView class]])
        {
            [_subView removeFromSuperview];
        }
    }
}

-(NSMutableArray *)initalQueueByImageNames:(NSArray *)_arr_imgNames  highlightedImageNames:(NSArray *)_arr_imgNames_highlighted padding:(CGFloat)_padding imgBounds:(CGRect)_imgBounds  increaseMode:(ViewsQueueIncreaseMode)_increaseMode
{
    [self resetImage];
        arr_images = nil;
         arr_images = [[NSMutableArray alloc] init];
        int index = 0;
        for(NSString *_str_imgName in _arr_imgNames)
        {
            if(index == 8)
                break;
            
            
            UIImage *img = nil;
            UIImageView *iv = nil;
            if([_str_imgName hasPrefix:@"http"])
            {
                iv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _imgBounds.size.width, _imgBounds.size.height)];
              [iv sd_setImageWithURL:[NSURL URLWithString:_str_imgName] placeholderImage:IMGWITHNAME(@"dot") completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                iv.backgroundColor = [UIColor clearColor];
              }];
            }
            else
            {
                img = [UIImage imageNamed:_str_imgName];
                if([_str_imgName isEqualToString:@""])
                {
                    iv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _imgBounds.size.width, _imgBounds.size.height)];
                  iv.backgroundColor = [UIColor clearColor];//rgba(230, 230, 230, 1);
                }
                else
                {
                    iv = [[UIImageView alloc] initWithImage:img];
                    iv.frame = CGRectMake(0, 0, _imgBounds.size.width, _imgBounds.size.height);
                }
                
            }
            
            if(_arr_imgNames_highlighted && [_arr_imgNames_highlighted count]>0)
            {
                NSString *_str_imgNameHighlighted = [_arr_imgNames_highlighted objectAtIndex:index];
                UIImage *img_highlighted = [UIImage imageNamed:_str_imgNameHighlighted];
                iv.highlightedImage = img_highlighted;
                
            }
                    
          iv.contentMode = UIViewContentModeScaleAspectFill;
            [arr_images addObject:iv];
            index ++;
        }
    [self initalQueueByViews:arr_images padding:_padding increaseMode:_increaseMode];
    return arr_images;
}

-(void)initalQueueByViews:(NSArray *)_arr_views padding:(CGFloat)_padding increaseMode:(ViewsQueueIncreaseMode)_increaseMode
{
    increaseMode = _increaseMode;
    CGFloat dirX = 0;
    CGFloat dirY = 0;
    CGFloat dx = 0,dy = 0;
    
    int index = 0;
    for(UIView *_view in _arr_views)
    {
        if(index == 0)
        {
            switch (increaseMode) {
                case ViewsQueueIncreaseMode_LEFT:
                    dirX = -1;
                    dirY=0;
                    dx = self.frame.size.width - _view.frame.size.width;
                    break;
                    
                case ViewsQueueIncreaseMode_RIGHT:
                    dirX = 1;
                    dirY = 0;
                    dx = 0;//居左对齐
                    
                    break;
                    
                case ViewsQueueIncreaseMode_CENTER:
                    dirX = 1;
                    dirY = 0;
                    //居中对齐
                    dx = (self.frame.size.width-(_arr_views.count * _view.frame.size.width + (_arr_views.count-1) * _padding))/2;
                    break;
                    
                case ViewsQueueIncreaseMode_UP:
                    dirX = 0;
                    dirY = -1;
                    dy = self.frame.size.height - _view.frame.size.height;
                    break;
                    
                case ViewsQueueIncreaseMode_DOWN:
                    dirX = 0;
                    dirY = 1;
                    dy = 0;
                    break;
            }
        }
        

        
        [self addSubview:_view];
        
        CGRect _frame = _view.frame;
        _frame.origin.x = dx;
        _frame.origin.y = dy;
        _view.frame = _frame;
        
        if(dirX != 0)
        {
             dx += (_view.frame.size.width + _padding)*dirX;
            
            _view.center = CGPointMake(_view.center.x, self.frame.size.height / 2);
        }
        
        if(dirY != 0)
        {
            dy += (_view.frame.size.height + _padding)*dirY;
             _view.center = CGPointMake(self.frame.size.width / 2, _view.center.y);
        }
        
        index++;
    }
   
}

@end
