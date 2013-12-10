//
//  SettingsViewController.m
//  daily Expenses
//
//  Created by renan veloso silva on 19/05/13.
//  Copyright (c) 2013 renan veloso silva. All rights reserved.
//

#import "SettingsViewController.h"

@implementation SettingsViewController

@synthesize tableView;

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	static NSString *CellIdentifier = @"CustomerCell";
	UITableViewCell * cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if(!cell){
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
	}
	
	return cell;
}

-(void)done:(id)sender{
	[self dismissViewControllerAnimated:YES completion:nil];
}

@end
