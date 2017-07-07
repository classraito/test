//
//  FGSharedAVPlayerLayer.h
//  CSP
//
//  Created by Ryan Gong on 16/11/21.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FGSharedAVPlayerLayer : NSObject
{
    
}
@property(nonatomic,strong)NSMutableArray *arr_playerLayerPool;
@property NSInteger currentIndexInPool;
+(FGSharedAVPlayerLayer *)sharedModel;
+(void)clearPlayerLayerModel;
-(AVPlayerLayer *)giveMeSharedPlayerLayer;
-(void)addPlayerLayer:(AVPlayerLayer *)_playerLayer toVideoContainerView:(UIView *)_view_videoContainer;
@end
