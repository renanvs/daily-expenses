//
//  MonthViewController.h
//  daily Expenses
//
//  Created by renan veloso silva on 20/08/13.
//  Copyright (c) 2013 renan veloso silva. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MonthViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>{
    NSArray* monthCollection;
    NSDictionary* itemByMonthDictionary;
}
- (IBAction)backBt:(id)sender;
- (IBAction)sharingBt:(id)sender;
@property (retain, nonatomic) IBOutlet UITableView *fullTable;

@end
