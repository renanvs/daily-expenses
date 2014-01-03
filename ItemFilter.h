//
//  ItemFilter.h
//  daily Expenses
//
//  Created by Renan Veloso Silva on 30/07/13.
//  Copyright (c) 2013 renan veloso silva. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ItemFilter : NSObject{
    NSArray *monthList;
    NSArray *parcelList;
}

@property (strong, nonatomic) NSArray *monthList;

-(NSArray*)filterByLabel:(NSMutableArray*)list ascending:(BOOL)asc;
-(NSArray*)filterByCreatedDate:(NSMutableArray*)list ascending:(BOOL)asc;
-(NSArray*)filterBySpentDate:(NSMutableArray*)list ascending:(BOOL)asc;

-(NSArray*)filterByDate:(NSString*)date onList:(NSMutableArray*)list;

+(ItemFilter*) sharedInstance;

-(NSArray*)getParcelList;
-(NSArray*)getMonthList;

@end
