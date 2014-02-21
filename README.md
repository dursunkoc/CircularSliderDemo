CircularSliderDemo
==================
Usage:
import following files
  . DKCircularSlider.h
  . DKCircularSlider.m
  . DKRepeatableButton.h
  . DKRepeatableButton.m
  . down.png
  . up.png
  
  and in your view controller
  
    simpleCSlider = [[DKCircularSlider alloc] initWithFrame:COMPONENTRECT
                                                   usingMax:99
                                                   usingMin:1
                                           withContentImage:[UIImage imageNamed:@"sensitivity"]
                                                  withTitle:@"Sensitivity"];
    [[self view] addSubview:simpleCSlider];
    [simpleCSlider movehandleToValue:10];
    [[self view] setBackgroundColor:[UIColor grayColor]];
