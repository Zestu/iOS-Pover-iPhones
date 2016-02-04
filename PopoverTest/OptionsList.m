//
//  OptionsList.m
//  PopoverTest
//
//  Created by Zestug on 2/4/16.
//  Copyright © 2016 Zestug. All rights reserved.
//

#import "OptionsList.h"

@implementation OptionsList

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initialize];
    }
    
    return self;
}

-(instancetype)init
{
    if (self = [super init]) {
        [self initialize];
    }
    return self;
}

-(void)initialize
{
    self.delegate = self;
    self.dataSource = self;
    self.tintColor = [UIColor greenColor];
    self.scrollEnabled = NO;
    
    _data = @[@(1), @(2), @(3)];
    
    [self registerNib:[UINib nibWithNibName:@"OptionItem" bundle:nil] forCellReuseIdentifier:@"rOption"];
}

-(void)reestimateSize
{
    CGRect newFrame = self.frame;
    newFrame.size.height = [_data count] * [self dequeueReusableCellWithIdentifier:@"rOption"].frame.size.height;
    self.frame = newFrame;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_data count];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.optionsSelector && [self.optionsSelector respondsToSelector:@selector(optionSelected)])
    {
        [self.optionsSelector optionSelected];
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"rOption"];
    
    if (indexPath.row == [_data count] - 1) {
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, CGRectGetWidth(tableView.bounds));
    }
    
    return cell;
}

@end


@implementation OptionCell

@end