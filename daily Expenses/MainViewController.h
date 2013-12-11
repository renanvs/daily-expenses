//
//  MainView.h
//  daily Expenses
//
//  Created by renan veloso silva on 17/05/13.
//  Copyright (c) 2013 renan veloso silva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MonthViewController.h"

@interface MainViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>{
	IBOutlet UIView *portraitView;
	IBOutlet UIView *landscapeView;
    NSString *dateValue;
    NSString * totalValueStr;
}

@property (strong) NSMutableArray *listItens;
@property (strong) NSMutableArray *allItens;

@property (strong) IBOutlet UIButton *addDailyItemButton;
@property (strong) IBOutlet UITableView *dailyTableView;
@property (strong) IBOutlet UILabel *totalValue;
@property (strong) IBOutlet UILabel *currentDate;
@property (strong) IBOutlet UIButton *goNextButton;
@property (strong) IBOutlet UIButton *goBeforeButton;

- (IBAction)addDailyItem:(id)sender;
- (IBAction)goToDayBefore:(id)sender;
- (IBAction)goToDayAfter:(id)sender;
- (IBAction)showRelatorio:(id)sender;

@end
