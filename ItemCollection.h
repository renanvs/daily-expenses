//
//  itemCollection.h
//  daily Expenses
//
//  Created by renan veloso silva on 02/07/13.
//  Copyright (c) 2013 renan veloso silva. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SpendItem.h"
#import "Config.h"
#import "FilterItens.h"

@interface ItemCollection : NSObject{
    NSString *newPlistFile;
    bool hasLog;
    NSArray* monthList;
}

@property (strong) NSMutableArray *listItens;
@property (strong) NSMutableArray *allItens;
@property (strong) NSNumber *totalValue;
@property (strong) NSMutableString *totalValueStr;
@property (strong) NSString *dateInCurrentView;

+(ItemCollection *) sharedInstance;

-(void)addItemToList:(SpendItem*)item;

-(SpendItem*)getSpendItemById:(NSString*)idValue;

-(void)removeItemBySpendItem :(SpendItem*)item;

-(void)updateItemToList:(SpendItem*)item;

-(void)getListDayBefore;

-(void)getListDayAfter;

-(NSArray*)getAvailableMonths;

-(NSDictionary*)getItensByMonthList:(NSArray*)monthListR;


@end
