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
}

@property (strong) NSMutableArray *listItens;
@property (strong) NSMutableArray *allItens;
@property (strong) NSNumber *totalValue;

+(ItemCollection *) sharedInstance;

-(void)addItemToList:(SpendItem*)item;

-(SpendItem*)getSpendItemById:(NSString*)idValue;

-(void)removeItemByIndexPath :(NSInteger)index;

-(void)updateItemToList:(SpendItem*)item;


@end
