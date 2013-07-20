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
    [self setTypeLabel:nil];
    [super viewDidUnload];
}

-(id)init{
    self =[super init];
    
    if (self) {
        categoryList = [[NSDictionary alloc] initWithDictionary:[[Config sharedInstance] categoryList]];
		parcelDatasource = [[NSArray alloc] initWithObjects:@"1x", @"2x", @"3x", @"4x", @"5x", @"6x", @"7x", @"8x", @"9x", @"10x", @"11x", @"12x", @"13x", @"14x", @"15x", @"16x", @"17x", @"18x", @"19x", @"20x", @"21x", @"22x", @"23x", @"24x", nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    
    return self;
}

- (void)dealloc {
    [_typeBt release];
    [_typeLabel release];
    [super dealloc];
}

#pragma mark - IBAction's

-(IBAction)cadastrar:(id)sender{
    item = [[SpendItem alloc] init];
    NSNumberFormatter * formatter = [[NSNumberFormatter alloc] init];
    
    item.label = self.label.text;
    item.type = self.typeLabel.text;
    item.parcel = [formatter numberFromString:[self.parcel.text stringByReplacingOccurrencesOfString:@"x" withString:@""]];
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

-(void)createCategoryTableView{
	[self removeElementsFromView:bgView];
	categoryTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 260, 360) style:UITableViewStylePlain];
	categoryTableView.delegate = self;
	categoryTableView.dataSource = self;
    [self setItem:categoryTableView inCenterView:bgView padLeft:0 padTop:45 padRight:0 padBottom:0];
	
	categoryTableDoneBt = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	categoryTableDoneBt.frame = CGRectMake(0, 0, 70, 30);
	[categoryTableDoneBt setTitle:@"Close" forState:UIControlStateNormal];
	[categoryTableDoneBt addTarget:self action:@selector(categoryTableDone:) forControlEvents:UIControlEventTouchUpInside];
    [self setItem:categoryTableDoneBt inView:categoryTableView side:@"right" UpDown:@"up" padLeft:0 padTop:0 padRight:0 padBottom:0];
	
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

- (void)setItem:(UIView*)subView inCenterView:(UIView*)viewR padLeft:(CGFloat)l  padTop:(CGFloat)t padRight:(CGFloat)r padBottom:(CGFloat)b{
    CGRect CGItem = subView.frame;
    CGRect CGView = viewR.frame;
    
    CGFloat w = CGItem.size.width;
    CGFloat h = CGItem.size.height;
    CGFloat x = (CGView.size.width/2) - (CGItem.size.width/2) + l - r;
    CGFloat y = (CGView.size.height/2) - (CGItem.size.height/2) + t - b;
    
    CGRect newRect = CGRectMake(x, y, w, h);
    
    subView.frame = newRect;
    
}

- (void)setItem:(UIView*)subView inView:(UIView*)viewR side:(NSString*)side UpDown:(NSString*)updown padLeft:(CGFloat)l  padTop:(CGFloat)t padRight:(CGFloat)r padBottom:(CGFloat)b{
    CGRect CGItem = subView.frame;
    CGRect CGView = viewR.frame;
    
    CGFloat newX;
    CGFloat newY;
    
    if([updown isEqualToString:@"up"]){
        newY = CGView.origin.y - CGItem.size.height + t - b;
    }else{
        newY = CGView.origin.y + CGView.size.height + t - b;
    }
    
    if([side isEqualToString:@"left"]){
        newX = CGView.origin.x +l - r;
    }else{
        newX = CGView.origin.x + CGView.size.width - CGItem.size.width + l - r;
    }
    
    CGRect newRect = CGRectMake(newX, newY, CGItem.size.width, CGItem.size.height);
    
    subView.frame = newRect;
    
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
	bgView.hidden = YES;
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
