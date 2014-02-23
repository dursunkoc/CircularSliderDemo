//
//  RepetableButton.h
//  RepetableButton
//
//  Created by dursun koc on 2/8/14.
//  Copyright (c) 2014 aric. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DKRepeatableButton : UIButton
@property (nonatomic) SEL repeatAction;
@property (nonatomic) id target;
@property (nonatomic) UIImageView *myImageView;

- (id)initWithFrame:(CGRect)frame withTarget:(id)target withRepeatAction:(SEL)repeatAction withImage:(UIImage *)image;

+(int) getSpeedAndIncreaseSpeed;
@end
