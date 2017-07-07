//
//  NSMutableArray+ReplaceObject.m
//  CSP
//
//  Created by Ryan Gong on 17/2/3.
//  Copyright © 2017年 Fugumobile. All rights reserved.
//

#import "NSMutableArray+Utity.h"

@implementation NSMutableArray (Utity)
/*替换数组中 所有_obj 为  _newObj*/
-(void)replaceObject:(id)_obj withObj:(id)_newObj
{
    NSMutableArray *_arr_tmp = [self mutableCopy];
    int index = 0;
    for(id obj in _arr_tmp)
    {
        if([obj isEqual:_obj])
        {
            [self replaceObjectAtIndex:index withObject:_newObj];
        }
        index ++;
    }
    [_arr_tmp removeAllObjects];
    _arr_tmp = nil;
}

/*根据该数组的值 去除数组中重复的值并返回一个新的实例*/
-(NSMutableArray *)removeRepeatObj
{
    NSMutableArray *_arr_removeRepeat = [[NSMutableArray alloc] init];
    for (unsigned i = 0; i < [self count]; i++){
        if ([_arr_removeRepeat containsObject:[self objectAtIndex:i]] == NO){
            [_arr_removeRepeat addObject:[self objectAtIndex:i]];
        }
    }
    return _arr_removeRepeat;
}

/*返回所有和_obj相同元素的下标集合*/
-(NSIndexSet *)giveMeIndexSetsOfObject:(id)_obj
{
    NSIndexSet *indexSet = [self indexesOfObjectsWithOptions:NSEnumerationConcurrent passingTest:^BOOL(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([obj isEqual:_obj])
        {
            return YES;
        }
        return NO;
    }];
    
    return indexSet;

}
@end
