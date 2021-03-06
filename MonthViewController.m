//
//  MonthViewController.m
//  daily Expenses
//
//  Created by renan veloso silva on 20/08/13.
//  Copyright (c) 2013 renan veloso silva. All rights reserved.
//

#import "MonthViewController.h"
#import "Utility.h"
#import "ItemManager.h"
#import "ItemModel.h"

@implementation MonthViewController

-(id)init{
    self = [super init];
    
    if(self){
        [self initialize];
    }
    
    return self;
}

-(void)initialize{
    monthCollection = [[ItemManager sharedInstance] getAvailableMonths];
    itemByMonthDictionary = [[ItemManager sharedInstance] getItensByMonthList:monthCollection];
}

- (IBAction)backBt:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)dealloc {
    [_fullTable release];
    [super dealloc];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSString* key= [monthCollection objectAtIndex:section];
    NSArray* itens = [itemByMonthDictionary objectForKey:key];
    return itens.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return monthCollection.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]init];
    }
    
    NSString* keyR = [monthCollection objectAtIndex:indexPath.section];
    NSArray* listR = [itemByMonthDictionary objectForKey:keyR];
    ItemModel* itemR = [listR objectAtIndex:indexPath.row];
    NSString* labelR = [NSString stringWithFormat:@"Value: %@",itemR.value];
    cell.textLabel.text = labelR;
    
    return cell;

}
@end
