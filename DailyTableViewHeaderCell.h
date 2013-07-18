//
//  DailyTableViewHeaderCell.h
//  daily Expenses
//
//  Created by renan veloso silva on 16/07/13.
//  Copyright (c) 2013 renan veloso silva. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DailyTableViewHeaderCell : UIViewController{
    UIImage *landImg;
    UIImage *portImg;
}

@property (assign) IBOutlet UIImageView *headerImg;

@end
