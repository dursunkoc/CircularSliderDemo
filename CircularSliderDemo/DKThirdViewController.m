//
//  DKThirdViewController.m
//  CircularSliderDemo
//
//  Created by dursun koc on 2/21/14.
//  Copyright (c) 2014 aric. All rights reserved.
//

#import "DKThirdViewController.h"
#import "DKCircularSlider.h"
#define COMPONENTRECT CGRectMake(45, 185, DK_SLIDER_SIZE-90, DK_SLIDER_SIZE-90)

@interface DKThirdViewController ()
@property (nonatomic,retain) DKCircularSlider *timeCSlider;
@end

@implementation DKThirdViewController
@synthesize timeCSlider;
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
    timeCSlider = [[DKCircularSlider alloc] initWithFrame:COMPONENTRECT
                                                 usingMax:60*60
                                                 usingMin:0
                                   withRepresantationMode:DKCircularSliderRepresantationModeTime
                                         withContentImage:[UIImage imageNamed:@"pawn.png"]
                                                withTitle:@"time" withTarget:self usingSelector:@selector(sliderChange:)];
    [[self view] addSubview:timeCSlider];
    [timeCSlider movehandleToValue:1];
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
