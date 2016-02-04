//
//  CQPopoverBack.m
//  ConvivalQuiz
//
//  Created by Zestug on 5/15/15.
//
#import <QuartzCore/QuartzCore.h>
#import "PopoverView.h"

#define DEG_TO_RAD(angle) ((angle)/180.0f * M_PI)

#define BORDER 20.f
#define ARROW_BORDER 10.
#define ARROW_OFFSET 12.
#define ARROW_HEIGTH 15.
#define ARROW_BASE   25.

@interface PopoverView ()

@property (strong, nonatomic) PopoverBack *popoverBack;

@end

@implementation PopoverView

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
    
    self.popoverBack = [[PopoverBack alloc] init];
    self.popoverBack.backgroundColor = [UIColor clearColor];
    self.popoverBack.userInteractionEnabled = YES;
    
    [self.popoverBack setNeedsDisplay];
    [self addSubview:self.popoverBack];
}

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

-(void)presentArrowPointsTo:(CGPoint)point fromView:(UIView*)parent
{
    [self dismissPopover];
    
    CGPoint convertedPoint = [parent convertPoint:point toView:nil];
    
    CGRect replacedFrame = self.popoverBack.frame;
    replacedFrame.origin.x = convertedPoint.x - self.popoverBack.frame.size.width + ARROW_OFFSET + ARROW_BASE / 2 + ARROW_BORDER / 2;
    replacedFrame.origin.y = convertedPoint.y - self.popoverBack.frame.size.height;
    self.popoverBack.frame = replacedFrame;
    
    self.backgroundColor = [UIColor clearColor];
    self.popoverBack.alpha = 0;
    
    [[[UIApplication sharedApplication].delegate window].rootViewController.view addSubview:self];
    
    [UIView animateWithDuration:0.35 animations:^{
        self.popoverBack.alpha = 1;
        //self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    }];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *aTouch = [touches anyObject];
    CGPoint location = [aTouch locationInView:self];
    UIView* v = [self hitTest:location withEvent:nil];
    
    if (v != self.popoverBack) {
        [self dismissPopover];
    }
}

-(void)dismissPopover
{
    [self removeFromSuperview];
}

@end

@implementation PopoverBack

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self setNeedsDisplay];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [self setNeedsDisplay];
}

-(void)setNeedsDisplay
{
    [super setNeedsDisplay];
    
    self.layer.masksToBounds = NO;
    self.layer.shadowOffset = CGSizeMake(2, 2);
    self.layer.shadowRadius = 5;
    self.layer.shadowOpacity = 0.3;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGColorRef col = [UIColor whiteColor].CGColor;
    CGColorRef bcol = [UIColor whiteColor].CGColor;
    CGContextSetFillColorWithColor(c, col);
    CGContextSetStrokeColorWithColor(c, bcol);
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
    
    UIBezierPath *bezierPathArrow = [self drawArrowPath:inset];
    [bezierPathArrow closePath];
    
    CGContextSetLineWidth(c, ARROW_BORDER);
    CGContextAddPath(c, bezierPathArrow.CGPath);
    CGContextStrokePath(c);
    CGContextAddPath(c, bezierPathArrow.CGPath);
    CGContextFillPath(c);
}

-(UIBezierPath *)drawMainFramePath:(CGFloat)inset
{
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:(CGPoint){ inset, inset }];
    [bezierPath addLineToPoint:(CGPoint){ self.frame.size.width - inset, inset }];
    [bezierPath addLineToPoint:(CGPoint){ self.frame.size.width - inset, self.frame.size.height - inset - ARROW_HEIGTH }];
    [bezierPath addLineToPoint:(CGPoint){ inset, self.frame.size.height - inset - ARROW_HEIGTH }];
    [bezierPath addLineToPoint:(CGPoint){ inset, inset }];
    
    return bezierPath;
}

-(UIBezierPath *)drawArrowPath:(CGFloat)inset
{
    UIBezierPath *bezierPathArrow = [UIBezierPath bezierPath];
    inset = ARROW_BORDER / 2.f;
    [bezierPathArrow moveToPoint:(CGPoint){ self.frame.size.width - inset - ARROW_OFFSET - ARROW_BASE / 2, self.frame.size.height - inset }];
    [bezierPathArrow addLineToPoint:(CGPoint){ self.frame.size.width - inset - ARROW_OFFSET, self.frame.size.height - inset - ARROW_HEIGTH }];
    [bezierPathArrow addLineToPoint:(CGPoint){ self.frame.size.width - inset - ARROW_OFFSET - ARROW_BASE, self.frame.size.height - inset - ARROW_HEIGTH }];
    
    return bezierPathArrow;
}

@end
