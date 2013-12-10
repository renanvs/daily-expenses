//
//  SettingsViewController.h
//  daily Expenses
//
//  Created by renan veloso silva on 19/05/13.
//  Copyright (c) 2013 renan veloso silva. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong) IBOutlet UITableView *tableView;

-(IBAction)done:(id)sender;

@end
