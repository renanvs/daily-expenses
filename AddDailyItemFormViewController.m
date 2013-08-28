//
//  AddDailyItemFormViewController.m
//  daily Expenses
//
//  Created by renan veloso silva on 02/07/13.
//  Copyright (c) 2013 renan veloso silva. All rights reserved.
//

#import "AddDailyItemFormViewController.h"
#import "ItemCollection.h"
#import "CategoryChooseCell.h"
#import "Config.h"
#import "Utility.h"

#import "PopoverDaily.h"

@interface AddDailyItemFormViewController ()

@end

@implementation AddDailyItemFormViewController

@synthesize label, typeLabel, parcel, value, dateStr, note, typeBt, add;

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
    
    CGRect spendRect = CGRectMake(0, 0, 240, 30);
    spent = [[SSCheckBoxView alloc] initWithFrame:spendRect style:kSSCheckBoxViewStyleGlossy checked:YES];
    CGRect creditRect = CGRectMake(0, 40, 240, 30);
    credit = [[SSCheckBoxView alloc] initWithFrame:creditRect style:kSSCheckBoxViewStyleGlossy checked:NO];
    [spent setText:@"Gasto"];
    [credit setText:@"Crédito"];
    [spent setStateChangedTarget:self selector:@selector(checkBoxViewChangedState:)];
    [credit setStateChangedTarget:self selector:@selector(checkBoxViewChangedState:)];
    [self.typeView addSubview:spent];
    [self.typeView addSubview:credit];
    
    if ([state isEqualToString:@"update"]){
        [self populateToForm];
        [add setTitle:@"Atualizar"];
    }else{
        self.add.title = @"Cadastrar";
        self.dateStr.text = [[Utility sharedInstance] getCurrentDate];
    }
    
    
    
    // Do any additional setup after loading the view from its nib.
}

- (void) checkBoxViewChangedState:(SSCheckBoxView *)checkBox
{
    if (checkBox == spent) {
        credit.checked = !checkBox.checked;
    }else if(checkBox == credit) {
        spent.checked = !checkBox.checked;
    }
    
    if (credit.checked) {
        [self.value setTextColor:[UIColor greenColor]];
    }else if (spent.checked){
        [self.value setTextColor:[UIColor redColor]];
    }
    
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
    [self setTypeLabel:nil];
    [self setTypeView:nil];
    [super viewDidUnload];
}

-(id)init{
    self =[super init];
    
    if (self) {
		state = @"new";
        [self initialize];
    }
    
    return self;
}

-(id)initWithId:(NSString*)itemId{
    self =[super init];
    
	if (self) {
		state = @"update";
        item = [[ItemCollection sharedInstance] getSpendItemById:itemId];
        [self initialize];
    }
    
    return self;
}

-(void)initialize{
	categoryList = [[NSDictionary alloc] initWithDictionary:[[Config sharedInstance] categoryList]];
	parcelDatasource = [[NSArray alloc] initWithObjects:@"1x", @"2x", @"3x", @"4x", @"5x", @"6x", @"7x", @"8x",
						@"9x", @"10x", @"11x", @"12x", @"13x", @"14x", @"15x",
						@"16x", @"17x", @"18x", @"19x", @"20x", @"21x", @"22x",
						@"23x", @"24x", nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)dealloc {
    [_typeView release];
    [super dealloc];
}

#pragma mark - IBAction's

-(IBAction)cadastrar:(id)sender{
    [self addItem];
}

-(IBAction)back:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)selectType:(id)sender {
    [self closeKeyboard];
    [self createCategoryTableView];
}

- (IBAction)showDatePicker:(id)sender {
    [self closeKeyboard];
    [self createDatePicker];
}

- (IBAction)showParcelPicker:(id)sender {
    [self closeKeyboard];
    [self createParcelPicker];
}

#pragma mark - textFieldDelegate Methods

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField == self.dateStr || textField == self.parcel) {
        return NO;
    }
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
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
    return categoryList.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    NSArray *allKeys = [categoryList allKeys];
    self.typeLabel.text = [allKeys objectAtIndex:row];
    UIImage *iconImg = [UIImage imageNamed:[categoryList objectForKey:[allKeys objectAtIndex:row]]];
    [self.typeBt setImage:iconImg forState:UIControlStateNormal];
    bgView.hidden = YES;
}

#pragma mark - create dataPicker and pickerView

-(void)createDatePicker{
	[[Utility sharedInstance] removeElementsFromView:bgView];
	datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, (480-216), 320, 216)];
    datePicker.datePickerMode = UIDatePickerModeDate;
    datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"pt-BR"];
    datePicker.calendar = [datePicker.locale objectForKey:NSLocaleCalendar];
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"dd/MM/yyyy"];
    [outputFormatter setLocale:datePicker.locale];
    self.dateStr.text = [outputFormatter stringFromDate:[datePicker date]];
    
    dataPickerDoneBt = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    dataPickerDoneBt.frame = CGRectMake(0, 0, 70, 30);
	[[Utility sharedInstance] setItem:dataPickerDoneBt inView:datePicker side:@"right" UpDown:@"up" padLeft:0 padTop:0 padRight:0 padBottom:0];
    [dataPickerDoneBt setTitle:@"choose" forState:UIControlStateNormal];
    [dataPickerDoneBt addTarget:self action:@selector(dataPickerDone:) forControlEvents:UIControlEventTouchUpInside];
    
    [bgView addSubview:dataPickerDoneBt];
    [bgView addSubview:datePicker];
    
    bgView.hidden = NO;
}

-(void)createParcelPicker{
	[[Utility sharedInstance] removeElementsFromView:bgView];
    parcelPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, (480-216), 320, 216)];
    parcelPicker.delegate = self;
    parcelPicker.dataSource = self;
    parcelPicker.showsSelectionIndicator = YES;
    
    self.parcel.text = @"";
    
    parcelPickerDoneBt = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    parcelPickerDoneBt.frame = CGRectMake(0, 0, 70, 30);
	[[Utility sharedInstance] setItem:parcelPickerDoneBt inView:parcelPicker side:@"right" UpDown:@"up" padLeft:0 padTop:0 padRight:0 padBottom:0];
    [parcelPickerDoneBt setTitle:@"Done" forState:UIControlStateNormal];
    [parcelPickerDoneBt addTarget:self action:@selector(parcelPickerDone:) forControlEvents:UIControlEventTouchUpInside];
    
    [bgView addSubview:parcelPickerDoneBt];
    [bgView addSubview:parcelPicker];
    
    bgView.hidden = NO;
    
}

-(void)createCategoryTableView{
	[[Utility sharedInstance] removeElementsFromView:bgView];
	categoryTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 260, 360) style:UITableViewStylePlain];
	categoryTableView.delegate = self;
	categoryTableView.dataSource = self;
	[[Utility sharedInstance] setItem:categoryTableView inCenterView:bgView padLeft:0 padTop:45 padRight:0 padBottom:0];
	
	categoryTableDoneBt = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	categoryTableDoneBt.frame = CGRectMake(0, 0, 70, 30);
	[categoryTableDoneBt setTitle:@"Close" forState:UIControlStateNormal];
	[categoryTableDoneBt addTarget:self action:@selector(categoryTableDone:) forControlEvents:UIControlEventTouchUpInside];
	[[Utility sharedInstance]setItem:categoryTableDoneBt inView:categoryTableView side:@"right" UpDown:@"up" padLeft:0 padTop:0 padRight:0 padBottom:0];
	
	[bgView addSubview:categoryTableView];
	[bgView addSubview:categoryTableDoneBt];
	
	bgView.hidden = NO;
}

#pragma mark - keyboard methods
-(void)keyboardDidShow:(NSNotification*)notification{
    NSDictionary *keyboardInfo = [notification userInfo];
    NSValue *keyboardFrameValue = [keyboardInfo valueForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardFrameRect = [keyboardFrameValue CGRectValue];
    
    closeKeyboardBt = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    closeKeyboardBt.frame = CGRectMake((keyboardFrameRect.size.width-70), (keyboardFrameRect.origin.y-30), 70, 30);
    [closeKeyboardBt setTitle:@"Fechar" forState:UIControlStateNormal];
    [closeKeyboardBt addTarget:self action:@selector(closeKeyboard) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeKeyboardBt];
}

-(void)keyboardWillHide:(NSNotification*)notification{
    [closeKeyboardBt removeFromSuperview];
}

-(void)closeKeyboard{
    for (UITextField *tf in [self.tpScrollView subviews]) {
        [tf resignFirstResponder];
        
    }
}

#pragma mark - other methods

-(void)setBackground{
    bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    [bgView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:.5]];
    bgView.hidden = YES;
    [self.view addSubview:bgView];
    
}

-(void)populateToForm{
	UIImage *categoryImage;
    self.label.text = item.label;
	self.typeLabel.text = item.type;
	self.parcel.text = [NSString stringWithFormat:@"%@x",item.parcel];
	self.value.text = item.value;
	self.dateStr.text = item.dateSpent;
	self.note.text = item.notes;
    categoryImage = [[Config sharedInstance] getImageByCategoryLabel:item.type];
	[self.typeBt setImage:categoryImage forState:UIControlStateNormal];
    
    credit.checked = item.isCredit;
    spent.checked = item.isSpent;
    
    if (credit.checked) {
        [self.value setTextColor:[UIColor greenColor]];
    }else if (spent.checked){
        [self.value setTextColor:[UIColor redColor]];
    }
	
}

-(void)addItem{
    if (!item) {
		item = [[SpendItem alloc] init];
	}
	
    item.label = self.label.text;
    item.type = self.typeLabel.text;
    item.parcel = [self.parcel.text stringByReplacingOccurrencesOfString:@"x" withString:@""];
    item.value = self.value.text;
    item.dateSpent = self.dateStr.text;
    item.notes = self.note.text;
    item.typeImg = [UIImage imageNamed:item.type];
    item.isCredit = credit.checked;
    item.isSpent = spent.checked;
    
    if ([state isEqualToString:@"update"]) {
        [[ItemCollection sharedInstance] updateItemToList:item];
    }else{
        [[ItemCollection sharedInstance] addItemToList:item];
    }
    
    [self back:nil];
}

#pragma mark - Pickers and Table Done Button

-(void)dataPickerDone:(id)event{
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"dd/MM/yyyy"];
    [outputFormatter setLocale:datePicker.locale];
    self.dateStr.text = [outputFormatter stringFromDate:[datePicker date]];
    bgView.hidden = YES;
}

-(void)parcelPickerDone:(id)event{
	NSInteger row = [parcelPicker selectedRowInComponent:0];
	self.parcel.text = [parcelDatasource objectAtIndex:row];
    bgView.hidden = YES;;
}

-(void)categoryTableDone:(id)event{
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:2];
//    CGAffineTransform transform = CGAffineTransformMakeTranslation(0, 480);
//    categoryTableView.transform = transform;
//    [UIView commitAnimations];
	CGRect categoryRect = categoryTableView.frame;
	[UIView animateWithDuration:.5 animations:^{
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[categoryTableView setFrame:CGRectMake(categoryRect.origin.x, categoryRect.origin.y + categoryRect.size.height,
											   categoryRect.size.width,categoryRect.size.height)];
	}completion:^(BOOL finished){
		bgView.hidden = YES;
	}];
	
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
