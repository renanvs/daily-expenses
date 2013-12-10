//
//  DailyTableViewCell.m
//  daily Expenses
//
//  Created by renan veloso silva on 18/05/13.
//  Copyright (c) 2013 renan veloso silva. All rights reserved.
//

#import "DailyTableViewCell.h"
#import "PopoverView.h"
#import "PopoverDaily.h"

@implementation DailyTableViewCell

#pragma mark - init methods

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
       [self addGesture];
    }
    return self;
}

-(void)addGesture{
    UILongPressGestureRecognizer *tap = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    [self addGestureRecognizer:[tap autorelease]];
}

#pragma mark - popover

- (void)tapped:(UITapGestureRecognizer *)tap
{
    if (tap.state == UIGestureRecognizerStateEnded) {
        NSLog(@"UIGestureRecognizerStateEnded");
    }
    else if (tap.state == UIGestureRecognizerStateBegan){
        NSLog(@"UIGestureRecognizerStateBegan.");
        point = [tap locationInView:self.popoverView];
        PopoverDaily *test = [[PopoverDaily alloc] initWithId:_item.item_id];
        [PopoverView showPopoverAtPoint:point inView:self.popoverView withContentView:test.view delegate:nil];    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)dealloc {
    [_typeView release];
    [super dealloc];
}
@end
