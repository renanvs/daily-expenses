//
//  ItemFilter.m
//  daily Expenses
//
//  Created by Renan Veloso Silva on 30/07/13.
//  Copyright (c) 2013 renan veloso silva. All rights reserved.
//

#import "ItemFilter.h"

@implementation ItemFilter
@synthesize  monthList;

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

//not used
-(NSArray*)filterByLabel:(NSMutableArray*)list ascending:(BOOL)asc{
	NSArray *newList;
	NSSortDescriptor *descriptor;
	descriptor = [NSSortDescriptor sortDescriptorWithKey:@"label" ascending:asc];
	newList = [list sortedArrayUsingDescriptors:[NSArray arrayWithObject:descriptor]];
	
	return newList;
}

//not used
-(NSArray*)filterByCreatedDate:(NSMutableArray*)list ascending:(BOOL)asc{
	NSArray *newList;
	NSSortDescriptor *descriptor;
	descriptor = [NSSortDescriptor sortDescriptorWithKey:@"dateCreated" ascending:asc];
	newList = [list sortedArrayUsingDescriptors:[NSArray arrayWithObject:descriptor]];
	
	return newList;
}

//not used
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

-(NSArray*)getMonthList{
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
    return monthList;
}

-(NSArray*)getParcelList{
    parcelList = [[NSArray alloc] initWithObjects:@"1x", @"2x", @"3x", @"4x", @"5x", @"6x", @"7x", @"8x",
     @"9x", @"10x", @"11x", @"12x", @"13x", @"14x", @"15x",
     @"16x", @"17x", @"18x", @"19x", @"20x", @"21x", @"22x",
     @"23x", @"24x", nil];
    
    return parcelList;
}
@end
