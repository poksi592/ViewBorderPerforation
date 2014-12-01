//
//  UIView+KCRViewUtilites.m
//  Kindred Core
//
//  Created by Mladen Despotovic on 11/05/2014.
//  Copyright 2003-2014 Monitise Group Limited. All Right Reserved.
//
//  Save to the extent permitted by law, you may not use, copy, modify,
//  distribute or create derivative works of this material or any part
//  of it without the prior written consent of Monitise Group Limited.
//  Any reproduction of this material must contain this notice.
//

#import "UIView+KCRViewUtilites.h"
#import <QuartzCore/QuartzCore.h>
#include <math.h>

static id KCRViewUtilitesFoundSubview = nil;
static id KCRViewUtilitiesFoundTopView = nil;


@implementation UIView (KCRViewUtilites)


- (void)cutRoundDiscretePerforationWithRadius:(CGFloat)paramRadius
                               pointsOnCircle:(NSUInteger)paramPoints
                                  onPositions:(KCRPerforationPosition)paramPositions
{
    if (paramPoints < 1) {
        
        return;
    }
    
    CGMutablePathRef perforationPath = CGPathCreateMutable();
    
    __block CGFloat Xpos = 0;
    __block CGFloat Ypos = 0;
    CGFloat lineLength = 0;
    CGFloat radianStep = M_PI / (paramPoints + 1);
    __block NSUInteger numberOfCuts = 0;
    
    void (^CutHorizontalPath)() = ^{
        
        CGPathMoveToPoint(perforationPath, NULL, Xpos, Ypos);
        Xpos = (self.bounds.size.width - (numberOfCuts * paramRadius * 3) - paramRadius) / 2;
        CGPathAddLineToPoint(perforationPath, NULL, Xpos, Ypos);
        
        CGPathMoveToPoint(perforationPath, NULL, Xpos, Ypos);
        
        for (NSInteger cutCounter = 0; cutCounter < numberOfCuts; cutCounter++) {
            
            Xpos += paramRadius;
            CGPathAddLineToPoint(perforationPath, NULL, Xpos, Ypos);
            
            CGFloat currentRadian = 0;
            CGPathMoveToPoint(perforationPath, NULL, Xpos + paramRadius * 2, Ypos);
            for (NSInteger pointCounter = 0; pointCounter < paramPoints; pointCounter++) {
                
                currentRadian += radianStep;
                CGFloat circleX = (Xpos + paramRadius) + (paramRadius * cos(currentRadian));
                CGFloat circleY = Ypos + (paramRadius * sin(currentRadian));
                CGPathAddLineToPoint(perforationPath, NULL, circleX, circleY);
            }
            CGPathAddLineToPoint(perforationPath, NULL, Xpos, Ypos);
            
            Xpos += paramRadius * 2;
            CGPathMoveToPoint(perforationPath, NULL, Xpos, Ypos);
            
        }
        
        if (Xpos < self.bounds.size.width) {
            
            CGPathMoveToPoint(perforationPath, NULL, self.bounds.size.width, Ypos);
            CGPathAddLineToPoint(perforationPath, NULL, Xpos, Ypos);
        }
    };

    
    void (^CutVerticalPath)() = ^{
        
        CGPathMoveToPoint(perforationPath, NULL, Xpos, Ypos);
        Ypos = (self.bounds.size.height - (numberOfCuts * paramRadius * 3) - paramRadius) / 2;
        CGPathAddLineToPoint(perforationPath, NULL, Xpos, Ypos);
        
        CGPathMoveToPoint(perforationPath, NULL, Xpos, Ypos);
        
        for (NSInteger cutCounter = 0; cutCounter < numberOfCuts; cutCounter++) {
            
            Ypos += paramRadius;
            CGPathAddLineToPoint(perforationPath, NULL, Xpos, Ypos);
            
            CGFloat currentRadian = M_PI / 2;
            CGPathMoveToPoint(perforationPath, NULL, Xpos, Ypos + paramRadius * 2);
            for (NSInteger pointCounter = 0; pointCounter < paramPoints; pointCounter++) {
                
                if (paramPositions & KCRPerforationPositionLeft) {
                    
                    currentRadian += radianStep;
                }
                else {
                    
                    currentRadian -= radianStep;
                }
                
          //      currentRadian -= radianStep;
                
                CGFloat circleX = Xpos + (paramRadius * cos(currentRadian));
                CGFloat circleY = Ypos + paramRadius + (paramRadius * sin(currentRadian));
                CGPathAddLineToPoint(perforationPath, NULL, circleX, circleY);
            }
            CGPathAddLineToPoint(perforationPath, NULL, Xpos, Ypos);
            
            Ypos += paramRadius * 2;
            CGPathMoveToPoint(perforationPath, NULL, Xpos, Ypos);
            
        }
        
        if (Ypos < self.bounds.size.height) {
            
            CGPathMoveToPoint(perforationPath, NULL, Xpos, self.bounds.size.height);
            CGPathAddLineToPoint(perforationPath, NULL, Xpos, Ypos);
        }

    };
    
    
    if (paramPositions & KCRPerforationPositionTop) {
        
        lineLength = self.bounds.size.width;
        numberOfCuts = (NSUInteger)(lineLength / (paramRadius * 3));

        CutHorizontalPath();
        
    }
    else {
        
        CGPathMoveToPoint(perforationPath, NULL, 0, 0);
        CGPathAddLineToPoint(perforationPath, NULL, self.bounds.size.width, 0);
    }
    
    if (paramPositions & KCRPerforationPositionRight) {
        
        Xpos = self.bounds.size.width;
        Ypos = 0.f;
        lineLength = self.bounds.size.height;
        numberOfCuts = (NSUInteger)(lineLength / (paramRadius * 3));
    
        CutVerticalPath();

    }
    else {
        
        CGPathMoveToPoint(perforationPath, NULL, self.bounds.size.width, 0);
        CGPathAddLineToPoint(perforationPath, NULL, self.bounds.size.width, self.bounds.size.height);
    }
    
    if (paramPositions & KCRPerforationPositionBottom) {
        
        Xpos = 0.f;
        Ypos = self.bounds.size.height;
        lineLength = self.bounds.size.width;
        numberOfCuts = (NSUInteger)(lineLength / (paramRadius * 3));
        
        CutHorizontalPath();
        
    }
    else {
        
        CGPathMoveToPoint(perforationPath, NULL, self.bounds.size.width, self.bounds.size.height);
        CGPathAddLineToPoint(perforationPath, NULL, 0, self.bounds.size.height);
    }
    
    if (paramPositions & KCRPerforationPositionLeft) {
        
        Xpos = 0;
        Ypos = 0;
        lineLength = self.bounds.size.height;
        numberOfCuts = (NSUInteger)(lineLength / (paramRadius * 3));
        
        CutVerticalPath();
        
    }
    else {
        
        CGPathMoveToPoint(perforationPath, NULL, 0, self.bounds.size.height);
        CGPathAddLineToPoint(perforationPath, NULL, 0, 0);
    }
    
    
    
   
    
 //   CGPathAddRect(perforationPath, NULL, CGRectMake(paramRadius+1, paramRadius+1, self.bounds.size.width - paramRadius*2-2, self.bounds.size.height - paramRadius*2-2));
    
//   CGPathAddLineToPoint(perforationPath, NULL, 0 , 0);

    self.autoresizingMask = NO;
    
    CAShapeLayer *perforationMaskLayer = [CAShapeLayer layer];
    perforationMaskLayer.path = perforationPath;
    CFRelease(perforationPath);
    
//    perforationMaskLayer.frame = CGRectOffset(self.frame, 0.0f, 1.0f);
    perforationMaskLayer.strokeColor = [UIColor blackColor].CGColor;
    perforationMaskLayer.fillColor = [UIColor clearColor].CGColor;
    perforationMaskLayer.fillRule = kCAFillRuleEvenOdd;
    
//    perforationMaskLayer.fillColor = [[UIColor whiteColor] CGColor];
//    perforationMaskLayer.backgroundColor = [[UIColor clearColor] CGColor];
    
//    perforationMaskLayer.opacity = 0;
    
 //   [self.layer addSublayer:perforationMaskLayer];
    
    
//    self.layer.mask = perforationMaskLayer;
    
    
    [self.layer addSublayer:perforationMaskLayer];
}


@end






