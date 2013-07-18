//
//  AddDailyItemFormViewController.m
//  daily Expenses
//
//  Created by renan veloso silva on 02/07/13.
//  Copyright (c) 2013 renan veloso silva. All rights reserved.
//

#import "AddDailyItemFormViewController.h"
#import "ItemListModel.h"
#import "categoryChooseCell.h"
#import "Config.h"

#import "PopoverDaily.h"

@interface AddDailyItemFormViewController ()

@end

@implementation AddDailyItemFormViewController

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
    [self createDatePicker];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setLabel:nil];
    [self setType:nil];
    [self setParcel:nil];
    [self setValue:nil];
    [self setDateStr:nil];
    [self setNote:nil];
    [self setCategoryChooseTable:nil];
    [self setCategoryView:nil];
    [self setTypeBt:nil];
    [self setTypeLabel:nil];
    [super viewDidUnload];
}

-(id)init{
    self =[super init];
    
    if (self) {
        categoryList = [[NSDictionary alloc] initWithDictionary:[[Config sharedInstance] categoryList]];
        
    }
    
    return self;
}


-(void)cadastrar:(id)sender{
    item = [[SpendItem alloc] init];
    NSNumberFormatter * formatter = [[NSNumberFormatter alloc] init];
    
    item.label = self.label.text;
    item.type = self.type.text;
    item.parcel = [formatter numberFromString:self.parcel.text];
    item.value = [formatter numberFromString:self.value.text];
    item.dateStr = self.dateStr.text;
    item.notes = self.note.text;
    item.typeImg = [UIImage imageNamed:item.type];
    [[ItemListModel sharedInstance] addItemToList:item];
    [self back:nil];
    
    
}

-(void)back:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)selectType:(id)sender {
    self.categoryView.hidden = NO;
}

- (IBAction)showDatePicker:(id)sender {
    datePicker.hidden = NO;
    dataPickerDoneBt.hidden = NO;
    bgView.hidden = NO;
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField == self.type){
        [textField resignFirstResponder];
    }
}

- (IBAction)closeCategoryChooseView:(id)sender {
    self.categoryView.hidden = YES;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"categoryChooseCell";
    categoryChooseCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    NSInteger row = indexPath.row;
    NSArray *allKeys = [categoryList allKeys];
    NSString *key = [allKeys objectAtIndex:row];
    NSString *objectValue = [categoryList objectForKey:key];
    
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:nil options:nil];
        
        for (id currentObject in topLevelObjects) {
            if ([currentObject isKindOfClass:[categoryChooseCell class]]) {
                cell = (categoryChooseCell*)currentObject;
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

-(void)createDatePicker{
    datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, (480-216), 320, 216)];
    datePicker.hidden = YES;
    datePicker.datePickerMode = UIDatePickerModeDate;
    datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"pt-BR"];
    datePicker.calendar = [datePicker.locale objectForKey:NSLocaleCalendar];
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"dd/MM/yyyy"];
    [outputFormatter setLocale:datePicker.locale];
    self.dateStr.text = [outputFormatter stringFromDate:[datePicker date]];
    
    dataPickerDoneBt = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    dataPickerDoneBt.hidden = YES;
    dataPickerDoneBt.frame = CGRectMake((320-70), (480-216-30), 70, 30);
    [dataPickerDoneBt setTitle:@"choose" forState:UIControlStateNormal];
    [dataPickerDoneBt addTarget:self action:@selector(DataPickerDone:) forControlEvents:UIControlEventTouchUpInside];
    
    [bgView addSubview:dataPickerDoneBt];
    [bgView addSubview:datePicker];
    
}

-(void)DataPickerDone:(id)event{
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"dd/MM/yyyy"];
    [outputFormatter setLocale:datePicker.locale];
    self.dateStr.text = [outputFormatter stringFromDate:[datePicker date]];
    datePicker.hidden = YES;
    dataPickerDoneBt.hidden = YES;
    bgView.hidden = YES;
}


-(void)setBackground{
    bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    [bgView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:.5]];
    bgView.hidden = YES;
    [self.view addSubview:bgView];
    
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField == self.dateStr) {
        return NO;
    }
    return YES;
}

- (void)dealloc {
    [_typeBt release];
    [_typeLabel release];
    [super dealloc];
}

- (IBAction)test:(id)sender {
    [self setBackground];
}
@end
