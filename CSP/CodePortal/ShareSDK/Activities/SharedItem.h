//
//  SharedItem.h
//  CSP
//
//  Created by JasonLu on 17/1/13.
//  Copyright © 2017年 Fugumobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SharedItem : NSObject <UIActivityItemSource>
//-(instancetype)initWithData:(UIImage*)img andFile:(NSURL*)file;
-(instancetype)initWithData:(UIImage *)img andFile:(NSURL *)file andTitle:(NSString *)title;
@property (nonatomic, strong) UIImage *img;
@property (nonatomic, strong) NSURL *path;
@property (nonatomic, copy)   NSString *title;
@end
