//
//  skyStepperCell.h
//  skyInnerSX
//
//  Created by skyworth on 14-9-23.
//  Copyright (c) 2014年 wziiy. All rights reserved.
//

#import <UIKit/UIKit.h>

// class skyStepperCell --- 自定义带步进功能Cell
@interface skyStepperCell : UITableViewCell

//////////////////// Property ////////////////////////
@property (strong, nonatomic) IBOutlet UILabel *lableTitle;
@property (strong, nonatomic) IBOutlet UILabel *lableValue;
@property (strong, nonatomic) IBOutlet UIStepper *valueStepper;

//////////////////// Methods /////////////////////////

//////////////////// Ends ////////////////////////////

@end
