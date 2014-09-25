//
//  skyPopBaseViewController.h
//  skyInnerSX
//
//  Created by skyworth on 14-9-23.
//  Copyright (c) 2014年 wziiy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface skyPopBaseViewController : UIViewController

// Cell图片
@property (strong, nonatomic) UIImage *rowImage;

// 载入响应函数
- (void)pushViewToFront;

@end
