//
//  AddDailyItemFormViewController.m
//  daily Expenses
//
//  Created by renan veloso silva on 02/07/13.
//  Copyright (c) 2013 renan veloso silva. All rights reserved.
//

#import "AddDailyItemFormViewController.h"
#import "ItemListModel.h"
#import "CategoryChooseCell.h"
#import "Config.h"

#import "PopoverDaily.h"

@interface AddDailyItemFormViewController ()

@end

@implementation AddDailyItemFormViewController

#pragma mark - init, view...

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
    [self setBackground];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setLabel:nil];
    [self setParcel:nil];
    [self setValue:nil];
    [self setDateStr:nil];
    [self setNote:nil];
    [self setCategoryChooseTable:nil];
    [self setCategoryView:nil];
    [self setTypeLabel:nil];
    [super viewDidUnload];
}

-(id)init{
    self =[super init];
    
    if (self) {
        categoryList = [[NSDictionary alloc] initWithDictionary:[[Config sharedInstance] categoryList]];
		parcelDatasource = [[NSArray alloc] initWithObjects:@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"11", @"12", @"13", @"14", @"15", @"16", @"17", @"18", @"19", @"20", @"21", @"22", @"23", @"24", nil];
    }
    
    return self;
}

- (void)dealloc {
    [_typeBt release];
    [_typeLabel release];
    [super dealloc];
}

#pragma mark - IBAction

-(IBAction)cadastrar:(id)sender{
    item = [[SpendItem alloc] init];
    NSNumberFormatter * formatter = [[NSNumberFormatter alloc] init];
    
    item.label = self.label.text;
    item.type = self.typeLabel.text;
    item.parcel = [formatter numberFromString:self.parcel.text];
    item.value = [formatter numberFromString:self.value.text];
    item.dateStr = self.dateStr.text;
    item.notes = self.note.text;
    item.typeImg = [UIImage imageNamed:item.type];
    [[ItemListModel sharedInstance] addItemToList:item];
    [self back:nil];
    
    
}

-(IBAction)back:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)selectType:(id)sender {
    self.categoryView.hidden = NO;
}

- (IBAction)showDatePicker:(id)sender {
    [self createDatePicker];
}

- (IBAction)showParcelPicker:(id)sender {
    [self createParcelPicker];
}

- (IBAction)closeCategoryChooseView:(id)sender {
    self.categoryView.hidden = YES;
}

#pragma mark - textFieldDelegate Methods

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField == self.dateStr) {
        return NO;
    }
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
//    if (textField == self.type){
//        [textField resignFirstResponder];
//    }
}

#pragma mark - tableViewDelegate Methods

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"categoryChooseCell";
    CategoryChooseCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    NSInteger row = indexPath.row;
    NSArray *allKeys = [categoryList allKeys];
    NSString *key = [allKeys objectAtIndex:row];
    NSString *objectValue = [categoryList objectForKey:key];
    
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:nil options:nil];
        
        for (id currentObject in topLevelObjects) {
            if ([currentObject isKindOfClass:[CategoryChooseCell class]]) {
                cell = (CategoryChooseCell*)currentObject;
                cell.icon.image = [UIImage imageNamed:objectValue];
                cell.label.text = key;
                break;
            }
        }
    }
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  categoryList.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    NSArray *allKeys = [categoryList allKeys];
    self.typeLabel.text = [allKeys objectAtIndex:row];
    UIImage *iconImg = [UIImage imageNamed:[categoryList objectForKey:[allKeys objectAtIndex:row]]];
    [self.typeBt setImage:iconImg forState:UIControlStateNormal];
    self.categoryView.hidden = YES;
}

#pragma mark - create dataPicker and pickerView

-(void)createDatePicker{
	[self removeElementsFromView:bgView];
    datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, (480-216), 320, 216)];
    datePicker.datePickerMode = UIDatePickerModeDate;
    datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"pt-BR"];
    datePicker.calendar = [datePicker.locale objectForKey:NSLocaleCalendar];
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"dd/MM/yyyy"];
    [outputFormatter setLocale:datePicker.locale];
    self.dateStr.text = [outputFormatter stringFromDate:[datePicker date]];
    
    dataPickerDoneBt = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    dataPickerDoneBt.frame = CGRectMake((320-70), (480-216-30), 70, 30);
    [dataPickerDoneBt setTitle:@"choose" forState:UIControlStateNormal];
    [dataPickerDoneBt addTarget:self action:@selector(dataPickerDone:) forControlEvents:UIControlEventTouchUpInside];
    
    [bgView addSubview:dataPickerDoneBt];
    [bgView addSubview:datePicker];
    
    bgView.hidden = NO;
    
}

-(void)createParcelPicker{
	[self removeElementsFromView:bgView];
    parcelPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, (480-216), 320, 216)];
    parcelPicker.delegate = self;
    parcelPicker.dataSource = self;
    parcelPicker.showsSelectionIndicator = YES;
    
    self.parcel.text = @"";
    
    parcelPickerDoneBt = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    parcelPickerDoneBt.frame = CGRectMake((320-70), (480-216-30), 70, 30);
    [parcelPickerDoneBt setTitle:@"Done" forState:UIControlStateNormal];
    [parcelPickerDoneBt addTarget:self action:@selector(parcelPickerDone:) forControlEvents:UIControlEventTouchUpInside];
    
    [bgView addSubview:parcelPickerDoneBt];
    [bgView addSubview:parcelPicker];
    
    bgView.hidden = NO;
    
}

#pragma mark - other methods

-(void)removeElementsFromView:(UIView*)viewR{
	for (id object in [viewR subviews]) {
		[object removeFromSuperview];
	}
}

-(void)setBackground{
    bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    [bgView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:.5]];
    bgView.hidden = YES;
    [self.view addSubview:bgView];
    
}

- (IBAction)test:(id)sender {
    [self setBackground];
}

#pragma mark - Pickers Done Button

-(void)dataPickerDone:(id)event{
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"dd/MM/yyyy"];
    [outputFormatter setLocale:datePicker.locale];
    self.dateStr.text = [outputFormatter stringFromDate:[datePicker date]];
    bgView.hidden = YES;
}

-(void)parcelPickerDone:(id)event{
    self.parcel.text = @"";
    bgView.hidden = YES;;
    
}

#pragma mark - pickerViewDelegate methods

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return parcelDatasource.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [parcelDatasource objectAtIndex:row];
}

@end
