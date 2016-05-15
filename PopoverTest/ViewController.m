//
//  ViewController.m
//  PopoverTest
//
//  Created by Zestug on 2/3/16.
//  Copyright © 2016 Zestug. All rights reserved.
//

#import "ViewController.h"
#import "ZGPopoverView.h"
#import "OptionsList.h"

@interface ViewController () <OptionsSelector>

@property (strong, nonatomic) ZGPopoverView *popover;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    OptionsList* contentView = [[OptionsList alloc] initWithFrame:CGRectMake(0, 0, 165, 231)];
    [contentView reestimateSize];
    contentView.optionsSelector = self;
    
    self.popover = [[ZGPopoverView alloc] init];
    self.popover.contentView = contentView;
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *aTouch = [touches anyObject];
    [self.popover presentArrowPointsTo:[aTouch locationInView:self.view] fromView:self.view];
}

-(void)optionSelected
{
    [self.popover dismissPopover];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
