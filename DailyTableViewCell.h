//
//  DailyTableViewCell.h
//  daily Expenses
//
//  Created by renan veloso silva on 18/05/13.
//  Copyright (c) 2013 renan veloso silva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpendItem.h"


@interface DailyTableViewCell : UITableViewCell{
    CGPoint point;
}
@property (assign) IBOutlet UILabel *price;
@property (assign) IBOutlet UILabel *label;
@property (assign) IBOutlet UIImageView *icon;
@property (assign) IBOutlet UIView *popoverView;
@property (assign) SpendItem *item;
@end
