//
//  MainView.m
//  daily Expenses
//
//  Created by renan veloso silva on 17/05/13.
//  Copyright (c) 2013 renan veloso silva. All rights reserved.
//

#import "MainView.h"
#import "DailyTableViewCell.h"
#import "AddDailyItemViewController.h"
#import "AddDailyItemFormViewController.h"
#import "SettingsViewController.h"
#import "ItemCollection.h"
#import "DailyTableViewHeaderCell.h"
#import "Utility.h"


@interface MainView ()

@end

@implementation MainView
@synthesize dailyTableView;
@synthesize listItens, allItens;
@synthesize changeViewTypeSegmentControl;
@synthesize totalValue;

#pragma mark - init, view...

-(id)init{
    self = [super init];
    if (self){
        listItens = [[ItemCollection sharedInstance] listItens];
        allItens = [[ItemCollection sharedInstance] allItens];
        dateValue = [[NSString alloc] initWithString:[[Utility sharedInstance]getCurrentDate]];
        
        
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    totalValueStr = [[ItemCollection sharedInstance] totalValueStr];
    //totalValue.text = [NSString stringWithFormat:@"R$ %@", totalValueStr];
    totalValue.text = totalValueStr;
    [dailyTableView reloadData];
    
    self.currentDate.text = [[ItemCollection sharedInstance] dateInCurrentView];
    
    if ([self.currentDate.text isEqualToString:[[Utility sharedInstance] getCurrentDate]]){
        self.goNextButton.enabled = NO;
        self.goNextButton.alpha = .5;
    }

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:@"UIDeviceOrientationDidChangeNotification" object:nil];
        
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [super dealloc];
}
- (void)viewDidUnload {
    [super viewDidUnload];
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
    [cell.typeView setBackgroundColor:currentSpendItem.isCredit ? [UIColor greenColor] : [UIColor redColor]];
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
        //[[ItemCollection sharedInstance] removeItemByIndexPath:indexPath.row];
        DailyTableViewCell *cell = (DailyTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
        [[ItemCollection sharedInstance] removeItemBySpendItem:cell.item];
        [tableView endUpdates];
        [tableView reloadData];
        ////NSString * totalValueStr = [[[ItemCollection sharedInstance] totalValue] stringValue];
        self.totalValue.text = totalValueStr;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DailyTableViewCell *cell = (DailyTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    AddDailyItemFormViewController *dailyViewItem = [[AddDailyItemFormViewController alloc] initWithId:cell.item.item_id];
    [self presentViewController:dailyViewItem animated:YES completion:nil];
}

#pragma mark - IBAction

-(IBAction)addDailyItem:(id)sender{
    AddDailyItemFormViewController *dailyViewItem = [[AddDailyItemFormViewController alloc] init];
    [self presentViewController:dailyViewItem animated:YES completion:nil];
}

-(IBAction)settings:(id)sender{
	SettingsViewController *settingsView = [[SettingsViewController alloc] init];
    [self presentViewController:settingsView animated:YES completion:nil];
}

-(IBAction)changeView:(id)sender{
	switch (self.changeViewTypeSegmentControl.selectedSegmentIndex) {
		case 0:{
			[self alertTest:@"First View"];
			break;
		}
		case 1:{
			[self alertTest:@"Second View"];
			break;
		}
		case 2:{
			[self alertTest:@"Third View"];
			break;
		}
		default:
			break;
	}
	
}

- (IBAction)goToDayBefore:(id)sender {
    [[ItemCollection sharedInstance] getListDayBefore];
    [dailyTableView reloadData];
    self.currentDate.text = [[ItemCollection sharedInstance] dateInCurrentView];
    if (![self.currentDate.text isEqualToString:[[Utility sharedInstance] getCurrentDate]]){
        self.goNextButton.enabled = YES;
        self.goNextButton.alpha = 1;
    }
    self.totalValue.text = totalValueStr;
}

- (IBAction)goToDayAfter:(id)sender {
    [[ItemCollection sharedInstance] getListDayAfter];
    [dailyTableView reloadData];
    self.currentDate.text = [[ItemCollection sharedInstance] dateInCurrentView];
    if ([self.currentDate.text isEqualToString:[[Utility sharedInstance] getCurrentDate]]){
        self.goNextButton.enabled = NO;
        self.goNextButton.alpha = .5;
    }
    self.totalValue.text = totalValueStr;
}

- (IBAction)showRelatorio:(id)sender {
    MonthViewController* mvc = [[MonthViewController alloc]init];
    [self presentViewController:mvc animated:YES completion:nil];
}

#pragma mark - other methods

-(void)alertTest:(NSString*)text{
	UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"TESTE" message:text delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
}

#pragma mark - rotate methods

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
	return  YES;
}

-(BOOL)shouldAutorotate{
	return YES;
}

-(void)orientationChanged:(NSNotification *)object{
	UIDeviceOrientation devOri = [[object object] orientation];
	
	if (devOri == UIInterfaceOrientationPortrait || devOri == UIInterfaceOrientationPortraitUpsideDown || devOri == UIDeviceOrientationUnknown){
		self.view = portraitView;
	}else{
		self.view = landscapeView;
	}
}
@end
