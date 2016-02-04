//
//  PopoverView.h
//  PopoverTest
//
//  Created by Zestug on 2/3/16.
//  Copyright © 2016 Zestug. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopoverView : UIView

@property (strong, nonatomic) UIView* contentView;

-(void)presentArrowPointsTo:(CGPoint)point fromView:(UIView*)parent;

-(void)dismissPopover;

@end


@interface PopoverBack : UIView


@end