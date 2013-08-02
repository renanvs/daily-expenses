//
//  ItemListModel.m
//  daily Expenses
//
//  Created by renan veloso silva on 02/07/13.
//  Copyright (c) 2013 renan veloso silva. All rights reserved.
//

#import "ItemCollection.h"
#import "Utility.h"

@implementation ItemCollection

static id _instance;
@synthesize listItens, allItens;

+ (ItemCollection *) sharedInstance{
    @synchronized(self){
        if (!_instance) {
            _instance = [[self alloc] init];
        }
    }
    return _instance;
}

#pragma mark - init methods

-(id)init{
    self = [super init];
    
    if (self) {
        [self inicialize];
    }
    
    return self;
}

-(void)inicialize{
    listItens = [[NSMutableArray alloc]init];
    allItens = [[NSMutableArray alloc]init];
    self.totalValue = [[NSNumber alloc] init];
    [self loadData];
}

-(void)loadData{
	NSFileManager *filemgr;
	filemgr = [NSFileManager defaultManager];
    
	NSArray *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentFolder = [documentPath objectAtIndex:0];
    newPlistFile = [[NSString alloc] initWithString:[documentFolder stringByAppendingPathComponent:@"NewPlist.plist"]];
    NSArray *arrayPlist = [NSArray arrayWithContentsOfFile:newPlistFile];
    if (!arrayPlist) {
        NSString *bundlePathOfPlist = [[NSBundle mainBundle] pathForResource:@"itemList" ofType:@"plist"];
        arrayPlist = [NSArray arrayWithContentsOfFile:bundlePathOfPlist];
		[filemgr createFileAtPath:newPlistFile contents:nil attributes:nil];
        [arrayPlist writeToFile:newPlistFile atomically:YES];
    }
	
    for (NSDictionary *dict in arrayPlist) {
        SpendItem *item = [[SpendItem alloc] init];
        item.item_id = [dict objectForKey:@"id"];
        item.label = [dict objectForKey:@"label"];
        item.type = [dict objectForKey:@"type"];
        item.parcel = [dict objectForKey:@"parcel"];
        item.value = [dict objectForKey:@"value"];
        item.dateSpent = [dict objectForKey:@"dateSpent"];
        item.dateUpdated = [dict objectForKey:@"dateUpdated"];
        item.dateCreated = [dict objectForKey:@"dateCreated"];
        item.notes = [dict objectForKey:@"notes"];
        item.typeImg = [self getTypeImage:item.type];
        [allItens addObject:item];
    }
	[self filterItensByCurrentDate];
}

#pragma mark - add, update, remove Item

-(void)addItemToList:(SpendItem*)item{
    int addId = [self getBiggerId] +1;
    //int addId = [[[listItens lastObject] item_id] intValue] +1;
    item.item_id = [NSString stringWithFormat:@"%d",addId];
	item.dateCreated = [[Utility sharedInstance] getCurrentDate];
	item.typeImg = [self getTypeImage:item.type];
    item = [self verifyAllFields:item];
    [allItens addObject:item];
    [self saveItemToPlist];
    [self getTotalValue];
}

-(void)updateItemToList:(SpendItem*)item{
    item.dateUpdated = [[Utility sharedInstance] getCurrentDate];
	item = [self verifyAllFields:item];
    
    [allItens setObject:item atIndexedSubscript:[self findIndexById:item.item_id]];
    [self updatePlistFileBasedOnList];
    
    [self getTotalValue];
    
    
}

-(void)removeItemByIndexPath :(NSInteger)index{
    [allItens removeObjectAtIndex:index];
    [self removePlistFileBasedOnList];
}

#pragma mark - auxiliar methods

-(NSInteger)findIndexById:(NSString*)item_id{
    
    for (int i=0; i<allItens.count; i++) {
        if ([[[allItens objectAtIndex:i] item_id] isEqualToString:item_id]){
            return i;
        }
    }
    return 0;
}

-(UIImage*)getTypeImage:(NSString*)type{
    NSDictionary *catategoryList = [[Config sharedInstance] categoryList];
    
    UIImage *image = [UIImage imageNamed:[catategoryList objectForKey:type]];
    
    return image;
}

-(SpendItem*)getSpendItemById:(NSString*)idValue{
    SpendItem *itemToReturn;
    for (SpendItem* item in allItens) {
        if ([item.item_id isEqualToString:idValue]){
            itemToReturn = item;
            break;
        }
    }
    return itemToReturn;
}

-(int)getBiggerId{
    SpendItem *itemR = [allItens objectAtIndex:0];
    int biggerId = [itemR.item_id intValue];
    for (int i=1; i<allItens.count; i++) {
        itemR = [allItens objectAtIndex:i];
        if ([itemR.item_id intValue] > biggerId){
            biggerId = [itemR.item_id intValue];
        }
    }
    return biggerId;
}

-(void)getTotalValue{
    self.totalValue = 0;
    for (SpendItem *itemR in listItens) {
        self.totalValue = [NSNumber numberWithFloat:[self.totalValue floatValue] + [itemR.value floatValue]];
    }
}

#pragma mark - verify method

-(SpendItem*)verifyAllFields:(SpendItem*)item{
    if ([[Utility sharedInstance]isEmptyString:item.label]) item.label = @"";
	if ([[Utility sharedInstance]isEmptyString:item.type]) item.type = @"label";
	if ([[Utility sharedInstance]isEmptyString:item.dateSpent]) item.dateSpent = @"";
	if ([[Utility sharedInstance]isEmptyString:item.notes]) item.notes = @"";
	
	if ([[Utility sharedInstance]isEmptyString:item.dateCreated]) item.dateCreated = @"";
	if ([[Utility sharedInstance]isEmptyString:item.dateUpdated]) item.dateUpdated = @"";
	
	if ([[Utility sharedInstance]isEmptyString:item.value]) item.value = @"0";
	if ([[Utility sharedInstance]isEmptyString:item.parcel]) item.parcel = @"1";
    
    return item;
}

#pragma mark - save, update, remove methods from plist

-(void)saveItemToPlist{
    NSMutableArray *addData = [NSMutableArray arrayWithContentsOfFile:newPlistFile];
	
//    for (SpendItem *itemR in listItens) {
//		[addData addObject:[self addItem:itemR]];
//	}
	[addData addObject:[self addItem:[allItens lastObject]]];
    [addData writeToFile:newPlistFile atomically:YES];
}

-(void)updatePlistFileBasedOnList{
    NSMutableArray *addData = [NSMutableArray arrayWithContentsOfFile:newPlistFile];
    
	[addData removeAllObjects];
	
    for (SpendItem *itemR in allItens) {
		[addData addObject:[self addItem:itemR]];
	}
	
	[addData writeToFile:newPlistFile atomically:YES];
}

-(void)removePlistFileBasedOnList{
    NSMutableArray *addData = [NSMutableArray arrayWithContentsOfFile:newPlistFile];
    
    NSInteger verify = 0;
    NSMutableArray *itensToRemove = [[NSMutableArray alloc] init];
    
    for (NSDictionary *item in addData) {
        for (SpendItem *itemC in allItens) {
            NSString *itemId = [item objectForKey:@"id"];
            NSString *itemCId = itemC.item_id;
            if ([itemId isEqualToString:itemCId]) {
                verify++;
            }
        }
        
        if (verify == 0) {
            [itensToRemove addObject:item];
            float total = [self.totalValue floatValue];
            float itemToRemoveVelu = [[item objectForKey:@"value"] floatValue];
            self.totalValue = [NSNumber numberWithFloat: (total - itemToRemoveVelu)];
        }
        
        verify = 0;
    }
    
	[addData removeObjectsInArray:itensToRemove];
    [addData writeToFile:newPlistFile atomically:YES];
}

-(NSDictionary*)addItem:(SpendItem*)item{
    NSDictionary* itemDict = [[NSDictionary alloc]initWithObjectsAndKeys:
                              item.item_id, @"id",
                              item.dateSpent, @"dateSpent",
							  item.dateCreated, @"dateCreated",
							  item.dateUpdated, @"dateUpdated",
                              item.label, @"label",
                              item.notes, @"notes",
                              item.parcel, @"parcel",
                              item.value, @"value",
                              item.type, @"type", nil];
    return itemDict;
}

#pragma mark - filter itens

-(void)filterItensByCurrentDate{
	FilterItens* filter = [[FilterItens alloc] init];
	//listItens = [NSMutableArray arrayWithArray:[filter filterBySpentDate:allItens ascending:NO]];
    listItens = [[NSMutableArray alloc] initWithArray:[filter filterByDate:[[Utility sharedInstance] getCurrentDate] onList:allItens]];
    [self getTotalValue];
}

@end
