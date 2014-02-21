//
//  RepetableButton.m
//  RepetableButton
//
//  Created by dursun koc on 2/8/14.
//  Copyright (c) 2014 aric. All rights reserved.
//

#import "DKRepeatableButton.h"
#define NRB_SPEED_FACTOR 3

@implementation DKRepetableButton
NSTimer *timer;
static int speed = 0;
- (id)initWithFrame:(CGRect)frame
         withTarget:(id)target
   withRepeatAction:(SEL)repeatAction
          withImage:(UIImage *)image
{
    self = [super initWithFrame:frame];
    if (self!=nil) {
        [self setTarget:target];
        [self setRepeatAction:repeatAction];
        [self setMyImageView:[[UIImageView alloc] initWithImage:image]];
        self.myImageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        [self addSubview: self.myImageView];
    }
    return self;
}

-(void)touchesBegan:(NSSet*)touches  withEvent:(UIEvent*)event {
    timer = [NSTimer scheduledTimerWithTimeInterval:0.2
                                             target:self.target
                                           selector:self.repeatAction
                                           userInfo:nil
                                            repeats:YES];
    [timer setFireDate:[[NSDate alloc] init]];
    [self.myImageView.layer setOpacity:0.4];
}

-(void)touchesEnded:(NSSet*)touches  withEvent:(UIEvent*)event {
    if (timer != nil){
        [timer invalidate];
    }
    timer = nil;
    speed=0;
    [self.myImageView.layer setOpacity:1];
}

-(void)touchesMoved:(NSSet*)touches  withEvent:(UIEvent*)event {
    
}
+(int) getSpeedAndIncreaseSpeed
{
    return ((++speed)/NRB_SPEED_FACTOR);
}

@end
