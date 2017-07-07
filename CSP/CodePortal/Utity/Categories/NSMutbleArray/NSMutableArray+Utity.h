//
//  NSMutableArray+ReplaceObject.h
//  CSP
//
//  Created by Ryan Gong on 17/2/3.
//  Copyright © 2017年 Fugumobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (Utity)
{
    
}
/*替换数组中 所有_obj 为  _newObj*/
-(void)replaceObject:(id)_obj withObj:(id)_newObj;

/*根据该数组的值 去除数组中重复的值并返回一个新的实例*/
-(NSMutableArray *)removeRepeatObj;

/*返回所有和_obj相同元素的下标集合*/
-(NSIndexSet *)giveMeIndexSetsOfObject:(id)_obj;
@end
