//
//  DKSecondViewController.m
//  CircularSliderDemo
//
//  Created by dursun koc on 2/21/14.
//  Copyright (c) 2014 aric. All rights reserved.
//

#import "DKSecondViewController.h"
#define COMPONENTRECT CGRectMake(45, 185, DK_SLIDER_SIZE-90, DK_SLIDER_SIZE-90)

@interface DKSecondViewController ()

@end

@implementation DKSecondViewController
@synthesize guidedCSlider;
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    guidedCSlider = [[DKCircularSlider alloc] initWithFrame:COMPONENTRECT
                                               withElements:@[@"Monday",@"Tuesday",@"Wednesday",@"Thursday",@"Friday",@"Saturday",@"Sunday"]
                                           withContentImage:[UIImage imageNamed:@"pawn.png"]
                                                  withTitle:@"Days"
                                                 withTarget:self usingSelector:@selector(sliderChange:)];
    [[self view] addSubview:guidedCSlider];
    [guidedCSlider movehandleToValue:1];
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
