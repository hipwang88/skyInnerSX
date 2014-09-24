//
//  skySliderCell.h
//  skyInnerSX
//
//  Created by skyworth on 14-9-24.
//  Copyright (c) 2014年 wziiy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface skySliderCell : UITableViewCell

///////////////// Property ///////////////////
@property (strong, nonatomic) IBOutlet UILabel *labelTitle;
@property (strong, nonatomic) IBOutlet UILabel *labelValue;
@property (strong, nonatomic) IBOutlet UISlider *cellSilder;

///////////////// Ends ///////////////////////

@end
