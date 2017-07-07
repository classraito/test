//
//  PathMacros.h
//  CSP
//
//  Created by JasonLu on 16/8/29.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#ifndef PathMacros_h
#define PathMacros_h

#pragma mark - 文件目录
#define kPathTemp           NSTemporaryDirectory()
#define kPathDocument       [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define kPathCache          [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]

#endif /* PathMacros_h */
