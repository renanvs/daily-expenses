//
//  DailyView.h
//  daily Expenses
//
//  Created by renan veloso silva on 17/05/13.
//  Copyright (c) 2013 renan veloso silva. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DailyView : UIViewController <UITableViewDelegate, UITableViewDataSource>{
	IBOutlet UIView *portraitView;
	IBOutlet UIView *landscapeView;
}

@property (strong) IBOutlet UITableView *dailyTableView;
@property (strong) IBOutlet UIButton *addDailyItemButton;
@property (strong) IBOutlet UILabel *totalValue;
@property (strong) IBOutlet UISegmentedControl *changeViewTypeSegmentControl;
@property (strong) NSMutableArray *listItens;

-(IBAction)addDailyItem:(id)sender;
-(IBAction)settings:(id)sender;
-(IBAction)changeView:(id)sender;

@end
