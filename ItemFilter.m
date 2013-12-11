//
//  ItemFilter.m
//  daily Expenses
//
//  Created by Renan Veloso Silva on 30/07/13.
//  Copyright (c) 2013 renan veloso silva. All rights reserved.
//

#import "ItemFilter.h"
#import "ItemModel.h"

@implementation ItemFilter
@synthesize monthList;

static id _instance;

+ (ItemFilter *) sharedInstance{
    @synchronized(self){
        if (!_instance) {
            _instance = [[self alloc] init];
        }
    }
    return _instance;
}

-(id)init{
    self = [super init];
    
    if (self) {
        [self getMonthList];
    }
    return self;
}

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

-(NSArray*)filterBySpentDate:(NSMutableArray*)list ascending:(BOOL)asc{
	NSArray *newList;
	NSSortDescriptor *descriptor;
	descriptor = [NSSortDescriptor sortDescriptorWithKey:@"dateSpent" ascending:asc];
	newList = [list sortedArrayUsingDescriptors:[NSArray arrayWithObject:descriptor]];
	
	return newList;
}

-(NSArray*)filterByDate:(NSString*)date onList:(NSMutableArray*)list{
    NSArray *newList;
    NSMutableArray *tempList = [[NSMutableArray alloc] init];
    
	for (ItemModel *itemR in list) {
        if ([itemR.dateSpent isEqualToString:date]) {
            [tempList addObject:itemR];
        }
    }
	
    newList = [NSArray arrayWithArray:tempList];
	
	return newList;
}

-(void)getMonthList{
    self.monthList = [NSArray arrayWithObjects:
                      @"janeiro",
                      @"fevereiro",
                      @"março",
                      @"abril",
                      @"maio",
                      @"junho",
                      @"julho",
                      @"agosto",
                      @"setembro",
                      @"outubro",
                      @"novembro",
                      @"dezembro",nil];
}

@end
