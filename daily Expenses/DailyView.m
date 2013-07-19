//
//  DailyView.m
//  daily Expenses
//
//  Created by renan veloso silva on 17/05/13.
//  Copyright (c) 2013 renan veloso silva. All rights reserved.
//

#import "DailyView.h"
#import "DailyTableViewCell.h"
#import "AddDailyItemViewController.h"
#import "AddDailyItemFormViewController.h"
#import "SettingsViewController.h"
#import "ItemListModel.h"
#import "DailyTableViewHeaderCell.h"


@interface DailyView ()

@end

@implementation DailyView
@synthesize dailyTableView;
@synthesize changeViewTypeSegmentControl;
@synthesize listItens, totalValue;

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
		default:
			break;
	}
	
}

#pragma mark - other methods

-(void)alertTest:(NSString*)text{
	UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"TESTE" message:text delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
}

#pragma mark - init, view...

-(id)init{
    self = [super init];
    if (self){
        listItens = [[ItemListModel sharedInstance] listItens];
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSString * totalValueStr = [[[ItemListModel sharedInstance] totalValue] stringValue];
    totalValue.text = [NSString stringWithFormat:@"R$ %@", totalValueStr];
    [dailyTableView reloadData];
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
