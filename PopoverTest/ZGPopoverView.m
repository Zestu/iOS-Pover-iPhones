//
//  CQPopoverBack.m
//  ConvivalQuiz
//
//  This is a base class of iPhones popover view
//
//  TODO by priority:
//    + Popoverview shoudn't be placed out of borders
//    + Arrow should appear relative to a screen borders
//    - Border colors
//    - Popover back colors
//    - Show always on the root or inside parent borders
//
//  Created by Zestug on 5/15/16.

#import <QuartzCore/QuartzCore.h>
#import "ZGPopoverView.h"

#define DEG_TO_RAD(angle) ((angle)/180.0f * M_PI)

static CGFloat const BORDER       = 20.f;
static CGFloat const ARROW_BORDER = 10.f;
static CGFloat const ARROW_OFFSET = 12.f;
static CGFloat const ARROW_HEIGTH = 15.f;
static CGFloat const ARROW_BASE   = 25.f;
static CGFloat    HALF_ARROW_BASE = ARROW_BASE / 2;

static CGFloat const OFFSCREEN_OFFSET = 5.f; // Distance to offset popoverview in out-of-screen case

@interface ZGPopoverView ()

@property (strong, nonatomic) ZGPopoverBack *popoverBack;

@end

@implementation ZGPopoverView

#pragma mark - Initializers
// ---------------------------------- Initializers

-(void)awakeFromNib
{
    [self initialize];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        [self initialize];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {
        [self initialize];
    }
    
    return self;
}

-(void)initialize
{
    self.frame = [UIScreen mainScreen].bounds;
    
    // Popover is a full screen view and visible part only PopoverBack
    self.backgroundColor = [UIColor clearColor];
    self.popoverBack.alpha = 0;
    
    self.popoverBack = [[ZGPopoverBack alloc] init];
    self.popoverBack.backgroundColor = [UIColor clearColor];
    self.popoverBack.userInteractionEnabled = YES;
    
    [self.popoverBack setNeedsDisplay];
    [self addSubview:self.popoverBack];
}

// -------------------------------------------------

#pragma mark - Public initializer
// *Synthesized, Public. Used to set content view of the popover as a subview of a popoverback
-(void)setContentView:(UIView *)contentView
{
    CGRect convertedFrame = [self convertRect:contentView.frame toView:self];
    
    self.popoverBack.frame = CGRectMake(self.popoverBack.frame.origin.x, self.popoverBack.frame.origin.y,
                                        convertedFrame.size.width, convertedFrame.size.height + ARROW_HEIGTH);
    
    contentView.layer.masksToBounds = YES;
    contentView.layer.cornerRadius = BORDER / 2;
    
    [self.popoverBack addSubview:contentView];
    _contentView = contentView;
}

// Public. Controll shadow
-(void)setShadowDisabled:(BOOL)shadowDisabled
{
    _shadowDisabled = shadowDisabled;
    self.popoverBack.shadowDisabled = shadowDisabled;
}

#pragma mark - Public set point
// *Public. At this point inside a parent will be shown popover at its full dimensions
-(void)presentArrowPointsTo:(CGPoint)point fromView:(UIView*)parent
{
    // Remove old popover if present
    [self dismissPopover];
    
    self.popoverBack.placedOutOffScreen = ZGPopoverViewOutOfScreenNone;
    self.popoverBack.frame     = [self popoverBackFrameRect:point];
    self.popoverBack.arrowPeak = [parent convertPoint:point toView:self.popoverBack];
    
    // Place popover at the root of main window
    [[[UIApplication sharedApplication].delegate window].rootViewController.view addSubview:self];
    
    [self animateAppearence];
}

#pragma mark - presentArrowPointsTo
// ---------------------------------------------------- presentArrowPointsTo -> decompositon

// Change popover frame origin coordinates
-(CGRect)popoverBackFrameRect:(CGPoint)point
{
    CGRect replacedFrame = self.popoverBack.frame;
    CGPoint newOrigin    = [self findNewPopoverViewOrigin:point];
    
    replacedFrame.origin.x = newOrigin.x;
    replacedFrame.origin.y = newOrigin.y;
    
    return replacedFrame;
}

// Place popover inside screen borders
-(CGPoint)findNewPopoverViewOrigin:(CGPoint)point
{
    CGRect screenRect    = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth  = screenRect.size.width;
    
    // From right to left
    static CGFloat ARROW_X_DIST = ARROW_OFFSET + ARROW_BASE / 2 + ARROW_BORDER / 2;
    
    // Default origin
    CGFloat calculatedX = point.x - self.popoverBack.frame.size.width + ARROW_X_DIST;
    CGFloat calculatedY = point.y - self.popoverBack.frame.size.height;
    
    // X coordinate correction
    if (calculatedX < 0)
    {
        calculatedX = OFFSCREEN_OFFSET;
        self.popoverBack.placedOutOffScreen = ZGPopoverViewOutOfScreenLeft;
        
    } else if (point.x + ARROW_X_DIST > screenWidth)
    {
        calculatedX = screenWidth - self.popoverBack.frame.size.width - OFFSCREEN_OFFSET;
        self.popoverBack.placedOutOffScreen = ZGPopoverViewOutOfScreenRight;
    }
    
    // Y coordinate correction
    if (calculatedY < 0)
    {
        calculatedY = point.y;
        self.popoverBack.placedOutOffScreen = ZGPopoverViewOutOfScreenTop;
    }
    
    return CGPointMake(calculatedX, calculatedY);
}

// ------------------------------------------------------------------------------------------

// Animate appearance
-(void)animateAppearence
{
    [UIView animateWithDuration:0.35 animations:^{
        self.popoverBack.alpha = 1;
    }];
}

// Dismiss popover if touch was outside frame borders
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *aTouch = [touches anyObject];
    CGPoint location = [aTouch locationInView:self];
    UIView* v = [self hitTest:location withEvent:nil];
    
    if (v != self.popoverBack)
    {
        [self dismissPopover];
    }
}

-(void)dismissPopover
{
    [self removeFromSuperview];
}

@end

// Back view of the popover main frame
@implementation ZGPopoverBack

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    @try {
        // Replace content depending from the arrow direction
        UIView* contentView = [self subviews][0];
        if (contentView != nil)
        {
            CGRect newFrame = contentView.frame;
            newFrame.origin.y = ([self isArrowOnTop]) ? ARROW_HEIGTH + ARROW_BORDER / 2.f : 0;
            contentView.frame = newFrame;
        }
    } @catch (NSException *exception) {
    } @finally {
        [self setNeedsDisplay];
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [self setNeedsDisplay];
}

-(void)setNeedsDisplay
{
    [super setNeedsDisplay];
    
    if (!self.shadowDisabled)
    {
        self.layer.masksToBounds = NO;
        self.layer.shadowOffset  = CGSizeMake(2, 2);
        self.layer.shadowRadius  = 5;
        self.layer.shadowOpacity = 0.3;
    }
}

// Draws two parts of the popover main frame and arrow separately on the current context
-(void)drawRect:(CGRect)rect
{
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGColorRef col = [UIColor whiteColor].CGColor;
    CGColorRef bcol = [UIColor whiteColor].CGColor;
    CGContextSetFillColorWithColor(c, col);
    CGContextSetStrokeColorWithColor(c, bcol);
    // Popover smooth rounded borders
    CGContextSetLineJoin(c, kCGLineJoinRound);
    CGContextSetLineCap(c, kCGLineCapRound);
    CGContextSetLineWidth(c, BORDER);
    
    CGFloat inset = BORDER / 2.f;
    UIBezierPath *bezierPath = [self drawMainFramePath:inset];
    [bezierPath closePath];
    
    CGContextAddPath(c, bezierPath.CGPath);
    CGContextStrokePath(c);
    CGContextAddPath(c, bezierPath.CGPath);
    CGContextFillPath(c);
    
    inset = ARROW_BORDER / 2.f;
    UIBezierPath *bezierPathArrow = [self drawArrowPath:inset];
    [bezierPathArrow closePath];
    
    CGContextSetLineWidth(c, ARROW_BORDER);
    CGContextAddPath(c, bezierPathArrow.CGPath);
    CGContextStrokePath(c);
    CGContextAddPath(c, bezierPathArrow.CGPath);
    CGContextFillPath(c);
}

// Count and draw popover frame
-(UIBezierPath *)drawMainFramePath:(CGFloat)borderCap
{
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    
    CGFloat arrowOffset = self.frame.size.height - borderCap - ARROW_HEIGTH;
    
    CGFloat top    = ([self isArrowOnTop]) ? borderCap + ARROW_HEIGTH : arrowOffset;
    CGFloat left   = borderCap;
    CGFloat right  = self.frame.size.width - borderCap;
    CGFloat bottom = ([self isArrowOnTop]) ? arrowOffset : borderCap + ARROW_HEIGTH;
    
    [bezierPath moveToPoint:(CGPoint)   { left, top }];
    [bezierPath addLineToPoint:(CGPoint){ right, top }];
    [bezierPath addLineToPoint:(CGPoint){ right, bottom }];
    [bezierPath addLineToPoint:(CGPoint){ left, bottom }];
    [bezierPath addLineToPoint:(CGPoint){ left, top }];
    
    return bezierPath;
}

-(UIBezierPath *)drawArrowPath:(CGFloat)borderCap
{
    UIBezierPath *bezierPathArrow = [UIBezierPath bezierPath];
    
    // Adjust selected point in out-of-screen case
    [self updateArrowPeak];
    
    // Adjust arrow peak point according to the arrow direction
    CGPoint peak = CGPointMake(self.arrowPeak.x, self.arrowPeak.y);
          peak.y = ([self isArrowOnTop]) ? peak.y + borderCap : peak.y - borderCap;
    
    CGFloat sidesY = ([self isArrowOnTop]) ? peak.y + ARROW_HEIGTH : peak.y - ARROW_HEIGTH;
    
    CGPoint left  = CGPointMake(peak.x - HALF_ARROW_BASE, sidesY);
    CGPoint right = CGPointMake(peak.x + HALF_ARROW_BASE, sidesY);
    
    [bezierPathArrow moveToPoint:left];
    [bezierPathArrow addLineToPoint:peak];
    [bezierPathArrow addLineToPoint:right];
    
    return bezierPathArrow;
}

#pragma mark - Helpers
// Helpers
-(BOOL)isArrowOnTop
{
    return self.placedOutOffScreen == ZGPopoverViewOutOfScreenTop;
}

// Update arrow peak coordinate in case of it out of borders
-(void)updateArrowPeak
{
    CGPoint arrowPeakNew = self.arrowPeak;
    if (self.arrowPeak.x + HALF_ARROW_BASE > self.frame.size.width)
    {
        arrowPeakNew.x = self.frame.size.width - ARROW_BORDER / 2 - HALF_ARROW_BASE;
    }
    else if (self.arrowPeak.x - HALF_ARROW_BASE < 0)
    {
        arrowPeakNew.x = self.frame.origin.x + HALF_ARROW_BASE;
    }
    self.arrowPeak = arrowPeakNew;
}

@end