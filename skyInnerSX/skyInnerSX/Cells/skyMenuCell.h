//
//  skyMenuCell.h
//  skyInnerSX
//
//  Created by skyworth on 14-9-25.
//  Copyright (c) 2014年 wziiy. All rights reserved.
//

#import <UIKit/UIKit.h>

// class skyMenuCell --- 自定义虚拟键盘Cell
@interface skyMenuCell : UITableViewCell

///////////////////// Property ////////////////////////
@property (strong, nonatomic) IBOutlet UIButton *menuBtn;
@property (strong, nonatomic) IBOutlet UIButton *upBtn;
@property (strong, nonatomic) IBOutlet UIButton *downBtn;
@property (strong, nonatomic) IBOutlet UIButton *leftBtn;
@property (strong, nonatomic) IBOutlet UIButton *rightBtn;
@property (strong, nonatomic) IBOutlet UIButton *panelBtn;
@property (strong, nonatomic) IBOutlet UIButton *signalBtn;
@property (strong, nonatomic) IBOutlet UIButton *confirmBtn;
@property (strong, nonatomic) IBOutlet UIButton *quitBtn;
///////////////////// Ends /////////////////////////////

@end
