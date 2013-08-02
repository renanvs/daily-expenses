//
//  MainView.h
//  daily Expenses
//
//  Created by renan veloso silva on 17/05/13.
//  Copyright (c) 2013 renan veloso silva. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MainView : UIViewController <UITableViewDelegate, UITableViewDataSource>{
	IBOutlet UIView *portraitView;
	IBOutlet UIView *landscapeView;
    NSString *dateValue;
}

@property (strong) IBOutlet UIButton *addDailyItemButton;
@property (strong) IBOutlet UISegmentedControl *changeViewTypeSegmentControl;
/////
@property (strong) IBOutlet UITableView *dailyTableView;
@property (strong) NSMutableArray *listItens;
@property (strong) NSMutableArray *allItens;
@property (strong) IBOutlet UILabel *totalValue;
@property (strong) IBOutlet UILabel *currentDate;

-(IBAction)addDailyItem:(id)sender;
-(IBAction)settings:(id)sender;
-(IBAction)changeView:(id)sender;
- (IBAction)goToDayBefore:(id)sender;
- (IBAction)goToDayAfter:(id)sender;

@end
