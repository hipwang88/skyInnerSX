//
//  skyMenuCell.m
//  skyInnerSX
//
//  Created by skyworth on 14-9-25.
//  Copyright (c) 2014年 wziiy. All rights reserved.
//

#import "skyMenuCell.h"

@implementation skyMenuCell

- (void)awakeFromNib {
    // Initialization code
    [self.menuBtn setTitle:NSLocalizedString(@"UnitControl_Menu", nil) forState:UIControlStateNormal];
    [self.upBtn setTitle:NSLocalizedString(@"UnitControl_UP", nil) forState:UIControlStateNormal];
    [self.downBtn setTitle:NSLocalizedString(@"UnitControl_Down", nil) forState:UIControlStateNormal];
    [self.leftBtn setTitle:NSLocalizedString(@"UnitControl_Left", nil) forState:UIControlStateNormal];
    [self.rightBtn setTitle:NSLocalizedString(@"UnitControl_Right", nil) forState:UIControlStateNormal];
    [self.panelBtn setTitle:NSLocalizedString(@"UnitControl_Dis", nil) forState:UIControlStateNormal];
    [self.signalBtn setTitle:NSLocalizedString(@"UnitControl_Signal", nil) forState:UIControlStateNormal];
    [self.confirmBtn setTitle:NSLocalizedString(@"UnitControl_Confirm", nil) forState:UIControlStateNormal];
    [self.quitBtn setTitle:NSLocalizedString(@"UnitControl_Exit", nil) forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
