//
//  CQPopoverBack.m
//  ConvivalQuiz
//
//  This is a base class of iPhones popover view
//
//  Created by Zestug on 5/15/16.

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ZGPopoverViewOutOfScreen) {
    ZGPopoverViewOutOfScreenNone,
    ZGPopoverViewOutOfScreenTop,
    ZGPopoverViewOutOfScreenRight,
    ZGPopoverViewOutOfScreenLeft,
};

@interface ZGPopoverView : UIView

@property (strong, nonatomic) UIView* contentView;

@property (assign, nonatomic) BOOL shadowDisabled;

-(void)presentArrowPointsTo:(CGPoint)point fromView:(UIView*)parent;

-(void)dismissPopover;

@end


@interface ZGPopoverBack : UIView

@property (assign, nonatomic) ZGPopoverViewOutOfScreen placedOutOffScreen;
@property (assign, nonatomic) CGPoint arrowPeak;

@property (assign) BOOL shadowDisabled;

@end