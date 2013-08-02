//
//  FilterItens.h
//  daily Expenses
//
//  Created by Renan Veloso Silva on 30/07/13.
//  Copyright (c) 2013 renan veloso silva. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FilterItens : NSObject

-(NSArray*)filterByLabel:(NSMutableArray*)list ascending:(BOOL)asc;
-(NSArray*)filterByCreatedDate:(NSMutableArray*)list ascending:(BOOL)asc;
-(NSArray*)filterBySpentDate:(NSMutableArray*)list ascending:(BOOL)asc;

-(NSArray*)filterByDate:(NSString*)date onList:(NSMutableArray*)list;
@end
