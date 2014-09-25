//
//  skyStepperBtnCell.h
//  skyInnerSX
//
//  Created by skyworth on 14-9-25.
//  Copyright (c) 2014年 wziiy. All rights reserved.
//

#import <UIKit/UIKit.h>

// class skyStepperBtnCell --- 自定义带Stepper+Button控件的Cell
@interface skyStepperBtnCell : UITableViewCell

/////////////////// Property //////////////////////
@property (strong, nonatomic) IBOutlet UILabel *cellTitle;
@property (strong, nonatomic) IBOutlet UIStepper *cellStepper;
@property (strong, nonatomic) IBOutlet UIButton *cellBtn;
/////////////////// Ends //////////////////////////

@end
