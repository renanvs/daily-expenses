//
//  DailyView.m
//  daily Expenses
//
//  Created by Renan Veloso Silva on 23/07/13.
//  Copyright (c) 2013 renan veloso silva. All rights reserved.
//

#import "DailyView.h"
#import "DailyTableViewCell.h"
#import "ItemCollection.h"
#import "DailyTableViewHeaderCell.h"

@implementation DailyView
@synthesize dailyTableView;
@synthesize listItens;
@synthesize totalValue;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)init{
    self = [super init];
    if (self){
        listItens = [[ItemCollection sharedInstance] listItens];
		
		NSString * totalValueStr = [[[ItemCollection sharedInstance] totalValue] stringValue];
		totalValue.text = [NSString stringWithFormat:@"R$ %@", totalValueStr];
		[dailyTableView reloadData];
    }
    return self;
}

#pragma mark - tableView delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return listItens.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"DailyTableViewCell";
    DailyTableViewCell *cell = (DailyTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    NSInteger row = indexPath.row;
    SpendItem *currentSpendItem = [listItens objectAtIndex:row];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil] objectAtIndex:0];
    }
	
    cell.icon.image = currentSpendItem.typeImg;
    cell.label.text = currentSpendItem.label;
    cell.price.text = [NSString stringWithFormat:@"%@",currentSpendItem.value];
    cell.item = currentSpendItem;
    
    return cell;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    //UIViewController *view = [[UIViewController alloc] initWithNibName:@"DailyTableViewHeaderCell" bundle:nil];
    DailyTableViewHeaderCell *headerView = [[DailyTableViewHeaderCell alloc] init];
    return headerView.view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete){
        [tableView beginUpdates];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [[ItemCollection sharedInstance] removeItemByIndexPath:indexPath.row];
        [tableView endUpdates];
        [tableView reloadData];
    }
}

@end
