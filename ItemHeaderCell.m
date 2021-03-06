//
//  DailyTableViewHeaderCell.m
//  daily Expenses
//
//  Created by renan veloso silva on 16/07/13.
//  Copyright (c) 2013 renan veloso silva. All rights reserved.
//

#import "ItemHeaderCell.h"

@implementation ItemHeaderCell
@synthesize headerImg;

- (id)init
{
    self = [super init];
    if (self) {
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:@"UIDeviceOrientationDidChangeNotification" object:nil];
        portImg = [UIImage imageNamed:@"dailyCellTopBar.png"];
        landImg = [UIImage imageNamed:@"dailyCellTopBarLand.png"];
        
        UIDeviceOrientation devOri = [[UIDevice currentDevice] orientation];
        
        if (devOri == UIInterfaceOrientationPortrait || devOri == UIInterfaceOrientationPortraitUpsideDown || devOri == UIDeviceOrientationUnknown){
            headerImg.image = portImg;
        }else{
            headerImg.image = landImg;
            
        }
    }
    return self;
}

-(BOOL)shouldAutorotate{
    return YES;
}

-(void)orientationChanged:(NSNotification *)object{
	UIDeviceOrientation devOri = [[object object] orientation];
	
	if (devOri == UIInterfaceOrientationPortrait || devOri == UIInterfaceOrientationPortraitUpsideDown || devOri == UIDeviceOrientationUnknown){
		headerImg.image = portImg;
    }else{
        headerImg.image = landImg;
        
    }
}

@end
