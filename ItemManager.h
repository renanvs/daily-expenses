//
//  ItemManager.h
//  daily Expenses
//
//  Created by renan veloso silva on 02/07/13.
//  Copyright (c) 2013 renan veloso silva. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ItemModel.h"
#import "Config.h"
#import "ItemFilter.h"

@interface ItemManager : NSObject{
    NSString *newPlistFile;
    bool hasLog;
    NSArray* monthList;
}

@property (strong) NSMutableArray *listItens;
@property (strong) NSMutableArray *allItens;
@property (strong) NSNumber *totalValue;
@property (strong) NSMutableString *totalValueStr;
@property (strong) NSString *dateInCurrentView;

+(ItemManager *) sharedInstance;

-(void)addItemToList:(ItemModel*)item;

-(ItemModel*)getSpendItemById:(NSString*)idValue;

-(void)removeItemBySpendItem :(ItemModel*)item;

-(void)updateItemToList:(ItemModel*)item;

-(void)getListDayBefore;

-(void)getListDayAfter;

-(NSArray*)getAvailableMonths;

-(NSDictionary*)getItensByMonthList:(NSArray*)monthListR;


@end
