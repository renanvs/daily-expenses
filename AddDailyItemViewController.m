//
//  AddDailyItemViewController.m
//  daily Expenses
//
//  Created by renan veloso silva on 19/05/13.
//  Copyright (c) 2013 renan veloso silva. All rights reserved.
//

#import "AddDailyItemViewController.h"

@interface AddDailyItemViewController ()

@end

@implementation AddDailyItemViewController
//@synthesize categoryScrollView;


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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)iqualOrAcceptSender:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    numberOfPages = 2;
    _categoryScrollView.pagingEnabled = YES;
    _categoryScrollView.contentSize = CGSizeMake(numberOfPages * categoryView.frame.size.width, 1);
    [_categoryScrollView addSubview:categoryView];
    UIView *view2 = [[[NSBundle mainBundle]loadNibNamed:@"CategoryView" owner:self options:nil] lastObject];
    CGRect rect = [categoryView frame];
    rect.origin.x = 302;
    [view2 setFrame:rect];
    [_categoryScrollView addSubview:view2];
}

- (id)init
{
    self = [super init];
    if (self) {
        categoryView = [[[NSBundle mainBundle] loadNibNamed:@"CategoryView" owner:self options:nil] lastObject];
    }
    return self;
}

@end
