//
//  OptionsList.h
//  PopoverTest
//
//  Created by Zestug on 2/4/16.
//  Copyright © 2016 Zestug. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OptionCell;

@protocol OptionsSelector <NSObject>

-(void)optionSelected;

@end

@interface OptionsList : UITableView <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSArray* data;
@property (assign, nonatomic) id<OptionsSelector> optionsSelector;

-(void)reestimateSize;

@end

@interface OptionCell: UITableViewCell

@end