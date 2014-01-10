//
//  ItemManager.h
//  daily Expenses
//
//  Created by renan veloso silva on 02/07/13.
//  Copyright (c) 2013 renan veloso silva. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Config.h"
#import "ItemFilter.h"
#import "ItemModelC.h"

@interface ItemManager : NSObject{
    NSString *newPlistFile;
    bool hasLog;
    NSArray* monthList;
    
    NSManagedObjectContext *context;
}

@property (readonly ,strong) NSManagedObjectContext *context;

@property (strong) NSMutableArray *listItens;
@property (strong) NSMutableArray *allItens;
@property (strong) NSNumber *totalValue;
@property (strong) NSString *dateInCurrentView;

-(void)addItemToList:(ItemModelC*)item;

-(void)removeItemBySpendItem:(ItemModelC*)item;

-(void)updateItemToList:(ItemModelC*)item;

-(void)getListDayBefore;

-(void)getListDayAfter;

-(ItemModelC*)getSpendItemById:(NSString*)idValue;

-(NSArray*)getAvailableMonths;

-(NSDictionary*)getItensByMonthList:(NSArray*)monthListR;

+(ItemManager *) sharedInstance;

@end