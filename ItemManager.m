//
//  ItemListModel.m
//  daily Expenses
//
//  Created by renan veloso silva on 02/07/13.
//  Copyright (c) 2013 renan veloso silva. All rights reserved.
//

#import "ItemManager.h"
#import "Utility.h"

@implementation ItemManager

static id _instance;
@synthesize listItens, allItens, dateInCurrentView, context;

+ (ItemManager *) sharedInstance{
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
        [self context];
        [self inicialize];
        [self loadData];
    }
    
    return self;
}

-(void)inicialize{
    monthList = [[ItemFilter sharedInstance] monthList];
    
    hasLog = [Config sharedInstance].hasLog;
    allItens = [[NSMutableArray alloc]init];
    self.totalValue = [[NSNumber alloc] init];
    dateInCurrentView = [[NSString alloc] initWithString:[[Utility sharedInstance] getCurrentDate]];
}

//TODO: criar um Manager para Criar, Consultar, Apagar arquivos
-(void)loadData{
//	NSFileManager *filemgr;
//	filemgr = [NSFileManager defaultManager];
//    
//	NSArray *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentFolder = [documentPath objectAtIndex:0];
//    newPlistFile = [[NSString alloc] initWithString:[documentFolder stringByAppendingPathComponent:@"NewPlist.plist"]];
//    
//    if (hasLog){
//        NSString* temp = newPlistFile;
//        temp = [temp stringByReplacingOccurrencesOfString:@" " withString:@"\\ "];
//        NSLog(@"file path: %@",temp);
//    }
//    
//    NSArray *arrayPlist = [NSArray arrayWithContentsOfFile:newPlistFile];
//    if (!arrayPlist) {
//        NSString *bundlePathOfPlist = [[NSBundle mainBundle] pathForResource:@"itemList" ofType:@"plist"];
//        arrayPlist = [NSArray arrayWithContentsOfFile:bundlePathOfPlist];
//		[filemgr createFileAtPath:newPlistFile contents:nil attributes:nil];
//        [arrayPlist writeToFile:newPlistFile atomically:YES];
//    }
//	
//    for (NSDictionary *dict in arrayPlist) {
//        ItemModel *item = [self convertDicToItemModel:dict];
//        
//        [allItens addObject:item];
//    }
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ItemModelC" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = entity;
    NSArray *result = [context executeFetchRequest:request error:nil];
    allItens = [[NSMutableArray alloc] initWithArray:result];
    
	[self filterItensByCurrentDate];
}

//-(ItemModel*)convertDicToItemModel:(NSDictionary*)dict{
//    
//    ItemModel *item = [[ItemModel alloc] init];
//    
//    item.item_id = [dict objectForKey:@"id"];
//    item.label = [dict objectForKey:@"label"];
//    item.type = [dict objectForKey:@"type"];
//    item.parcel = [dict objectForKey:@"parcel"];
//    item.isCredit = [[Utility sharedInstance] stringToBool:[dict objectForKey:@"isCredit"]];
//    item.isSpent = [[Utility sharedInstance] stringToBool:[dict objectForKey:@"isSpent"]];
//    item.value = [dict objectForKey:@"value"];
//    item.dateSpent = [dict objectForKey:@"dateSpent"];
//    item.dateUpdated = [dict objectForKey:@"dateUpdated"];
//    item.dateCreated = [dict objectForKey:@"dateCreated"];
//    item.notes = [dict objectForKey:@"notes"];
//    item.typeImg = [self getTypeImage:item.type];
//    
//    return item;
//    
//}

#pragma mark - add, update, remove Item
-(void)addItemToList:(ItemModelC*)item{
    int addId = [self getHighestId] +1;
    item.item_id = [NSString stringWithFormat:@"%d",addId];
	item.dateCreated = [[Utility sharedInstance] getCurrentDate];
	//item.typeImg = [self getTypeImage:item.type];
    //item = [self setDefautItemAttributes:item];
    
    [context insertObject:item];
    [self loadData];
    
    //[self saveItemToPlist];
    //[self filterItensByCurrentDate];
    
    [self saveContext];
}

-(void)updateItemToList:(ItemModelC*)item{
    item.dateUpdated = [[Utility sharedInstance] getCurrentDate];
	//item = [self setDefautItemAttributes:item];
    //item.typeImg = [self getTypeImage:item.type];
//    [allItens setObject:item atIndexedSubscript:[self findIndexById:item.item_id]];
//    [self updatePlistFileBasedOnList];
    
    [self getTotalValue];
    [self saveContext];
}

-(void)removeItemBySpendItem :(ItemModelC*)item{
    
    [context deleteObject:item];
    [self loadData];
    [self getTotalValue];
    //[allItens removeObject:item];
    //r//[listItens removeObject:item];
    //[self removePlistFileBasedOnList];
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

-(ItemModelC*)getSpendItemById:(NSString*)idValue{
    ItemModelC *itemToReturn;
    for (ItemModelC *item in allItens) {
        if ([item.item_id isEqualToString:idValue]){
            itemToReturn = item;
            break;
        }
    }
    return itemToReturn;
}

-(int)getHighestId{
    if (allItens.count == 0) {
        return 0;
    }
    
    ItemModelC *itemR = [allItens objectAtIndex:0];
    int highestId = [itemR.item_id intValue];
    for (int i=1; i<allItens.count; i++) {
        itemR = [allItens objectAtIndex:i];
        if ([itemR.item_id intValue] > highestId){
            highestId = [itemR.item_id intValue];
        }
    }
    return highestId;
}

-(void)getTotalValue{
    self.totalValue = [NSNumber numberWithInt:0];
    for (ItemModelC *itemR in listItens) {
        self.totalValue = [NSNumber numberWithFloat:[self.totalValue floatValue] + [self getValue:itemR.value isChecked:[itemR.isCredit boolValue]]];
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

//-(ItemModel*)setDefautItemAttributes:(ItemModel*)item{
//    if ([[Utility sharedInstance]isEmptyString:item.label]) item.label = @"";
//	if ([[Utility sharedInstance]isEmptyString:item.type]) item.type = @"label";
//	if ([[Utility sharedInstance]isEmptyString:item.dateSpent]) item.dateSpent = @"";
//	if ([[Utility sharedInstance]isEmptyString:item.notes]) item.notes = @"";
//	
//	if ([[Utility sharedInstance]isEmptyString:item.dateCreated]) item.dateCreated = @"";
//	if ([[Utility sharedInstance]isEmptyString:item.dateUpdated]) item.dateUpdated = @"";
//	
//	if ([[Utility sharedInstance]isEmptyString:item.value]) item.value = @"0";
//	if ([[Utility sharedInstance]isEmptyString:item.parcel]) item.parcel = @"1";
//    
//    return item;
//}

#pragma mark - save, update, remove methods from plist

//-(void)saveItemToPlist{
//    NSMutableArray *addData = [NSMutableArray arrayWithContentsOfFile:newPlistFile];
//	
//	[addData addObject:[self addItem:[allItens lastObject]]];
//    [addData writeToFile:newPlistFile atomically:YES];
//}
//
//-(void)updatePlistFileBasedOnList{
//    NSMutableArray *addData = [[NSMutableArray alloc] init];
//	
//    for (ItemModel *itemR in allItens) {
//		[addData addObject:[self addItem:itemR]];
//	}
//	
//	[addData writeToFile:newPlistFile atomically:YES];
//}
//
//-(void)removePlistFileBasedOnList{
//    NSMutableArray *addData = [NSMutableArray arrayWithContentsOfFile:newPlistFile];
//    
//    BOOL verify = NO;
//    NSMutableArray *itensToRemove = [[NSMutableArray alloc] init];
//    
//    for (NSDictionary *item in addData) {
//        for (ItemModel *itemC in allItens) {
//            NSString *itemId = [item objectForKey:@"id"];
//            NSString *itemCId = itemC.item_id;
//            if ([itemId isEqualToString:itemCId]) {
//                verify = YES;
//            }
//        }
//        
//        if (!verify) {
//            [itensToRemove addObject:item];
//            float total = [self.totalValue floatValue];
//            float itemToRemoveVelu = [[item objectForKey:@"value"] floatValue];
//            self.totalValue = [NSNumber numberWithFloat: (total - itemToRemoveVelu)];
//        }
//        
//        verify = NO;
//    }
//    
//	[addData removeObjectsInArray:itensToRemove];
//    [addData writeToFile:newPlistFile atomically:YES];
//}
//
//-(NSDictionary*)addItem:(ItemModel*)item{
//    NSDictionary* itemDict = [[NSDictionary alloc]initWithObjectsAndKeys:
//                              item.item_id, @"id",
//                              item.dateSpent, @"dateSpent",
//							  item.dateCreated, @"dateCreated",
//							  item.dateUpdated, @"dateUpdated",
//                              item.label, @"label",
//                              item.notes, @"notes",
//                              item.parcel, @"parcel",
//                              item.value, @"value",
//                              item.type, @"type",
//                              [[Utility sharedInstance] boolToString:item.isSpent], @"isSpent",
//                              [[Utility sharedInstance] boolToString:item.isCredit], @"isCredit",
//                              nil];
//    return itemDict;
//}

#pragma mark - filter itens

-(void)filterItensByCurrentDate{
	ItemFilter* filter = [ItemFilter sharedInstance];

    if (listItens) {
        [listItens removeAllObjects];
        [listItens addObjectsFromArray :[NSMutableArray arrayWithArray:[filter filterByDate:[[Utility sharedInstance] getCurrentDate] onList:allItens]]];
    }else{
        listItens = [[NSMutableArray alloc] initWithArray:[filter filterByDate:[[Utility sharedInstance] getCurrentDate] onList:allItens]];
    }
    
    [self getTotalValue];
}

-(void)getListDayBefore{
    ItemFilter* filter = [ItemFilter sharedInstance];
    [listItens removeAllObjects];
    
   dateInCurrentView = [[NSString alloc] initWithString:[[Utility sharedInstance] getDayBefore:dateInCurrentView]] ;
    
    [listItens addObjectsFromArray:[NSArray arrayWithArray:[filter filterByDate:dateInCurrentView onList:allItens]]];
    [self getTotalValue];
}

-(void)getListDayAfter{
    ItemFilter* filter = [ItemFilter sharedInstance];
    [listItens removeAllObjects];
    
    dateInCurrentView = [[NSString alloc] initWithString:[[Utility sharedInstance] getDayAfter:dateInCurrentView]] ;
    
    [listItens addObjectsFromArray:[NSArray arrayWithArray:[filter filterByDate:dateInCurrentView onList:allItens]]];
    [self getTotalValue];
}

-(NSArray*)getAvailableMonths{
    NSMutableArray* months = [[NSMutableArray alloc] init];
    
    if (allItens.count == 0) {
        return months;
    }
    
    for (ItemModelC *itemR in allItens) {
        NSString *currentMonth = [[Utility sharedInstance] getMonthByDate:itemR.dateSpent];
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
        for (ItemModelC *itemR in allItens) {
            if ([[[Utility sharedInstance] getMonthByDate:itemR.dateSpent] isEqualToString:monthR]) {
                [tempItemList addObject:itemR];
            }
        }
        [monthsItensList setObject:tempItemList forKey:monthR];
        tempItemList = [[NSMutableArray alloc] init];
    }
    
    return monthsItensList;
}

#pragma mark - coreData

-(NSManagedObjectModel*)managedObjectModel{
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"CoreDataModel" withExtension:@"momd"];
    NSManagedObjectModel *managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return managedObjectModel;
}

-(NSPersistentStoreCoordinator *)coordinator{
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    NSURL *pastaDocuments = [self applicationDocumentsDirectory];
    NSURL *localBancoDados = [pastaDocuments URLByAppendingPathComponent:@"DEBanco.sqlite"];
    
    [coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:localBancoDados options:nil error:nil];
    return coordinator;
}

-(NSURL*)applicationDocumentsDirectory{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

-(NSManagedObjectContext *)context{
    if (context != nil) {
        return context;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self coordinator];
    context = [[NSManagedObjectContext alloc] init];
    [context setPersistentStoreCoordinator:coordinator];
    return context;
}

-(void)saveContext{
    NSError *error;
    if (![context save:&error]) {
        NSDictionary *informacoes = [error userInfo];
        NSArray *multiplosError = [informacoes objectForKey:NSDetailedErrorsKey];
        if (multiplosError) {
            for (NSError *error in multiplosError) {
                NSLog(@"Problema: %@", [error userInfo]);
            }
        }else{
            NSLog(@"Problema: %@", informacoes);
        }
    }else{
        //r//;
    }
}

@end
