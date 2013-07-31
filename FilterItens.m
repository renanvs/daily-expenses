//
//  FilterItens.m
//  daily Expenses
//
//  Created by Renan Veloso Silva on 30/07/13.
//  Copyright (c) 2013 renan veloso silva. All rights reserved.
//

#import "FilterItens.h"
#import "SpendItem.h"

@implementation FilterItens

-(NSArray*)filterByLabel:(NSMutableArray*)list ascending:(BOOL)asc{
	NSArray *newList;
	NSSortDescriptor *descriptor;
	descriptor = [NSSortDescriptor sortDescriptorWithKey:@"label" ascending:asc];
	newList = [list sortedArrayUsingDescriptors:[NSArray arrayWithObject:descriptor]];
	
	return newList;
}

-(NSArray*)filterByCreatedDate:(NSMutableArray*)list ascending:(BOOL)asc{
	NSArray *newList;
	NSSortDescriptor *descriptor;
	descriptor = [NSSortDescriptor sortDescriptorWithKey:@"dateCreated" ascending:asc];
	newList = [list sortedArrayUsingDescriptors:[NSArray arrayWithObject:descriptor]];
	
	return newList;
}

-(NSArray*)filterBySpendDate:(NSMutableArray*)list ascending:(BOOL)asc{
	NSArray *newList;
	NSSortDescriptor *descriptor;
	descriptor = [NSSortDescriptor sortDescriptorWithKey:@"dateSpent" ascending:asc];
	newList = [list sortedArrayUsingDescriptors:[NSArray arrayWithObject:descriptor]];
	
	return newList;
}


@end
