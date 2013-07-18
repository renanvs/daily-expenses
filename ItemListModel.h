//
//  ItemListModel.h
//  daily Expenses
//
//  Created by renan veloso silva on 02/07/13.
//  Copyright (c) 2013 renan veloso silva. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SpendItem.h"
#import "Config.h"

@interface ItemListModel : NSObject{
    NSString *newPlistFile;
}

@property (strong) NSMutableArray *listItens;
@property (strong) NSNumber *totalValue;

+(ItemListModel *) sharedInstance;

-(void)addItemToList:(SpendItem*)item;

-(SpendItem*)getSpendItemById:(NSNumber*)idValue;



@end
