//
//  DailyView.h
//  daily Expenses
//
//  Created by Renan Veloso Silva on 23/07/13.
//  Copyright (c) 2013 renan veloso silva. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DailyView : UIView<UITableViewDelegate, UITableViewDataSource>{

}

@property (strong) IBOutlet UITableView *dailyTableView;
@property (strong) NSMutableArray *listItens;
@property (strong) IBOutlet UILabel *totalValue;


@end
