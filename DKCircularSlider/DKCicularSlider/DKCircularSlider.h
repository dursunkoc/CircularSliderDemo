//
//  DKCircularSlider.h
//  DKCircularSlider
//
//  Created by dursun koc on 2/8/14.
//  Copyright (c) 2014 aric. All rights reserved.
//

#import <UIKit/UIKit.h>

#define DK_SLIDER_SIZE 320
#define DK_BACKGROUND_WIDTH 10
#define DK_TOUCHABLE_WIDTH 80
#define DK_LINE_WIDTH 10
#define DK_GUIDE_WIDTH DK_LINE_WIDTH
#define DK_FONTSIZE 80
#define DK_FONTFAMILY @"HelveticaNeue-Light"
#define DK_WFONTSIZEOFFSET 0
#define DK_HFONTSIZEOFFSET 0

#define DK_FONTSIZE_SM 75
#define DK_WFONTSIZEOFFSET_SM 75
#define DK_HFONTSIZEOFFSET_SM 0

#define DK_FONTSIZE_SSM 45
#define DK_WFONTSIZEOFFSET_SSM 75
#define DK_HFONTSIZEOFFSET_SSM 35


@interface DKCircularSlider : UIControl
typedef NS_ENUM(NSInteger, DKCircularSliderRepresantationMode) {
    DKCircularSliderRepresantationModeNormal,
    DKCircularSliderRepresantationModeValues,
    DKCircularSliderRepresantationModeTime
};

@property (nonatomic,assign) float angle;
@property (nonatomic) int currentValue;
@property (nonatomic) float maxValue;
@property (nonatomic) float minValue;
@property (nonatomic) int majorStep;
@property (nonatomic, assign) DKCircularSliderRepresantationMode represantationMode;
@property (nonatomic, assign) id target;
@property (nonatomic, assign) SEL selector;

-(id)initWithFrame:(CGRect)frame
          usingMax:(float) max
          usingMin:(float) min
  withContentImage:(UIImage *)contentImage
         withTitle:(NSString *)title
        withTarget:(id)target
     usingSelector:(SEL)selector;

-(id)initWithFrame:(CGRect)frame
          usingMax:(float) max
          usingMin:(float) min
withRepresantationMode:(DKCircularSliderRepresantationMode)represantationMode
  withContentImage:(UIImage *)contentImage
         withTitle:(NSString *)title
        withTarget:(id)target
     usingSelector:(SEL)selector;

-(id)initWithFrame:(CGRect)frame
      withElements:(NSArray *)elements
  withContentImage:(UIImage *)contentImage
         withTitle:(NSString *)title
        withTarget:(id)target
     usingSelector:(SEL)selector;


-(void)movehandleToValue:(float)value;

-(NSString *) getTextValue;
@end
