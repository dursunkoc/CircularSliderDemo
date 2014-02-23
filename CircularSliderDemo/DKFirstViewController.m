//
//  DKFirstViewController.m
//  CircularSliderDemo
//
//  Created by dursun koc on 2/21/14.
//  Copyright (c) 2014 aric. All rights reserved.
//

#import "DKFirstViewController.h"
#define COMPONENTRECT CGRectMake(45, 185, DK_SLIDER_SIZE-90, DK_SLIDER_SIZE-90)

@interface DKFirstViewController ()

@end

@implementation DKFirstViewController
@synthesize simpleCSlider;
- (void)viewDidLoad
{
    [super viewDidLoad];
    simpleCSlider = [[DKCircularSlider alloc] initWithFrame:COMPONENTRECT
                                                   usingMax:99
                                                   usingMin:1
                                           withContentImage:[UIImage imageNamed:@"sensitivity"]
                                                  withTitle:@"Sensitivity" withTarget:self usingSelector:@selector(sliderChange:)];
    [[self view] addSubview:simpleCSlider];
    [simpleCSlider movehandleToValue:10];
    [[self view] setBackgroundColor:[UIColor grayColor]];
}
-(void)sliderChange:(DKCircularSlider *)sender
{
    NSLog(@"Value Changed (%@)",[sender getTextValue]);
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
