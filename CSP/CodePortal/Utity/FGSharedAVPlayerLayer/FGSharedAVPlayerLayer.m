//
//  FGSharedAVPlayerLayer.m
//  CSP
//
//  Created by Ryan Gong on 16/11/21.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGSharedAVPlayerLayer.h"
#define POOLSIZE 4

@interface FGSharedAVPlayerLayer()
{
    
}
@end

FGSharedAVPlayerLayer *model_playerLayer;
@implementation FGSharedAVPlayerLayer
@synthesize arr_playerLayerPool;
@synthesize currentIndexInPool;
#pragma mark - 生命周期
+(FGSharedAVPlayerLayer *)sharedModel
{
    @synchronized(self)     {
        if(!model_playerLayer)
        {
            model_playerLayer=[[FGSharedAVPlayerLayer alloc]init];
            model_playerLayer.arr_playerLayerPool = [[NSMutableArray alloc] initWithCapacity:1];
            for(int i=0;i<POOLSIZE;i++)
            {
                AVPlayerLayer *_playerLayer = [model_playerLayer internalInitalPlayerLayer];
                [model_playerLayer.arr_playerLayerPool addObject:_playerLayer];
                model_playerLayer.currentIndexInPool = -1;
            }
            return model_playerLayer;
        }
    }
    return model_playerLayer;
}

-(id)init
{
    if(self = [super init])
    {
        
        
    }
    return self;
}

+(id)alloc
{
    @synchronized(self)     {
        NSAssert(model_playerLayer == nil, @"企圖重复創建一個singleton模式下的FGSharedAVPlayerLayer");
        return [super alloc];
    }
    return nil;
}

-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
    [self clearAVPlayerLayerPool];
}
#pragma mark - 初始化
-(AVPlayerLayer *)internalInitalPlayerLayer
{
    AVPlayer *player = [[AVPlayer alloc]initWithPlayerItem:nil];
    player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
    [playerLayer.player pause];
    playerLayer.player.actionAtItemEnd = AVPlayerActionAtItemEndPause;
    playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    playerLayer.backgroundColor = [UIColor blackColor].CGColor;
    [playerLayer.player setMuted:YES];
    return playerLayer;
}

-(AVPlayerLayer *)giveMeSharedPlayerLayer
{
    if(!arr_playerLayerPool)
        return nil;
    if([arr_playerLayerPool count]<=0)
        return nil;
    currentIndexInPool = currentIndexInPool < POOLSIZE - 1 ? currentIndexInPool + 1 : 0;
    AVPlayerLayer *_sharedPlayerLayer = [arr_playerLayerPool objectAtIndex:currentIndexInPool];
    
    return _sharedPlayerLayer;
}


-(void)addPlayerLayer:(AVPlayerLayer *)_playerLayer toVideoContainerView:(UIView *)_view_videoContainer
{
    [_view_videoContainer.layer insertSublayer:_playerLayer atIndex:0];
    _playerLayer.frame = _view_videoContainer.bounds;
    
        if(_playerLayer.player.status == AVPlayerItemStatusReadyToPlay)
        {
            [_playerLayer.player.currentItem seekToTime: kCMTimeZero
                                             toleranceBefore: kCMTimeZero
                                              toleranceAfter: kCMTimeZero
                                           completionHandler: ^(BOOL finished)
             {
                 if(finished)
                 {
                     [_playerLayer.player play];
                 }
                 
             }];
        }
        else if(_playerLayer.player.status == AVPlayerItemStatusUnknown)
        {
            [_playerLayer.player play];
        }
}


-(void)clearAVPlayerLayerPool
{
    if(!arr_playerLayerPool)
        return;
    
    for(AVPlayerLayer *_playerLayer in self.arr_playerLayerPool)
    {
        if(_playerLayer.player.currentItem)
        {
            [_playerLayer.player pause];
                if(_playerLayer.player.status == AVPlayerItemStatusReadyToPlay)
                {
                    [_playerLayer.player.currentItem seekToTime: kCMTimeZero
                                               toleranceBefore: kCMTimeZero
                                                toleranceAfter: kCMTimeZero
                                             completionHandler: ^(BOOL finished)
                     {
                     }];
                }
            [_playerLayer removeFromSuperlayer];
            
        }
    }
    [self.arr_playerLayerPool removeAllObjects];
    self.arr_playerLayerPool = nil;
    
    
}

+(void)clearPlayerLayerModel
{
    if(!model_playerLayer)
        return;
    [model_playerLayer clearAVPlayerLayerPool];
    model_playerLayer = nil;
}
@end
