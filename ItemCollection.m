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
@synthesize listItens, allItens, dateInCurrentView;

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
    monthList =[NSArray arrayWithObjects:@"janeiro",
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
    
    hasLog = [Config sharedInstance].hasLog;
    allItens = [[NSMutableArray alloc]init];
    self.totalValue = [[NSNumber alloc] init];
    self.totalValueStr = [[NSMutableString alloc] init];
    dateInCurrentView = [[NSString alloc] initWithString:[[Utility sharedInstance] getCurrentDate]];
    
    [self loadData];
}

-(void)loadData{
	NSFileManager *filemgr;
	filemgr = [NSFileManager defaultManager];
    
	NSArray *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentFolder = [documentPath objectAtIndex:0];
    newPlistFile = [[NSString alloc] initWithString:[documentFolder stringByAppendingPathComponent:@"NewPlist.plist"]];
    
    if (hasLog){
        NSString* temp = newPlistFile;
        temp = [temp stringByReplacingOccurrencesOfString:@" " withString:@"\\ "];
        NSLog(@"file path: %@",temp);
    }
    
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
        item.isCredit = [[Utility sharedInstance] stringToBool:[dict objectForKey:@"isCredit"]];
        item.isSpent = [[Utility sharedInstance] stringToBool:[dict objectForKey:@"isSpent"]];
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
    item.item_id = [NSString stringWithFormat:@"%d",addId];
	item.dateCreated = [[Utility sharedInstance] getCurrentDate];
	item.typeImg = [self getTypeImage:item.type];
    item = [self verifyAllFields:item];
    [allItens addObject:item];
    [self saveItemToPlist];
    [self filterItensByCurrentDate];
}

-(void)updateItemToList:(SpendItem*)item{
    item.dateUpdated = [[Utility sharedInstance] getCurrentDate];
	item = [self verifyAllFields:item];
    item.typeImg = [self getTypeImage:item.type];
    [allItens setObject:item atIndexedSubscript:[self findIndexById:item.item_id]];
    [self updatePlistFileBasedOnList];
    
    [self getTotalValue];
}

-(void)removeItemBySpendItem :(SpendItem*)item{
    [allItens removeObject:item];
    [listItens removeObject:item];
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
        
        self.totalValue = [NSNumber numberWithFloat:[self.totalValue floatValue] + [self getValue:itemR.value isChecked:itemR.isCredit]];
    }
    
    if ([[Utility sharedInstance] isEmptyString:[self.totalValue stringValue]]) {
        [self.totalValueStr setString:@"0"];
    }else{
        [self.totalValueStr setString:[self.totalValue stringValue]];
    }
}

-(float)getValue:(NSString*)valueR isChecked:(BOOL)isChecked{
    float realValue;
    realValue = [valueR floatValue];
    if (!isChecked){
        realValue = (-1)*realValue;
    }
    return realValue;
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
            [self.totalValueStr setString:[self.totalValue stringValue]];
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
                              item.type, @"type",
                              [[Utility sharedInstance] boolToString:item.isSpent], @"isSpent",
                              [[Utility sharedInstance] boolToString:item.isCredit], @"isCredit",
                              nil];
    return itemDict;
}

#pragma mark - filter itens

-(void)filterItensByCurrentDate{
	FilterItens* filter = [[FilterItens alloc] init];

    if (listItens) {
        [listItens removeAllObjects];
        [listItens addObjectsFromArray :[NSMutableArray arrayWithArray:[filter filterByDate:[[Utility sharedInstance] getCurrentDate] onList:allItens]]];
    }else{
        listItens = [[NSMutableArray alloc] initWithArray:[filter filterByDate:[[Utility sharedInstance] getCurrentDate] onList:allItens]];
    }
    
    [self getTotalValue];
}

-(void)getListDayBefore{
    FilterItens* filter = [[FilterItens alloc] init];
    [listItens removeAllObjects];
    
   dateInCurrentView = [[NSString alloc] initWithString:[[Utility sharedInstance] getDayBefore:dateInCurrentView]] ;
    
    [listItens addObjectsFromArray:[NSArray arrayWithArray:[filter filterByDate:dateInCurrentView onList:allItens]]];
    [self getTotalValue];
}

-(void)getListDayAfter{
    FilterItens* filter = [[FilterItens alloc] init];
    [listItens removeAllObjects];
    
    dateInCurrentView = [[NSString alloc] initWithString:[[Utility sharedInstance] getDayAfter:dateInCurrentView]] ;
    
    [listItens addObjectsFromArray:[NSArray arrayWithArray:[filter filterByDate:dateInCurrentView onList:allItens]]];
    [self getTotalValue];
}

-(NSArray*)getAvailableMonths{
    NSMutableArray* months = [[NSMutableArray alloc] init];
    for (SpendItem* itemR in allItens) {
        NSString*currentMonth = [[Utility sharedInstance] getMonthByDate:itemR.dateSpent];
        if (![months containsObject:currentMonth]) {
            [months addObject:currentMonth];
        }
    }
    return months;
}

-(NSDictionary*)getItensByMonthList:(NSArray*)monthListR{
    NSMutableDictionary* monthsItensList = [[NSMutableDictionary alloc] init];
    NSMutableArray* tempItemList = [[NSMutableArray alloc] init];
    
    for (NSString* monthR in monthListR) {
        for (SpendItem* itemR in allItens) {
            if ([[[Utility sharedInstance] getMonthByDate:itemR.dateSpent] isEqualToString:monthR]) {
                [tempItemList addObject:itemR];
            }
        }
        [monthsItensList setObject:tempItemList forKey:monthR];
        tempItemList = [[NSMutableArray alloc] init];
    }
    
    return monthsItensList;
}

@end
