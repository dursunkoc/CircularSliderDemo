//
//  DKCircularSlider.m
//  DKCircularSlider
//
//  Created by dursun koc on 2/8/14.
//  Copyright (c) 2014 aric. All rights reserved.
//

#import "DKCircularSlider.h"
#import "DKRepeatableButton.h"


#define SQR(x)			( (x) * (x) )
#define MAXANGLE 360
#define START_ANGLE 90
#define CLOCK_WISE YES

#define DK_SAFEAREA_PADDING 10
#define DK_RINGPAD 8
#define DK_BTN_PAD 5
#define DK_BTNBASEOFFSET 10
#define DK_CONTENTIMAGEWIDTH  24
#define DK_CONTENTIMAGEHEIGHT  24
#define DK_CONTENTIMAGE_PAD 30
#define DK_CONTENTLABELWIDTH 200
#define DK_BTNWIDTH 60
#define DK_BTNHEIGHT 15
#define DK_DOUBLE_BTN_GAP 100

#define DK_CONTENTLABEL_PAD self.frame.size.height * 8/10
#define DK_CONTENTLABELHEIGHT self.frame.size.height * 1/10
#define CONTENTWIDTH self.frame.size.width
#define CONTENTHEIGHT self.frame.size.height
#define CENTER_POINT CGPointMake(self.frame.size.width/2 - DK_LINE_WIDTH/2, self.frame.size.height/2 - DK_LINE_WIDTH/2);

#pragma mark - Private -

@interface DKCircularSlider(){
    UITextField *_textField;
    int radius;
    NSArray *values;
    NSTimer *timer;
}
@end


#pragma mark - Implementation -

@implementation DKCircularSlider

-(id)initWithFrame:(CGRect)frame
          usingMax:(float) max
          usingMin:(float) min
  withContentImage:(UIImage *)contentImage
         withTitle:(NSString *)title
{
    return [self initWithFrame:frame
                      usingMax:max
                      usingMin:min
        withRepresantationMode:DKCircularSliderRepresantationModeNormal
              withContentImage:contentImage
                     withTitle:title];
}

-(id)initWithFrame:(CGRect)frame
          usingMax:(float) max
          usingMin:(float) min
withRepresantationMode:(DKCircularSliderRepresantationMode)represantationMode
  withContentImage:(UIImage *)contentImage
         withTitle:(NSString *)title{
    self = [super initWithFrame:frame];
    
    if(self){
        self.opaque = NO;
        self.represantationMode = represantationMode;
        radius = self.frame.size.width/2 - DK_SAFEAREA_PADDING;
        
        self.angle = 0;
        self.maxValue = max;
        self.minValue = min;
        
        
        switch (represantationMode) {
            case DKCircularSliderRepresantationModeNormal:
                _textField = [self prepareTextFieldUsingFrame:frame
                                                 withFontName:DK_FONTFAMILY
                                                 withFontSize:DK_FONTSIZE
                                          withWFontSizeOffset:DK_WFONTSIZEOFFSET
                                          withHFontSizeOffset:DK_HFONTSIZEOFFSET];
                [self prepareSingleButtons];
                break;
            case DKCircularSliderRepresantationModeTime:
                self.majorStep = 60;
                _textField = [self prepareTextFieldUsingFrame:frame
                                                 withFontName:DK_FONTFAMILY
                                                 withFontSize:DK_FONTSIZE_SM
                                          withWFontSizeOffset:DK_WFONTSIZEOFFSET_SM
                                          withHFontSizeOffset:DK_HFONTSIZEOFFSET_SM];
                [self prepareMultipleButtons];
                break;
            case DKCircularSliderRepresantationModeValues:
                _textField = [self prepareTextFieldUsingFrame:frame
                                                 withFontName:DK_FONTFAMILY
                                                 withFontSize:DK_FONTSIZE_SSM
                                          withWFontSizeOffset:DK_WFONTSIZEOFFSET_SSM
                                          withHFontSizeOffset:DK_HFONTSIZEOFFSET_SSM];
                [self prepareSingleButtons];
                break;
            default:
                _textField = [self prepareTextFieldUsingFrame:frame
                                                 withFontName:DK_FONTFAMILY
                                                 withFontSize:DK_FONTSIZE
                                          withWFontSizeOffset:DK_WFONTSIZEOFFSET
                                          withHFontSizeOffset:DK_HFONTSIZEOFFSET];
                [self prepareSingleButtons];
                break;
        }
        [self setTextValue];
        [self addSubview:_textField];
        
        UIImageView *ring = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"circle"]];
        ring.frame = CGRectMake(-DK_RINGPAD/2, -DK_RINGPAD/2, CONTENTWIDTH+DK_RINGPAD, CONTENTHEIGHT + DK_RINGPAD);
        [self addSubview: ring];
        
        
        UIImageView *contentImageView =[[UIImageView alloc] initWithFrame:CGRectMake((CONTENTWIDTH-DK_CONTENTIMAGEWIDTH)/2, DK_CONTENTIMAGE_PAD, DK_CONTENTIMAGEWIDTH, DK_CONTENTIMAGEHEIGHT)];
        
        [contentImageView setImage:contentImage];
        [self addSubview:contentImageView];
        
        UILabel *contentLabel =[[UILabel alloc] initWithFrame: CGRectMake((CONTENTWIDTH - DK_CONTENTLABELWIDTH)/2, DK_CONTENTLABEL_PAD, DK_CONTENTLABELWIDTH, DK_CONTENTLABELHEIGHT)];
        [contentLabel setFont:[UIFont fontWithName:DK_FONTFAMILY size:15]];
        [contentLabel setTextColor:[UIColor whiteColor]];
        [contentLabel setTextAlignment:NSTextAlignmentCenter];
        [contentLabel setText:[title uppercaseString]];
        [self addSubview:contentLabel];
    }
    return self;
}

-(void) prepareSingleButtons
{
    
    UIView *btnUp = [self buttonWithTarget:self
                                 WithImage:[UIImage imageNamed:@"up.png"]
                                  WithRect:CGRectMake((CONTENTWIDTH - DK_BTNWIDTH)/2,
                                                      _textField.frame.origin.y - DK_BTN_PAD,
                                                      DK_BTNWIDTH,
                                                      DK_BTNHEIGHT)
                               AndSelector:@selector(increaseValue:)];
    
    UIView *btnDown = [self buttonWithTarget:self
                                   WithImage:[UIImage imageNamed:@"down.png"]
                                    WithRect:CGRectMake((CONTENTWIDTH - DK_BTNWIDTH)/2,
                                                        _textField.frame.origin.y+_textField.frame.size.height + DK_BTN_PAD - DK_BTNBASEOFFSET,
                                                        DK_BTNWIDTH,
                                                        DK_BTNHEIGHT)
                                 AndSelector:@selector(decreaseValue:)];
    
    [self addSubview:btnUp];
    [self addSubview:btnDown];
}


-(void) prepareMultipleButtons
{
    UIImage *upImage = [UIImage imageNamed:@"up.png"];
    UIImage *downImage = [UIImage imageNamed:@"down.png"];
    
    UIView *btnMinorUp = [self buttonWithTarget:self
                                      WithImage:upImage
                                       WithRect:CGRectMake((CONTENTWIDTH - DK_BTNWIDTH+DK_DOUBLE_BTN_GAP)/2,
                                                           _textField.frame.origin.y - DK_BTN_PAD,
                                                           DK_BTNWIDTH,
                                                           DK_BTNHEIGHT)
                                    AndSelector:@selector(increaseValue:)];
    
    UIView *btnMinorDown = [self buttonWithTarget:self
                                        WithImage:downImage
                                         WithRect:CGRectMake((CONTENTWIDTH - DK_BTNWIDTH+DK_DOUBLE_BTN_GAP)/2,
                                                             _textField.frame.origin.y+_textField.frame.size.height + DK_BTN_PAD - DK_BTNBASEOFFSET,
                                                             DK_BTNWIDTH,
                                                             DK_BTNHEIGHT)
                                      AndSelector:@selector(decreaseValue:)];
    
    UIView *btnMajorUp = [self buttonWithTarget:self
                                      WithImage:upImage
                                       WithRect:CGRectMake((CONTENTWIDTH - DK_BTNWIDTH-DK_DOUBLE_BTN_GAP)/2,
                                                           _textField.frame.origin.y - DK_BTN_PAD,
                                                           DK_BTNWIDTH,
                                                           DK_BTNHEIGHT)
                                    AndSelector:@selector(increaseMajorValue:)];
    
    UIView *btnMajorDown = [self buttonWithTarget:self
                                        WithImage:downImage
                                         WithRect:CGRectMake((CONTENTWIDTH - DK_BTNWIDTH-DK_DOUBLE_BTN_GAP)/2,
                                                             _textField.frame.origin.y+_textField.frame.size.height + DK_BTN_PAD - DK_BTNBASEOFFSET,
                                                             DK_BTNWIDTH,
                                                             DK_BTNHEIGHT)
                                      AndSelector:@selector(decreaseMajorValue:)];
    [self addSubview:btnMinorUp];
    [self addSubview:btnMinorDown];
    [self addSubview:btnMajorUp];
    [self addSubview:btnMajorDown];

}


-(void)increaseValue:(UIButton *)sender
{
    float val = self.currentValue + 1 + [DKRepetableButton getSpeedAndIncreaseSpeed] ;
    [self movehandleToValue:val];
}
-(void)decreaseValue:(UIButton *)sender
{
    float val = self.currentValue - 1 + [DKRepetableButton getSpeedAndIncreaseSpeed] ;
    [self movehandleToValue:val];
}


-(void)increaseMajorValue:(UIButton *)sender
{
    float val = self.currentValue + self.majorStep ;
    [self movehandleToValue:val];
}
-(void)decreaseMajorValue:(UIButton *)sender
{
    float val = self.currentValue - self.majorStep ;
    [self movehandleToValue:val];
}


-(id)initWithFrame:(CGRect)frame
      withElements:(NSArray *)elements
  withContentImage:(UIImage *)contentImage
         withTitle:(NSString *)title
{
    self = [self initWithFrame:frame
                      usingMax:elements.count
                      usingMin:1
        withRepresantationMode:DKCircularSliderRepresantationModeValues
              withContentImage:contentImage
                     withTitle:title];
    
    if (self) {
        values = elements;
    }
    return self;
}

-(UIView *) buttonWithTarget:(id)target
                   WithImage:(UIImage *)image
                    WithRect:(CGRect)rect
                 AndSelector:(SEL)selector
{
    DKRepetableButton *nrBtn = [[DKRepetableButton alloc] initWithFrame:rect
                                                                 withTarget:target
                                                           withRepeatAction:selector
                                                                  withImage:image];
    return nrBtn;
}

-(UITextField *) prepareTextFieldUsingFrame:(CGRect)frame
                               withFontName:(NSString*)fontFamilyName
                               withFontSize:(int)fontSizeInt
                        withWFontSizeOffset:(int)wFontOffset
                        withHFontSizeOffset:(int)hFontOffset
{
    NSString *str = @"000000";
    UIFont *font = [UIFont fontWithName:fontFamilyName size:fontSizeInt];
    CGSize fontSize = [str sizeWithAttributes:@{NSFontAttributeName:font}];
    UITextField * textField = [[UITextField alloc]initWithFrame:CGRectMake((frame.size.width - wFontOffset - fontSize.width) /2,
                                                                           (frame.size.height - hFontOffset - fontSize.height) /2,
                                                                           fontSize.width+wFontOffset,
                                                                           fontSize.height+hFontOffset)];
    textField.font = font;
    textField.backgroundColor = [UIColor clearColor];
    textField.textColor = [UIColor colorWithWhite:1 alpha:0.8];
    textField.textAlignment = NSTextAlignmentCenter;
    textField.enabled = NO;
    return textField;
}

-(void) setTextValue
{
    switch (self.represantationMode) {
        case DKCircularSliderRepresantationModeNormal:{
            _textField.text = [NSString stringWithFormat:@"%d",self.currentValue];
            break;
        }
        case DKCircularSliderRepresantationModeTime:{
            int minutes = self.currentValue / self.majorStep;
            int seconds = self.currentValue % self.majorStep;
            _textField.text = [NSString stringWithFormat:@"%02d:%02d",minutes,seconds];
            break;
        }
        case DKCircularSliderRepresantationModeValues:{
            _textField.text = [values objectAtIndex:self.currentValue-1];
            break;
        }
        default:
            _textField.text = [NSString stringWithFormat:@"%d",self.currentValue];
            break;
    }
}

-(NSString *) getTextValue
{
    return _textField.text;
}

#pragma mark - UIControl Override -

-(BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [super beginTrackingWithTouch:touch withEvent:event];
    return YES;
}

-(BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [super continueTrackingWithTouch:touch withEvent:event];
    
    CGPoint centerOfCicrle = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    CGPoint touchLocation = [touch locationInView:self];
    //    NSLog(@"Center %.2f:%.2f; Touch %.2f:%.2f", centerOfCicrle.x, centerOfCicrle.y, touchLocation.x, touchLocation.y);
    
    float distanceFromCenter = [self distanceFrom:centerOfCicrle To:touchLocation];
    
    float precisionFact = fabsf(distanceFromCenter - radius);
    
    if (precisionFact <= DK_TOUCHABLE_WIDTH/2) {
        [self movehandle:touchLocation];
        [self sendActionsForControlEvents:UIControlEventValueChanged];
        return YES;
    }else{
        return YES;
    }
}

-(float) distanceFrom:(CGPoint) p1 To:(CGPoint) p2{
    CGFloat xDist = (p1.x - p2.x);
    CGFloat yDist = (p1.y - p2.y);
    float distance = sqrt((xDist * xDist) + (yDist * yDist));
    //    NSLog(@" distance is %.2f", distance);
    return distance;
}

-(void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [super endTrackingWithTouch:touch withEvent:event];
    
}


#pragma mark - Drawing Functions -

-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextAddArc(ctx,
                    self.frame.size.width/2,
                    self.frame.size.height/2,
                    radius,
                    0,
                    M_PI *2,
                    0);
    [[UIColor blackColor]setStroke];
    CGContextSetLineWidth(ctx, DK_BACKGROUND_WIDTH);
    CGContextSetLineCap(ctx, kCGLineCapButt);
    CGContextDrawPath(ctx, kCGPathStroke);
    
    UIGraphicsBeginImageContext(self.frame.size);
    CGContextRef imageCtx = UIGraphicsGetCurrentContext();
    CGContextAddArc(imageCtx,
                    self.frame.size.width/2,
                    self.frame.size.height/2,
                    radius,
                    [DKCircularSlider toRad: START_ANGLE withMax:MAXANGLE],
                    CLOCK_WISE?
                    [DKCircularSlider toRad: START_ANGLE - self.angle withMax:MAXANGLE]
                    :[DKCircularSlider toRad: START_ANGLE + self.angle withMax:MAXANGLE],
                    CLOCK_WISE?1:0);
    
    CGContextSetLineWidth(imageCtx, DK_LINE_WIDTH);
    CGContextDrawPath(imageCtx, kCGPathStroke);
    
    CGImageRef mask = CGBitmapContextCreateImage(UIGraphicsGetCurrentContext());
    UIGraphicsEndImageContext();
    
    
    
    CGContextSaveGState(ctx);
    
    CGContextClipToMask(ctx, self.bounds, mask);
    CGImageRelease(mask);
    
    
    
    CGFloat components[8] = {
        0.0, 1.0, 1.0, 1.0,
        0.0, 0.0, 1.0, 1.0 };
    
    CGColorSpaceRef baseSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(baseSpace, components, NULL, 2);
    CGColorSpaceRelease(baseSpace), baseSpace = NULL;
    
    CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
    
    CGContextDrawLinearGradient(ctx, gradient, startPoint, endPoint, 0);
    CGGradientRelease(gradient), gradient = NULL;
    CGContextRestoreGState(ctx);
    
    
    CGContextSetLineWidth(ctx, 1);
    CGContextSetLineCap(ctx, kCGLineCapRound);
    
    CGContextBeginPath(ctx);
    CGContextAddArc(ctx,
                    self.frame.size.width/2,
                    self.frame.size.height/2,
                    (radius-DK_BACKGROUND_WIDTH/2),
                    0,
                    [DKCircularSlider toRad:(-self.angle)  withMax:MAXANGLE],
                    1);
    [[UIColor colorWithWhite:1.0 alpha:0.05]set];
    CGContextDrawPath(ctx, kCGPathStroke);
    
    CGContextBeginPath(ctx);
    CGContextAddArc(ctx,
                    self.frame.size.width/2,
                    self.frame.size.height/2,
                    (radius-DK_BACKGROUND_WIDTH/2),
                    0,
                    [DKCircularSlider toRad:(-self.angle)  withMax:MAXANGLE],
                    1);
    [[UIColor colorWithWhite:1.0 alpha:0.05]set];
    CGContextDrawPath(ctx, kCGPathStroke);
    
    
    [self drawGuide:CGPointMake(self.frame.size.width/2,
                                self.frame.size.height/2)
          onContext:ctx];
    
}

- (void)drawGuide:(CGPoint)point onContext:(CGContextRef) context
{
    CGContextBeginPath(context);
    CGContextSetLineCap(context, kCGLineCapSquare);
    CGContextSetLineWidth(context, DK_GUIDE_WIDTH);
    if (values!=nil) {
        float sliceAngle = (float)MAXANGLE/(float)values.count;
        for (int x=1; x<=values.count; x++) {
            float currentAngle = (sliceAngle * (float)x)+(START_ANGLE*2.0);
            
            [[UIColor whiteColor]set];
            CGContextAddArc(context,
                            point.x,
                            point.y,
                            radius,
                            [DKCircularSlider toRad:START_ANGLE + currentAngle withMax:MAXANGLE],
                            [DKCircularSlider toRad:START_ANGLE + currentAngle+.1 withMax:MAXANGLE],
                            0);
            CGContextStrokePath(context);
        }
    }
}

#pragma mark - Math -

+(float) toRad:(float)deg  withMax:(float)max{
    return ( (M_PI * (deg)) / (max/2) );
}

+(float) toDeg:(float)rad withMax:(float)max
{
    return ( ((max/2) * (rad)) / M_PI );
}

-(void)movehandle:(CGPoint)lastPoint{
    
    CGPoint centerPoint = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    float currentAngle = AngleFromNorth(centerPoint, lastPoint, MAXANGLE);
    float angleInt = currentAngle;
    
    float angleNext;
    angleNext = MAXANGLE - angleInt;
    
    float value = round((angleNext * self.maxValue)/MAXANGLE);
    [self movehandleToValue:value];
}

-(void)movehandleToValue:(float)value{
    if (value>self.maxValue) {
        value=self.maxValue;
    }else if (value<self.minValue){
        value= self.minValue;
    }
    self.currentValue = value;
    self.angle = ((self.currentValue * MAXANGLE)/self.maxValue);
    
    [self setTextValue];
    [self setNeedsDisplay];
}

-(CGPoint)pointFromAngle:(float)angleInt{
    CGPoint centerPoint = CENTER_POINT;
    CGPoint result;
    result.y = centerPoint.y + radius * sin([DKCircularSlider toRad:(-angleInt) withMax:MAXANGLE]);
    result.x = centerPoint.x + radius * cos([DKCircularSlider toRad:(-angleInt) withMax:MAXANGLE]);
    
    return result;
}

static inline float AngleFromNorth(CGPoint p1, CGPoint p2, float max) {
    CGPoint v = CGPointMake(p2.x-p1.x,p2.y-p1.y);
    float vmag = sqrt(SQR(v.x) + SQR(v.y)), result = 0;
    v.x /= vmag;
    v.y /= vmag;
    double radians = atan2(v.y,v.x);
    result = [DKCircularSlider toDeg:(radians)  withMax:max] + START_ANGLE;
    result = (result >=0  ? result : result + max);
    if (CLOCK_WISE) {
        result = MAXANGLE - result;
    }
    return (result >=0  ? result : result + max);
}
@end


