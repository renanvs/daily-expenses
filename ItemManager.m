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

    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ItemModel" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = entity;
    NSArray *result = [context executeFetchRequest:request error:nil];
    allItens = [[NSMutableArray alloc] initWithArray:result];
    [self filterItensByDate:dateInCurrentView];
	//[self filterItensByCurrentDate];
}

#pragma mark - add, update, remove Item
-(void)addItemToList:(ItemModel*)item{
    int addId = [self getHighestId] +1;
    item.item_id = [NSString stringWithFormat:@"%d",addId];
	item.dateCreated = [[Utility sharedInstance] getCurrentDate];
	
    //[context insertObject:item];
    [self loadData];
    
    [self saveContext];
}

-(void)updateItemToList:(ItemModel*)item{
    item.dateUpdated = [[Utility sharedInstance] getCurrentDate];
    
    [self getTotalValue];
    [self saveContext];
}

-(void)removeItemBySpendItem :(ItemModel*)item{
    
    [context deleteObject:item];
    [self loadData];
    [self getTotalValue];
}

#pragma mark - auxiliar methods
//not used
-(UIImage*)getTypeImage:(NSString*)type{
    NSDictionary *catategoryList = [[Config sharedInstance] categoryList];
    
    UIImage *image = [UIImage imageNamed:[catategoryList objectForKey:type]];
    
    return image;
}

-(ItemModel*)getSpendItemById:(NSString*)idValue{
    ItemModel *itemToReturn;
    for (ItemModel *item in allItens) {
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
    
    ItemModel *itemR = [allItens objectAtIndex:0];
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
    for (ItemModel *itemR in listItens) {
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

-(void)filterItensByDate:(NSString*)date{
	ItemFilter* filter = [ItemFilter sharedInstance];
    
    if (listItens) {
        [listItens removeAllObjects];
        [listItens addObjectsFromArray :[NSMutableArray arrayWithArray:[filter filterByDate:date onList:allItens]]];
    }else{
        listItens = [[NSMutableArray alloc] initWithArray:[filter filterByDate:date onList:allItens]];
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
    
    for (ItemModel *itemR in allItens) {
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
        for (ItemModel *itemR in allItens) {
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
